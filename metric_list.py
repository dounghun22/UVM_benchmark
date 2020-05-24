metrics = [
     ' --metrics achieved_occupancy ',  # 0
     ' --metrics atomic_transactions ',  # 1
     ' --metrics atomic_transactions_per_request ',  # 2
     ' --metrics branch_efficiency ',  # 3
     ' --metrics cf_executed   ',  # 4
     ' --metrics cf_fu_utilization ',  # 5
     ' --metrics cf_issued   ',  # 6
     ' --metrics double_precision_fu_utilization ',  # 7
     ' --metrics dram_read_bytes ',  # 8
     ' --metrics dram_read_throughput ',  # 9
     ' --metrics dram_read_transactions ',  # 10
     ' --metrics dram_utilization ',  # 11
     ' --metrics dram_write_bytes ',  # 12
     ' --metrics dram_write_throughput ',  # 13
     ' --metrics dram_write_transactions ',  # 14
     ' --metrics eligible_warps_per_cycle ',  # 15
     ' --metrics flop_count_dp ',  # 16
     ' --metrics flop_count_dp_add   ',  # 17
     ' --metrics flop_count_dp_fma  ',  # 18
     ' --metrics flop_count_dp_mul ',  # 19
     ' --metrics flop_count_hp ',  # 20
     ' --metrics flop_count_hp_add   ',  # 21
     ' --metrics flop_count_hp_fma  ',  # 22
     ' --metrics flop_count_hp_mul ',  # 23
     ' --metrics flop_count_sp ',  # 24
     ' --metrics flop_count_sp_add   ',  # 25
     ' --metrics flop_count_sp_fma  ',  # 26
     ' --metrics flop_count_sp_mul ',  # 27
     ' --metrics flop_count_sp_special ',  # 28
     ' --metrics flop_dp_efficiency ',  # 29
     ' --metrics flop_hp_efficiency ',  # 30
     ' --metrics flop_sp_efficiency ',  # 31
     ' --metrics gld_efficiency ',  # 32
     ' --metrics gld_requested_throughput ',  # 33
     ' --metrics gld_throughput ',  # 34
     ' --metrics gld_transactions ',  # 35
     ' --metrics gld_transactions_per_request ',  # 36
     ' --metrics global_atomic_requests ',  # 37
     ' --metrics global_hit_rate ',  # 38
     ' --metrics global_load_requests ',  # 39
     ' --metrics global_reduction_requests ',  # 40
     ' --metrics global_store_requests ',  # 41
     ' --metrics gst_efficiency ',  # 42
     ' --metrics gst_requested_throughput ',  # 43
     ' --metrics gst_throughput ',  # 44
     ' --metrics gst_transactions ',  # 45
     ' --metrics gst_transactions_per_request ',  # 46
     ' --metrics half_precision_fu_utilization ',  # 47
     ' --metrics inst_bit_convert ',  # 48
     ' --metrics inst_compute_ld_st ',  # 49
     ' --metrics inst_control ',  # 50
     ' --metrics inst_executed   ',  # 51
     ' --metrics inst_executed_global_atomics ',  # 52
     ' --metrics inst_executed_global_loads ',  # 53
     ' --metrics inst_executed_global_reductions ',  # 54
     ' --metrics inst_executed_global_stores ',  # 55
     ' --metrics inst_executed_local_loads ',  # 56
     ' --metrics inst_executed_local_stores ',  # 57
     ' --metrics inst_executed_shared_atomics ',  # 58
     ' --metrics inst_executed_shared_loads ',  # 59
     ' --metrics inst_executed_shared_stores ',  # 60
     ' --metrics inst_executed_surface_atomics ',  # 61
     ' --metrics inst_executed_surface_loads ',  # 62
     ' --metrics inst_executed_surface_reductions ',  # 63
     ' --metrics inst_executed_surface_stores ',  # 64
     ' --metrics inst_executed_tex_ops ',  # 65
     ' --metrics inst_fp_16 ',  # 66
     ' --metrics inst_fp_32 ',  # 67
     ' --metrics inst_fp_64 ',  # 68
     ' --metrics inst_integer ',  # 69
     ' --metrics inst_inter_thread_communication ',  # 70
     ' --metrics inst_issued   ',  # 71
     ' --metrics inst_misc   ',  # 72
     ' --metrics inst_per_warp ',  # 73
     ' --metrics inst_replay_overhead   ',  # 74
     ' --metrics ipc   ',  # 75
     ' --metrics issue_slot_utilization ',  # 76
     ' --metrics issue_slots ',  # 77
     ' --metrics issued_ipc   ',  # 78
     ' --metrics l2_atomic_throughput ',  # 79
     ' --metrics l2_atomic_transactions ',  # 80
     ' --metrics l2_global_atomic_store_bytes ',  # 81
     ' --metrics l2_global_load_bytes ',  # 82
     ' --metrics l2_local_global_store_bytes ',  # 83
     ' --metrics l2_local_load_bytes ',  # 84
     ' --metrics l2_read_throughput ',  # 85
     ' --metrics l2_read_transactions ',  # 86
     ' --metrics l2_surface_load_bytes ',  # 87
     ' --metrics l2_surface_store_bytes ',  # 88
     ' --metrics l2_tex_hit_rate ',  # 89
     ' --metrics l2_tex_read_hit_rate ',  # 90
     ' --metrics l2_tex_read_throughput ',  # 91
     ' --metrics l2_tex_read_transactions ',  # 92
     ' --metrics l2_tex_write_hit_rate ',  # 93
     ' --metrics l2_tex_write_throughput ',  # 94
     ' --metrics l2_tex_write_transactions ',  # 95
     ' --metrics l2_utilization ',  # 96
     ' --metrics l2_write_throughput ',  # 97
     ' --metrics l2_write_transactions ',  # 98
     ' --metrics ldst_executed   ',  # 99
     ' --metrics ldst_fu_utilization ',  # 100
     ' --metrics ldst_issued   ',  # 101
     ' --metrics local_hit_rate ',  # 102
     ' --metrics local_load_requests ',  # 103
     ' --metrics local_load_throughput ',  # 104
     ' --metrics local_load_transactions ',  # 105
     ' --metrics local_load_transactions_per_request ',  # 106
     ' --metrics local_memory_overhead   ',  # 107
     ' --metrics local_store_requests ',  # 108
     ' --metrics local_store_throughput ',  # 109
     ' --metrics local_store_transactions ',  # 110
     ' --metrics local_store_transactions_per_request ',  # 111
     ' --metrics nvlink_overhead_data_received   ',  # 112
     ' --metrics nvlink_overhead_data_transmitted   ',  # 113
     ' --metrics nvlink_receive_throughput ',  # 114
     ' --metrics nvlink_total_data_received   ',  # 115
     ' --metrics nvlink_total_data_transmitted   ',  # 116
     ' --metrics nvlink_total_nratom_data_transmitted   ',  # 117
     ' --metrics nvlink_total_ratom_data_transmitted   ',  # 118
     ' --metrics nvlink_total_response_data_received   ',  # 119
     ' --metrics nvlink_total_write_data_transmitted   ',  # 120
     ' --metrics nvlink_transmit_throughput ',  # 121
     ' --metrics nvlink_user_data_received   ',  # 122
     ' --metrics nvlink_user_data_transmitted   ',  # 123
     ' --metrics nvlink_user_nratom_data_transmitted   ',  # 124
     ' --metrics nvlink_user_ratom_data_transmitted   ',  # 125
     ' --metrics nvlink_user_response_data_received   ',  # 126
     ' --metrics nvlink_user_write_data_transmitted   ',  # 127
     ' --metrics pcie_total_data_received   ',  # 128
     ' --metrics pcie_total_data_transmitted   ',  # 129
     ' --metrics shared_efficiency ',  # 130
     ' --metrics shared_load_throughput ',  # 131
     ' --metrics shared_load_transactions ',  # 132
     ' --metrics shared_load_transactions_per_request ',  # 133
     ' --metrics shared_store_throughput ',  # 134
     ' --metrics shared_store_transactions ',  # 135
     ' --metrics shared_store_transactions_per_request ',  # 136
     ' --metrics shared_utilization ',  # 137
     ' --metrics single_precision_fu_utilization ',  # 138
     ' --metrics sm_efficiency ',  # 139
     ' --metrics special_fu_utilization ',  # 140
     ' --metrics stall_constant_memory_dependency ',  # 141
     ' --metrics stall_exec_dependency ',  # 142
     ' --metrics stall_inst_fetch ',  # 143
     ' --metrics stall_memory_dependency ',  # 144
     ' --metrics stall_memory_throttle ',  # 145
     ' --metrics stall_not_selected   ',  # 146
     ' --metrics stall_other ',  # 147
     ' --metrics stall_pipe_busy ',  # 148
     ' --metrics stall_sleeping ',  # 149
     ' --metrics stall_sync   ',  # 150
     ' --metrics stall_texture ',  # 151
     ' --metrics surface_atomic_requests ',  # 152
     ' --metrics surface_load_requests ',  # 153
     ' --metrics surface_reduction_requests ',  # 154
     ' --metrics surface_store_requests ',  # 155
     ' --metrics sysmem_read_bytes ',  # 156
     ' --metrics sysmem_read_throughput ',  # 157
     ' --metrics sysmem_read_transactions ',  # 158
     ' --metrics sysmem_read_utilization ',  # 159
     ' --metrics sysmem_utilization ',  # 160
     ' --metrics sysmem_write_bytes ',  # 161
     ' --metrics sysmem_write_throughput ',  # 162
     ' --metrics sysmem_write_transactions ',  # 163
     ' --metrics sysmem_write_utilization ',  # 164
     ' --metrics tensor_precision_fu_utilization ',  # 165
     ' --metrics tensor_int_fu_utilization ',  # 166
     ' --metrics tex_cache_hit_rate ',  # 167
     ' --metrics tex_cache_throughput ',  # 168
     ' --metrics tex_cache_transactions ',  # 169
     ' --metrics tex_fu_utilization ',  # 170
     ' --metrics tex_utilization ',  # 171
     ' --metrics texture_load_requests ',  # 172
     ' --metrics warp_execution_efficiency ',  # 173
     ' --metrics warp_nonpred_execution_efficiency ',  # 174
]
