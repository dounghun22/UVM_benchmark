#include <cstdio>
#include <cuda.h>
#include <cuda_runtime.h>
#include <string>
#include <cstring>
#include "graph.h"
#include "bfsCPU.h"
#include "bfsCUDA.cuh"


void runCpu(int startVertex, Graph &G, std::vector<int> &distance,
            std::vector<int> &parent, std::vector<bool> &visited) {
    printf("Starting sequential bfs.\n");
    auto start = std::chrono::steady_clock::now();
    bfsCPU(startVertex, G, distance, parent, visited);
    auto end = std::chrono::steady_clock::now();
    long duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
    printf("Elapsed time in milliseconds : %li ms.\n\n", duration);
}


#define checkError(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true)
{
   if (code != cudaSuccess) 
   {
      fprintf(stderr,"GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
      if (abort) exit(code);
   }

}

int *d_adjacencyList;
int *d_edgesOffset;
int *d_edgesSize;
int *d_distance;
int *d_parent;
int *d_currentQueue;
int *d_nextQueue;
int *d_degrees;

int *incrDegrees;


void initCuda(Graph &G) {
    checkError(cudaMalloc((void **)&d_adjacencyList, G.numEdges * sizeof(int) ));
    checkError(cudaMalloc((void **)&d_edgesOffset, G.numVertices * sizeof(int) ));
    checkError(cudaMalloc((void **)&d_edgesSize, G.numVertices * sizeof(int)) );
    checkError(cudaMalloc((void **)&d_distance, G.numVertices * sizeof(int) ));
    checkError(cudaMalloc((void **)&d_parent, G.numVertices * sizeof(int) ));
    checkError(cudaMalloc((void **)&d_currentQueue, G.numVertices * sizeof(int) ));
    checkError(cudaMalloc((void **)&d_nextQueue, G.numVertices * sizeof(int) ));
    checkError(cudaMalloc((void **)&d_degrees, G.numVertices * sizeof(int) ));
    checkError(cudaMallocHost((void **) &incrDegrees, sizeof(int) * G.numVertices));

    checkError(cudaMemcpy(d_adjacencyList, G.adjacencyList.data(), G.numEdges * sizeof(int), cudaMemcpyHostToDevice));
    checkError(cudaMemcpy(d_edgesOffset, G.edgesOffset.data(), G.numVertices * sizeof(int), cudaMemcpyHostToDevice));
    checkError(cudaMemcpy(d_edgesSize, G.edgesSize.data(), G.numVertices * sizeof(int), cudaMemcpyHostToDevice ));

}

void finalizeCuda() {

    checkError(cudaFree(d_adjacencyList));
    checkError(cudaFree(d_edgesOffset));
    checkError(cudaFree(d_edgesSize));
    checkError(cudaFree(d_distance));
    checkError(cudaFree(d_parent));
    checkError(cudaFree(d_currentQueue));
    checkError(cudaFree(d_nextQueue));
    checkError(cudaFree(d_degrees));
    checkError(cudaFreeHost(incrDegrees));
    
}



void checkOutput(std::vector<int> &distance, std::vector<int> &expectedDistance, Graph &G) {
    for (int i = 0; i < G.numVertices; i++) {
        if (distance[i] != expectedDistance[i]) {
            printf("%d %d %d\n", i, distance[i], expectedDistance[i]);
            printf("Wrong output!\n");
            exit(1);
        }
    }

    printf("Output OK!\n\n");
}


void initializeCudaBfs(int startVertex, std::vector<int> &distance, std::vector<int> &parent, Graph &G) {
    //initialize values
    std::fill(distance.begin(), distance.end(), std::numeric_limits<int>::max());
    std::fill(parent.begin(), parent.end(), std::numeric_limits<int>::max());
    distance[startVertex] = 0;
    parent[startVertex] = 0;

    checkError(cudaMemcpy(d_distance, distance.data(), G.numVertices * sizeof(int), cudaMemcpyHostToDevice));
    checkError(cudaMemcpy(d_parent, parent.data(), G.numVertices * sizeof(int), cudaMemcpyHostToDevice));

    int firstElementQueue = startVertex;
    cudaMemcpy(d_currentQueue, &firstElementQueue, sizeof(int), cudaMemcpyHostToDevice);
}

void finalizeCudaBfs(std::vector<int> &distance, std::vector<int> &parent, Graph &G) {
    //copy memory from device
    checkError(cudaMemcpy(distance.data(), d_distance, G.numVertices * sizeof(int), cudaMemcpyDeviceToHost));
    checkError(cudaMemcpy(parent.data(), d_parent, G.numVertices * sizeof(int), cudaMemcpyDeviceToHost));
}

void runCudaSimpleBfs(int startVertex, Graph &G, std::vector<int> &distance,
                      std::vector<int> &parent) {
    initializeCudaBfs(startVertex, distance, parent, G);

    int *changed;
    checkError(cudaMallocHost((void **) &changed, sizeof(int)));

    //launch kernel
    printf("Starting simple parallel bfs.\n");
    auto start = std::chrono::steady_clock::now();

    *changed = 1;
    int level = 0;
    while (*changed) {
        *changed = 0;
        // void *args[] = {&G.numVertices, &level, &d_adjacencyList, &d_edgesOffset, &d_edgesSize, &d_distance, &d_parent,
        //                 &changed};
        // checkError(cuLaunchKernel(cuSimpleBfs, G.numVertices / 1024 + 1, 1, 1,
        //                           1024, 1, 1, 0, 0, args, 0));

        simpleBfs<<<G.numVertices / 1024 + 1, 1024>>>(G.numVertices, level, d_adjacencyList, d_edgesOffset, d_edgesSize, d_distance, d_parent, changed);                 
        cudaDeviceSynchronize();
        level++;
    }

    auto end = std::chrono::steady_clock::now();
    long duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
    printf("Elapsed time in milliseconds : %li ms.\n", duration);

    finalizeCudaBfs(distance, parent, G);
}


void runCudaQueueBfs(int startVertex, Graph &G, std::vector<int> &distance,
    std::vector<int> &parent) {
    initializeCudaBfs(startVertex, distance, parent, G);

    int *nextQueueSize;
    checkError(cudaMallocHost((void **)&nextQueueSize, sizeof(int)));
    //launch kernel
    printf("Starting queue parallel bfs.\n");
    auto start = std::chrono::steady_clock::now();

    int queueSize = 1;
    *nextQueueSize = 0;
    int level = 0;
    while (queueSize) {

        queueBfs<<<queueSize / 1024 + 1, 1024>>>(level, d_adjacencyList, d_edgesOffset, d_edgesSize, d_distance, d_parent, queueSize,
                                                nextQueueSize, d_currentQueue, d_nextQueue);
        cudaDeviceSynchronize();
        level++;
        queueSize = *nextQueueSize;
        *nextQueueSize = 0;
        std::swap(d_currentQueue, d_nextQueue);
    }


    auto end = std::chrono::steady_clock::now();
    long duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
    printf("Elapsed time in milliseconds : %li ms.\n", duration);
    finalizeCudaBfs(distance, parent, G);
}

void nextLayer(int level, int queueSize) {
    // void *args[] = {&level, &d_adjacencyList, &d_edgesOffset, &d_edgesSize, &d_distance, &d_parent, &queueSize,
    // &d_currentQueue};
    // checkError(cuLaunchKernel(cuNextLayer, queueSize / 1024 + 1, 1, 1,
    //             1024, 1, 1, 0, 0, args, 0),
    // "cannot run kernel cuNextLayer");
    // cuCtxSynchronize();
    nextLayer<<<queueSize / 1024 + 1, 1024>>>(level, d_adjacencyList, d_edgesOffset, d_edgesSize, d_distance, d_parent, queueSize,
                                            d_currentQueue);
    cudaDeviceSynchronize();

}

void countDegrees(int level, int queueSize) {
    // void *args[] = {&d_adjacencyList, &d_edgesOffset, &d_edgesSize, &d_parent, &queueSize,
    // &d_currentQueue, &d_degrees};
    // checkError(cuLaunchKernel(cuCountDegrees, queueSize / 1024 + 1, 1, 1,
    //             1024, 1, 1, 0, 0, args, 0),
    // "cannot run kernel cuNextLayer");
    // cuCtxSynchronize();

    countDegrees<<<queueSize / 1024 + 1, 1024>>>(d_adjacencyList, d_edgesOffset, d_edgesSize, d_parent, queueSize,
        d_currentQueue, d_degrees);
    cudaDeviceSynchronize();

}

void scanDegrees(int queueSize) {
//run kernel so every block in d_currentQueue has prefix sums calculated
    // void *args[] = {&queueSize, &d_degrees, &incrDegrees};
    // checkError(cuLaunchKernel(cuScanDegrees, queueSize / 1024 + 1, 1, 1,
    //             1024, 1, 1, 0, 0, args, 0), "cannot run kernel scanDegrees");
    // cuCtxSynchronize();
    scanDegrees<<<queueSize / 1024 + 1, 1024>>>(queueSize, d_degrees, incrDegrees);
    cudaDeviceSynchronize();
    //count prefix sums on CPU for ends of blocks exclusive
    //already written previous block sum
    incrDegrees[0] = 0;
    for (int i = 1024; i < queueSize + 1024; i += 1024) {
        incrDegrees[i / 1024] += incrDegrees[i / 1024 - 1];
    }
}

void assignVerticesNextQueue(int queueSize, int nextQueueSize) {
    // void *args[] = {&d_adjacencyList, &d_edgesOffset, &d_edgesSize, &d_parent, &queueSize, &d_currentQueue,
    // &d_nextQueue, &d_degrees, &incrDegrees, &nextQueueSize};
    // checkError(cuLaunchKernel(cuAssignVerticesNextQueue, queueSize / 1024 + 1, 1, 1,
    //             1024, 1, 1, 0, 0, args, 0),
    // "cannot run kernel assignVerticesNextQueue");
    // cuCtxSynchronize();

    assignVerticesNextQueue<<<queueSize / 1024 + 1, 1024>>>(d_adjacencyList, d_edgesOffset, d_edgesSize, d_parent, queueSize, d_currentQueue,
        d_nextQueue, d_degrees, incrDegrees, nextQueueSize);
    cudaDeviceSynchronize();



}

void runCudaScanBfs(int startVertex, Graph &G, std::vector<int> &distance,
   std::vector<int> &parent) {
    initializeCudaBfs(startVertex, distance, parent, G);

    //launch kernel
    printf("Starting scan parallel bfs.\n");
    auto start = std::chrono::steady_clock::now();

    int queueSize = 1;
    int nextQueueSize = 0;
    int level = 0;
    while (queueSize) {
        // next layer phase
        nextLayer(level, queueSize);
        // counting degrees phase
        countDegrees(level, queueSize);
        // doing scan on degrees
        scanDegrees(queueSize);
        nextQueueSize = incrDegrees[(queueSize - 1) / 1024 + 1];
        // assigning vertices to nextQueue
        assignVerticesNextQueue(queueSize, nextQueueSize);

        level++;
        queueSize = nextQueueSize;
        std::swap(d_currentQueue, d_nextQueue);
    }


    auto end = std::chrono::steady_clock::now();
    long duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
    printf("Elapsed time in milliseconds : %li ms.\n", duration);
    finalizeCudaBfs(distance, parent, G);
}


int main(int argc, char **argv) {

    // read graph from standard input
    Graph G;
    int startVertex = atoi(argv[1]);
    readGraph(G, argc, argv);

    printf("Number of vertices %d\n", G.numVertices);
    printf("Number of edges %d\n\n", G.numEdges);

    //vectors for results
    std::vector<int> distance(G.numVertices, std::numeric_limits<int>::max());
    std::vector<int> parent(G.numVertices, std::numeric_limits<int>::max());
    std::vector<bool> visited(G.numVertices, false);

    //run CPU sequential bfs
    runCpu(startVertex, G, distance, parent, visited);

    //save results from sequential bfs
    std::vector<int> expectedDistance(distance);
    std::vector<int> expectedParent(parent);

    initCuda(G);
    //run CUDA simple parallel bfs
    runCudaSimpleBfs(startVertex, G, distance, parent);
    checkOutput(distance, expectedDistance, G);

    // //run CUDA queue parallel bfs
    runCudaQueueBfs(startVertex, G, distance, parent);
    checkOutput(distance, expectedDistance, G);

    // // //run CUDA scan parallel bfs
    runCudaScanBfs(startVertex, G, distance, parent);
    checkOutput(distance, expectedDistance, G);

    finalizeCuda();
    return 0;
}


