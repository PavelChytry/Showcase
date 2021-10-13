vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xilinx_vip
vlib questa_lib/msim/xpm
vlib questa_lib/msim/axi_infrastructure_v1_1_0
vlib questa_lib/msim/axi_vip_v1_1_7
vlib questa_lib/msim/processing_system7_vip_v1_0_9
vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/blk_mem_gen_v8_4_4
vlib questa_lib/msim/axi_bram_ctrl_v4_1_3
vlib questa_lib/msim/xlconstant_v1_1_7
vlib questa_lib/msim/lib_cdc_v1_0_2
vlib questa_lib/msim/proc_sys_reset_v5_0_13
vlib questa_lib/msim/smartconnect_v1_0
vlib questa_lib/msim/axi_register_slice_v2_1_21
vlib questa_lib/msim/axi_lite_ipif_v3_0_4
vlib questa_lib/msim/interrupt_control_v3_1_4
vlib questa_lib/msim/axi_gpio_v2_0_23
vlib questa_lib/msim/xbip_dsp48_wrapper_v3_0_4
vlib questa_lib/msim/xbip_utils_v3_0_10
vlib questa_lib/msim/xbip_pipe_v3_0_6
vlib questa_lib/msim/xbip_dsp48_macro_v3_0_17

vmap xilinx_vip questa_lib/msim/xilinx_vip
vmap xpm questa_lib/msim/xpm
vmap axi_infrastructure_v1_1_0 questa_lib/msim/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_7 questa_lib/msim/axi_vip_v1_1_7
vmap processing_system7_vip_v1_0_9 questa_lib/msim/processing_system7_vip_v1_0_9
vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap blk_mem_gen_v8_4_4 questa_lib/msim/blk_mem_gen_v8_4_4
vmap axi_bram_ctrl_v4_1_3 questa_lib/msim/axi_bram_ctrl_v4_1_3
vmap xlconstant_v1_1_7 questa_lib/msim/xlconstant_v1_1_7
vmap lib_cdc_v1_0_2 questa_lib/msim/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_13 questa_lib/msim/proc_sys_reset_v5_0_13
vmap smartconnect_v1_0 questa_lib/msim/smartconnect_v1_0
vmap axi_register_slice_v2_1_21 questa_lib/msim/axi_register_slice_v2_1_21
vmap axi_lite_ipif_v3_0_4 questa_lib/msim/axi_lite_ipif_v3_0_4
vmap interrupt_control_v3_1_4 questa_lib/msim/interrupt_control_v3_1_4
vmap axi_gpio_v2_0_23 questa_lib/msim/axi_gpio_v2_0_23
vmap xbip_dsp48_wrapper_v3_0_4 questa_lib/msim/xbip_dsp48_wrapper_v3_0_4
vmap xbip_utils_v3_0_10 questa_lib/msim/xbip_utils_v3_0_10
vmap xbip_pipe_v3_0_6 questa_lib/msim/xbip_pipe_v3_0_6
vmap xbip_dsp48_macro_v3_0_17 questa_lib/msim/xbip_dsp48_macro_v3_0_17

vlog -work xilinx_vip  -sv -L axi_vip_v1_1_7 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_9 -L xilinx_vip "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"D:/Applications/Vivado/2020.1/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"D:/Applications/Vivado/2020.1/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"D:/Applications/Vivado/2020.1/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"D:/Applications/Vivado/2020.1/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"D:/Applications/Vivado/2020.1/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"D:/Applications/Vivado/2020.1/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"D:/Applications/Vivado/2020.1/data/xilinx_vip/hdl/axi_vip_if.sv" \
"D:/Applications/Vivado/2020.1/data/xilinx_vip/hdl/clk_vip_if.sv" \
"D:/Applications/Vivado/2020.1/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -sv -L axi_vip_v1_1_7 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_9 -L xilinx_vip "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"D:/Applications/Vivado/2020.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Applications/Vivado/2020.1/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"D:/Applications/Vivado/2020.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93 \
"D:/Applications/Vivado/2020.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axi_infrastructure_v1_1_0  "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_7  -sv -L axi_vip_v1_1_7 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_9 -L xilinx_vip "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ce6c/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_9  -sv -L axi_vip_v1_1_7 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_9 -L xilinx_vip "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_processing_system7_0_0/sim/wtfhe_arm_processing_system7_0_0.v" \

vlog -work blk_mem_gen_v8_4_4  "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2985/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_blk_mem_gen_0_0/sim/wtfhe_arm_blk_mem_gen_0_0.v" \

vcom -work axi_bram_ctrl_v4_1_3  -93 \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/db86/hdl/axi_bram_ctrl_v4_1_rfs.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_bram_ctrl_0_0/sim/wtfhe_arm_axi_bram_ctrl_0_0.vhd" \

vlog -work xil_defaultlib  "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/sim/bd_11e1.v" \

vlog -work xlconstant_v1_1_7  "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/fcfc/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_0/sim/bd_11e1_one_0.v" \

vcom -work lib_cdc_v1_0_2  -93 \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_13  -93 \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_1/sim/bd_11e1_psr_aclk_0.vhd" \

vlog -work smartconnect_v1_0  -sv -L axi_vip_v1_1_7 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_9 -L xilinx_vip "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/sc_util_v1_0_vl_rfs.sv" \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/c012/hdl/sc_switchboard_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv -L axi_vip_v1_1_7 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_9 -L xilinx_vip "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_2/sim/bd_11e1_arsw_0.sv" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_3/sim/bd_11e1_rsw_0.sv" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_4/sim/bd_11e1_awsw_0.sv" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_5/sim/bd_11e1_wsw_0.sv" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_6/sim/bd_11e1_bsw_0.sv" \

vlog -work smartconnect_v1_0  -sv -L axi_vip_v1_1_7 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_9 -L xilinx_vip "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/053f/hdl/sc_mmu_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv -L axi_vip_v1_1_7 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_9 -L xilinx_vip "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_7/sim/bd_11e1_s00mmu_0.sv" \

vlog -work smartconnect_v1_0  -sv -L axi_vip_v1_1_7 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_9 -L xilinx_vip "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ca72/hdl/sc_transaction_regulator_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv -L axi_vip_v1_1_7 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_9 -L xilinx_vip "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_8/sim/bd_11e1_s00tr_0.sv" \

vlog -work smartconnect_v1_0  -sv -L axi_vip_v1_1_7 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_9 -L xilinx_vip "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/9d43/hdl/sc_si_converter_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv -L axi_vip_v1_1_7 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_9 -L xilinx_vip "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_9/sim/bd_11e1_s00sic_0.sv" \

vlog -work smartconnect_v1_0  -sv -L axi_vip_v1_1_7 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_9 -L xilinx_vip "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/b89e/hdl/sc_axi2sc_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv -L axi_vip_v1_1_7 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_9 -L xilinx_vip "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_10/sim/bd_11e1_s00a2s_0.sv" \

vlog -work smartconnect_v1_0  -sv -L axi_vip_v1_1_7 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_9 -L xilinx_vip "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/sc_node_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv -L axi_vip_v1_1_7 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_9 -L xilinx_vip "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_11/sim/bd_11e1_sarn_0.sv" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_12/sim/bd_11e1_srn_0.sv" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_13/sim/bd_11e1_sawn_0.sv" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_14/sim/bd_11e1_swn_0.sv" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_15/sim/bd_11e1_sbn_0.sv" \

vlog -work smartconnect_v1_0  -sv -L axi_vip_v1_1_7 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_9 -L xilinx_vip "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/7005/hdl/sc_sc2axi_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv -L axi_vip_v1_1_7 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_9 -L xilinx_vip "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_16/sim/bd_11e1_m00s2a_0.sv" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_17/sim/bd_11e1_m00arn_0.sv" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_18/sim/bd_11e1_m00rn_0.sv" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_19/sim/bd_11e1_m00awn_0.sv" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_20/sim/bd_11e1_m00wn_0.sv" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_21/sim/bd_11e1_m00bn_0.sv" \

vlog -work smartconnect_v1_0  -sv -L axi_vip_v1_1_7 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_9 -L xilinx_vip "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/7af8/hdl/sc_exit_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv -L axi_vip_v1_1_7 -L smartconnect_v1_0 -L processing_system7_vip_v1_0_9 -L xilinx_vip "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_22/sim/bd_11e1_m00e_0.sv" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_23/sim/bd_11e1_m01s2a_0.sv" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_24/sim/bd_11e1_m01arn_0.sv" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_25/sim/bd_11e1_m01rn_0.sv" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_26/sim/bd_11e1_m01awn_0.sv" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_27/sim/bd_11e1_m01wn_0.sv" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_28/sim/bd_11e1_m01bn_0.sv" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/bd_0/ip/ip_29/sim/bd_11e1_m01e_0.sv" \

vlog -work axi_register_slice_v2_1_21  "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2ef9/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/ec67/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/6b56/hdl" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/2702/hdl/verilog" "+incdir+../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/4676/hdl/verilog" "+incdir+D:/Applications/Vivado/2020.1/data/xilinx_vip/include" \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_smc_0/sim/wtfhe_arm_axi_smc_0.v" \

vcom -work xil_defaultlib  -93 \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_rst_ps7_0_50M_0/sim/wtfhe_arm_rst_ps7_0_50M_0.vhd" \

vcom -work axi_lite_ipif_v3_0_4  -93 \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work interrupt_control_v3_1_4  -93 \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/a040/hdl/interrupt_control_v3_1_vh_rfs.vhd" \

vcom -work axi_gpio_v2_0_23  -93 \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ipshared/bb35/hdl/axi_gpio_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_axi_gpio_0_0/sim/wtfhe_arm_axi_gpio_0_0.vhd" \

vcom -work xbip_dsp48_wrapper_v3_0_4  -93 \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ip/wtfhe_arm_BOOTSTRAPPING_ARM_1_0/src/xbip_dsp48_macro_0_1/hdl/xbip_dsp48_wrapper_v3_0_vh_rfs.vhd" \

vcom -work xbip_utils_v3_0_10  -93 \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ip/wtfhe_arm_BOOTSTRAPPING_ARM_1_0/src/xbip_dsp48_macro_0_1/hdl/xbip_utils_v3_0_vh_rfs.vhd" \

vcom -work xbip_pipe_v3_0_6  -93 \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ip/wtfhe_arm_BOOTSTRAPPING_ARM_1_0/src/xbip_dsp48_macro_0_1/hdl/xbip_pipe_v3_0_vh_rfs.vhd" \

vcom -work xbip_dsp48_macro_v3_0_17  -93 \
"../../../../wtfhe.srcs/sources_1/bd/wtfhe_arm/ip/wtfhe_arm_BOOTSTRAPPING_ARM_1_0/src/xbip_dsp48_macro_0_1/hdl/xbip_dsp48_macro_v3_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_BOOTSTRAPPING_ARM_1_0/src/xbip_dsp48_macro_0_1/sim/xbip_dsp48_macro_0.vhd" \

vcom -work xil_defaultlib  -2008 \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/CONST.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/ACCUMULATOR.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/ADDR_REG.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/COUNTER.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/EXTENDED_COUNTER.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/EXTERNAL_PRODUCT.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/LATCH.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/LSM.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/MATRIX_ACC.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/MATRIX_MULT.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/MULT_CONTROLLER.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/NEGACYCLIC_MEM.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/POLY_ADD.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/POLY_EXP.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/POLY_MPX.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/POLY_MULT.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/POLY_REG.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/POLY_SPLIT.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/SAMPLE_EXTRACT.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/TLWE_REG.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/TLWE_ROUNDING.vhd" \
"../../../bd/wtfhe_arm/ipshared/2ee9/sources_1/new/BOOTSTRAPPING_ARM.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../bd/wtfhe_arm/ip/wtfhe_arm_BOOTSTRAPPING_ARM_1_0/sim/wtfhe_arm_BOOTSTRAPPING_ARM_1_0.vhd" \
"../../../bd/wtfhe_arm/sim/wtfhe_arm.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

