##################################################################
# CHECK VIVADO VERSION
##################################################################

set scripts_vivado_version 2018.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
  catch {common::send_msg_id "IPS_TCL-100" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_ip_tcl to create an updated script."}
  return 1
}

##################################################################
# START
##################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source ipcore2018.tcl
# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./05/mix_compress.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
  create_project mix_compress 05 -part xc7k325tffg900-2
  set_property BOARD_PART xilinx.com:kc705:part0:1.6 [current_project]
  set_property target_language Verilog [current_project]
  set_property simulator_language Mixed [current_project]
}

##################################################################
# CHECK IPs
##################################################################

set bCheckIPs 1
set bCheckIPsPassed 1
if { $bCheckIPs == 1 } {
  set list_check_ips { xilinx.com:ip:blk_mem_gen:* xilinx.com:ip:fifo_generator:* xilinx.com:ip:mult_gen:* xilinx.com:ip:clk_wiz:* }
  set list_ips_missing ""
  common::send_msg_id "IPS_TCL-1001" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

  foreach ip_vlnv $list_check_ips {
  set ip_obj [get_ipdefs -all $ip_vlnv]
  if { $ip_obj eq "" } {
    lappend list_ips_missing $ip_vlnv
    }
  }

  if { $list_ips_missing ne "" } {
    catch {common::send_msg_id "IPS_TCL-105" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
    set bCheckIPsPassed 0
  }
}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "IPS_TCL-102" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 1
}

##################################################################
# CREATE IP bram_16x16bit
##################################################################

set blk_mem_gen bram_16x16bit
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -module_name $blk_mem_gen

set_property -dict { 
  CONFIG.Memory_Type {True_Dual_Port_RAM}
  CONFIG.Operating_Mode_A {READ_FIRST}
  CONFIG.Enable_A {Always_Enabled}
  CONFIG.Operating_Mode_B {READ_FIRST}
  CONFIG.Enable_B {Always_Enabled}
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false}
  CONFIG.Register_PortB_Output_of_Memory_Primitives {false}
  CONFIG.Fill_Remaining_Memory_Locations {true}
  CONFIG.Port_B_Clock {100}
  CONFIG.Port_B_Write_Rate {50}
  CONFIG.Port_B_Enable_Rate {100}
} [get_ips $blk_mem_gen]

##################################################################

##################################################################
# CREATE IP bram_16x20bit
##################################################################

set blk_mem_gen bram_16x20bit
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -module_name $blk_mem_gen

set_property -dict { 
  CONFIG.Memory_Type {Simple_Dual_Port_RAM}
  CONFIG.Write_Width_A {20}
  CONFIG.Read_Width_A {20}
  CONFIG.Operating_Mode_A {NO_CHANGE}
  CONFIG.Enable_A {Always_Enabled}
  CONFIG.Write_Width_B {20}
  CONFIG.Read_Width_B {20}
  CONFIG.Enable_B {Always_Enabled}
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false}
  CONFIG.Register_PortB_Output_of_Memory_Primitives {false}
  CONFIG.Fill_Remaining_Memory_Locations {true}
  CONFIG.Port_A_Write_Rate {50}
  CONFIG.Port_B_Clock {100}
  CONFIG.Port_B_Enable_Rate {100}
} [get_ips $blk_mem_gen]

##################################################################

##################################################################
# CREATE IP bram_512x47bit
##################################################################

set blk_mem_gen bram_512x47bit
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -module_name $blk_mem_gen

set_property -dict { 
  CONFIG.Memory_Type {True_Dual_Port_RAM}
  CONFIG.Write_Width_A {47}
  CONFIG.Write_Depth_A {512}
  CONFIG.Read_Width_A {47}
  CONFIG.Enable_A {Always_Enabled}
  CONFIG.Write_Width_B {47}
  CONFIG.Read_Width_B {47}
  CONFIG.Operating_Mode_B {READ_FIRST}
  CONFIG.Enable_B {Always_Enabled}
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false}
  CONFIG.Register_PortB_Output_of_Memory_Primitives {false}
  CONFIG.Fill_Remaining_Memory_Locations {true}
  CONFIG.Port_B_Clock {100}
  CONFIG.Port_B_Write_Rate {50}
  CONFIG.Port_B_Enable_Rate {100}
} [get_ips $blk_mem_gen]

##################################################################

##################################################################
# CREATE IP buffer_ram32Kx32bit
##################################################################

set blk_mem_gen buffer_ram32Kx32bit
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -module_name $blk_mem_gen

set_property -dict { 
  CONFIG.Memory_Type {True_Dual_Port_RAM}
  CONFIG.Write_Width_A {32}
  CONFIG.Write_Depth_A {32768}
  CONFIG.Read_Width_A {32}
  CONFIG.Operating_Mode_A {READ_FIRST}
  CONFIG.Enable_A {Always_Enabled}
  CONFIG.Write_Width_B {32}
  CONFIG.Read_Width_B {32}
  CONFIG.Operating_Mode_B {READ_FIRST}
  CONFIG.Enable_B {Always_Enabled}
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false}
  CONFIG.Register_PortB_Output_of_Memory_Primitives {false}
  CONFIG.Fill_Remaining_Memory_Locations {true}
  CONFIG.Port_B_Clock {100}
  CONFIG.Port_B_Write_Rate {50}
  CONFIG.Port_B_Enable_Rate {100}
} [get_ips $blk_mem_gen]

##################################################################

##################################################################
# CREATE IP fifo_16kx32bit
##################################################################

set fifo_generator fifo_16kx32bit
create_ip -name fifo_generator -vendor xilinx.com -library ip -module_name $fifo_generator

set_property -dict { 
  CONFIG.Input_Data_Width {32}
  CONFIG.Input_Depth {16384}
  CONFIG.Output_Data_Width {32}
  CONFIG.Output_Depth {16384}
  CONFIG.Reset_Type {Asynchronous_Reset}
  CONFIG.Full_Flags_Reset_Value {0}
  CONFIG.Valid_Flag {true}
  CONFIG.Data_Count {true}
  CONFIG.Data_Count_Width {14}
  CONFIG.Write_Data_Count_Width {14}
  CONFIG.Read_Data_Count_Width {14}
  CONFIG.Full_Threshold_Assert_Value {16382}
  CONFIG.Full_Threshold_Negate_Value {16381}
  CONFIG.Enable_Safety_Circuit {true}
} [get_ips $fifo_generator]

##################################################################

##################################################################
# CREATE IP fifo_16x32b
##################################################################

set fifo_generator fifo_16x32b
create_ip -name fifo_generator -vendor xilinx.com -library ip -module_name $fifo_generator

set_property -dict { 
  CONFIG.Performance_Options {First_Word_Fall_Through}
  CONFIG.Input_Data_Width {32}
  CONFIG.Input_Depth {16}
  CONFIG.Output_Data_Width {32}
  CONFIG.Output_Depth {16}
  CONFIG.Reset_Pin {true}
  CONFIG.Reset_Type {Asynchronous_Reset}
  CONFIG.Full_Flags_Reset_Value {1}
  CONFIG.Use_Dout_Reset {true}
  CONFIG.Valid_Flag {true}
  CONFIG.Use_Extra_Logic {true}
  CONFIG.Data_Count {true}
  CONFIG.Data_Count_Width {5}
  CONFIG.Write_Data_Count_Width {5}
  CONFIG.Read_Data_Count_Width {5}
  CONFIG.Full_Threshold_Assert_Value {15}
  CONFIG.Full_Threshold_Negate_Value {14}
  CONFIG.Empty_Threshold_Assert_Value {4}
  CONFIG.Empty_Threshold_Negate_Value {5}
  CONFIG.Enable_Safety_Circuit {true}
} [get_ips $fifo_generator]

##################################################################

##################################################################
# CREATE IP fifo_8kx32bit
##################################################################

set fifo_generator fifo_8kx32bit
create_ip -name fifo_generator -vendor xilinx.com -library ip -module_name $fifo_generator

set_property -dict { 
  CONFIG.Input_Data_Width {32}
  CONFIG.Input_Depth {8192}
  CONFIG.Output_Data_Width {32}
  CONFIG.Output_Depth {8192}
  CONFIG.Reset_Type {Asynchronous_Reset}
  CONFIG.Full_Flags_Reset_Value {0}
  CONFIG.Valid_Flag {true}
  CONFIG.Data_Count {true}
  CONFIG.Data_Count_Width {13}
  CONFIG.Write_Data_Count_Width {13}
  CONFIG.Read_Data_Count_Width {13}
  CONFIG.Full_Threshold_Assert_Value {8190}
  CONFIG.Full_Threshold_Negate_Value {8189}
  CONFIG.Enable_Safety_Circuit {true}
} [get_ips $fifo_generator]

##################################################################

##################################################################
# CREATE IP fifo_8kx34bit
##################################################################

set fifo_generator fifo_8kx34bit
create_ip -name fifo_generator -vendor xilinx.com -library ip -module_name $fifo_generator

set_property -dict { 
  CONFIG.Input_Data_Width {34}
  CONFIG.Input_Depth {8192}
  CONFIG.Output_Data_Width {34}
  CONFIG.Output_Depth {8192}
  CONFIG.Reset_Type {Asynchronous_Reset}
  CONFIG.Full_Flags_Reset_Value {0}
  CONFIG.Valid_Flag {true}
  CONFIG.Data_Count {true}
  CONFIG.Data_Count_Width {13}
  CONFIG.Write_Data_Count_Width {13}
  CONFIG.Read_Data_Count_Width {13}
  CONFIG.Full_Threshold_Assert_Value {8190}
  CONFIG.Full_Threshold_Negate_Value {8189}
  CONFIG.Enable_Safety_Circuit {true}
} [get_ips $fifo_generator]

##################################################################

##################################################################
# CREATE IP hash_mul32x32
##################################################################

set mult_gen hash_mul32x32
create_ip -name mult_gen -vendor xilinx.com -library ip -module_name $mult_gen

set_property -dict { 
  CONFIG.PortAType {Unsigned}
  CONFIG.PortAWidth {32}
  CONFIG.PortBType {Unsigned}
  CONFIG.PortBWidth {32}
  CONFIG.Multiplier_Construction {Use_Mults}
  CONFIG.OutputWidthHigh {63}
  CONFIG.SyncClear {true}
} [get_ips $mult_gen]

##################################################################

##################################################################
# CREATE IP hash_pll
##################################################################

set clk_wiz hash_pll
create_ip -name clk_wiz -vendor xilinx.com -library ip -module_name $clk_wiz

set_property -dict { 
  CONFIG.PRIMITIVE {MMCM}
  CONFIG.PRIM_IN_FREQ {250.000}
  CONFIG.CLKIN1_JITTER_PS {40.0}
  CONFIG.CLKOUT2_USED {true}
  CONFIG.NUM_OUT_CLKS {2}
  CONFIG.PRIMARY_PORT {CLK_IN}
  CONFIG.CLK_OUT1_PORT {CLK_250}
  CONFIG.CLK_OUT2_PORT {CLK_500}
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {250.000}
  CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {500.000}
  CONFIG.CLKOUT1_DRIVES {BUFG}
  CONFIG.CLKOUT2_DRIVES {BUFG}
  CONFIG.CLKOUT3_DRIVES {BUFG}
  CONFIG.CLKOUT4_DRIVES {BUFG}
  CONFIG.CLKOUT5_DRIVES {BUFG}
  CONFIG.CLKOUT6_DRIVES {BUFG}
  CONFIG.CLKOUT7_DRIVES {BUFG}
  CONFIG.FEEDBACK_SOURCE {FDBK_AUTO}
  CONFIG.MMCM_DIVCLK_DIVIDE {1}
  CONFIG.MMCM_CLKFBOUT_MULT_F {4.000}
  CONFIG.MMCM_CLKIN1_PERIOD {4.000}
  CONFIG.MMCM_CLKIN2_PERIOD {10.0}
  CONFIG.MMCM_COMPENSATION {ZHOLD}
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {4.000}
  CONFIG.MMCM_CLKOUT1_DIVIDE {2}
  CONFIG.CLKOUT1_JITTER {89.528}
  CONFIG.CLKOUT1_PHASE_ERROR {85.928}
  CONFIG.CLKOUT2_JITTER {78.198}
  CONFIG.CLKOUT2_PHASE_ERROR {85.928}
} [get_ips $clk_wiz]

##################################################################

##################################################################
# CREATE IP hash_ram_32Kx64bit
##################################################################

set blk_mem_gen hash_ram_32Kx64bit
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -module_name $blk_mem_gen

set_property -dict { 
  CONFIG.Memory_Type {True_Dual_Port_RAM}
  CONFIG.Write_Width_A {65}
  CONFIG.Write_Depth_A {32768}
  CONFIG.Read_Width_A {65}
  CONFIG.Operating_Mode_A {READ_FIRST}
  CONFIG.Enable_A {Always_Enabled}
  CONFIG.Write_Width_B {65}
  CONFIG.Read_Width_B {65}
  CONFIG.Operating_Mode_B {READ_FIRST}
  CONFIG.Enable_B {Always_Enabled}
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false}
  CONFIG.Register_PortB_Output_of_Memory_Primitives {false}
  CONFIG.Fill_Remaining_Memory_Locations {true}
  CONFIG.Port_B_Clock {100}
  CONFIG.Port_B_Write_Rate {50}
  CONFIG.Port_B_Enable_Rate {100}
} [get_ips $blk_mem_gen]

##################################################################

##################################################################
# CREATE IP ram_128x36bit
##################################################################

set blk_mem_gen ram_128x36bit
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -module_name $blk_mem_gen

set_property -dict { 
  CONFIG.Memory_Type {True_Dual_Port_RAM}
  CONFIG.Write_Width_A {36}
  CONFIG.Write_Depth_A {128}
  CONFIG.Read_Width_A {36}
  CONFIG.Operating_Mode_A {READ_FIRST}
  CONFIG.Enable_A {Always_Enabled}
  CONFIG.Write_Width_B {36}
  CONFIG.Read_Width_B {36}
  CONFIG.Operating_Mode_B {READ_FIRST}
  CONFIG.Enable_B {Always_Enabled}
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false}
  CONFIG.Register_PortB_Output_of_Memory_Primitives {false}
  CONFIG.Fill_Remaining_Memory_Locations {true}
  CONFIG.Port_B_Clock {100}
  CONFIG.Port_B_Write_Rate {50}
  CONFIG.Port_B_Enable_Rate {100}
} [get_ips $blk_mem_gen]

##################################################################

##################################################################
# CREATE IP ram_128x8bit
##################################################################

set blk_mem_gen ram_128x8bit
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -module_name $blk_mem_gen

set_property -dict { 
  CONFIG.Memory_Type {True_Dual_Port_RAM}
  CONFIG.Write_Width_A {8}
  CONFIG.Write_Depth_A {128}
  CONFIG.Read_Width_A {8}
  CONFIG.Operating_Mode_A {READ_FIRST}
  CONFIG.Enable_A {Always_Enabled}
  CONFIG.Write_Width_B {8}
  CONFIG.Read_Width_B {8}
  CONFIG.Operating_Mode_B {READ_FIRST}
  CONFIG.Enable_B {Always_Enabled}
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false}
  CONFIG.Register_PortB_Output_of_Memory_Primitives {false}
  CONFIG.Fill_Remaining_Memory_Locations {true}
  CONFIG.Port_B_Clock {100}
  CONFIG.Port_B_Write_Rate {50}
  CONFIG.Port_B_Enable_Rate {100}
} [get_ips $blk_mem_gen]

##################################################################

##################################################################
# CREATE IP ram_16x9bit
##################################################################

set blk_mem_gen ram_16x9bit
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -module_name $blk_mem_gen

set_property -dict { 
  CONFIG.Memory_Type {True_Dual_Port_RAM}
  CONFIG.Write_Width_A {9}
  CONFIG.Read_Width_A {9}
  CONFIG.Operating_Mode_A {READ_FIRST}
  CONFIG.Enable_A {Always_Enabled}
  CONFIG.Write_Width_B {9}
  CONFIG.Read_Width_B {9}
  CONFIG.Operating_Mode_B {READ_FIRST}
  CONFIG.Enable_B {Always_Enabled}
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false}
  CONFIG.Register_PortB_Output_of_Memory_Primitives {false}
  CONFIG.Fill_Remaining_Memory_Locations {true}
  CONFIG.Port_B_Clock {100}
  CONFIG.Port_B_Write_Rate {50}
  CONFIG.Port_B_Enable_Rate {100}
} [get_ips $blk_mem_gen]

##################################################################

##################################################################
# CREATE IP ram_256x10bit
##################################################################

set blk_mem_gen ram_256x10bit
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -module_name $blk_mem_gen

set_property -dict { 
  CONFIG.Memory_Type {True_Dual_Port_RAM}
  CONFIG.Write_Width_A {10}
  CONFIG.Write_Depth_A {256}
  CONFIG.Read_Width_A {10}
  CONFIG.Operating_Mode_A {READ_FIRST}
  CONFIG.Enable_A {Always_Enabled}
  CONFIG.Write_Width_B {10}
  CONFIG.Read_Width_B {10}
  CONFIG.Operating_Mode_B {READ_FIRST}
  CONFIG.Enable_B {Always_Enabled}
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false}
  CONFIG.Register_PortB_Output_of_Memory_Primitives {false}
  CONFIG.Fill_Remaining_Memory_Locations {true}
  CONFIG.Port_B_Clock {100}
  CONFIG.Port_B_Write_Rate {50}
  CONFIG.Port_B_Enable_Rate {100}
} [get_ips $blk_mem_gen]

##################################################################

##################################################################
# CREATE IP ram_256x18bit
##################################################################

set blk_mem_gen ram_256x18bit
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -module_name $blk_mem_gen

set_property -dict { 
  CONFIG.Memory_Type {True_Dual_Port_RAM}
  CONFIG.Write_Width_A {18}
  CONFIG.Write_Depth_A {256}
  CONFIG.Read_Width_A {18}
  CONFIG.Operating_Mode_A {READ_FIRST}
  CONFIG.Enable_A {Always_Enabled}
  CONFIG.Write_Width_B {18}
  CONFIG.Read_Width_B {18}
  CONFIG.Operating_Mode_B {READ_FIRST}
  CONFIG.Enable_B {Always_Enabled}
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false}
  CONFIG.Register_PortB_Output_of_Memory_Primitives {false}
  CONFIG.Fill_Remaining_Memory_Locations {true}
  CONFIG.Port_B_Clock {100}
  CONFIG.Port_B_Write_Rate {50}
  CONFIG.Port_B_Enable_Rate {100}
} [get_ips $blk_mem_gen]

##################################################################

##################################################################
# CREATE IP ram_256x20bit
##################################################################

set blk_mem_gen ram_256x20bit
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -module_name $blk_mem_gen

set_property -dict { 
  CONFIG.Memory_Type {True_Dual_Port_RAM}
  CONFIG.Write_Width_A {20}
  CONFIG.Write_Depth_A {256}
  CONFIG.Read_Width_A {20}
  CONFIG.Operating_Mode_A {READ_FIRST}
  CONFIG.Enable_A {Always_Enabled}
  CONFIG.Write_Width_B {20}
  CONFIG.Read_Width_B {20}
  CONFIG.Operating_Mode_B {READ_FIRST}
  CONFIG.Enable_B {Always_Enabled}
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false}
  CONFIG.Register_PortB_Output_of_Memory_Primitives {false}
  CONFIG.Fill_Remaining_Memory_Locations {true}
  CONFIG.Port_B_Clock {100}
  CONFIG.Port_B_Write_Rate {50}
  CONFIG.Port_B_Enable_Rate {100}
} [get_ips $blk_mem_gen]

##################################################################

##################################################################
# CREATE IP ram_a128x4_b32x16bit
##################################################################

set blk_mem_gen ram_a128x4_b32x16bit
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -module_name $blk_mem_gen

set_property -dict { 
  CONFIG.Memory_Type {True_Dual_Port_RAM}
  CONFIG.Write_Width_A {4}
  CONFIG.Write_Depth_A {128}
  CONFIG.Read_Width_A {4}
  CONFIG.Enable_A {Always_Enabled}
  CONFIG.Write_Width_B {16}
  CONFIG.Read_Width_B {16}
  CONFIG.Operating_Mode_B {READ_FIRST}
  CONFIG.Enable_B {Always_Enabled}
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false}
  CONFIG.Register_PortB_Output_of_Memory_Primitives {false}
  CONFIG.Fill_Remaining_Memory_Locations {true}
  CONFIG.Port_B_Clock {100}
  CONFIG.Port_B_Write_Rate {50}
  CONFIG.Port_B_Enable_Rate {100}
} [get_ips $blk_mem_gen]

##################################################################

##################################################################
# CREATE IP unmatch_ram_4Kx32bit
##################################################################

set blk_mem_gen unmatch_ram_4Kx32bit
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -module_name $blk_mem_gen

set_property -dict { 
  CONFIG.Memory_Type {True_Dual_Port_RAM}
  CONFIG.Write_Width_A {32}
  CONFIG.Write_Depth_A {4096}
  CONFIG.Read_Width_A {32}
  CONFIG.Operating_Mode_A {WRITE_FIRST}
  CONFIG.Enable_A {Always_Enabled}
  CONFIG.Write_Width_B {32}
  CONFIG.Read_Width_B {32}
  CONFIG.Operating_Mode_B {READ_FIRST}
  CONFIG.Enable_B {Always_Enabled}
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false}
  CONFIG.Register_PortB_Output_of_Memory_Primitives {false}
  CONFIG.Fill_Remaining_Memory_Locations {true}
  CONFIG.Port_B_Clock {100}
  CONFIG.Port_B_Write_Rate {50}
  CONFIG.Port_B_Enable_Rate {100}
} [get_ips $blk_mem_gen]

##################################################################

##################################################################
# CREATE IP xxh32_mul
##################################################################

set mult_gen xxh32_mul
create_ip -name mult_gen -vendor xilinx.com -library ip -module_name $mult_gen

set_property -dict { 
  CONFIG.PortAType {Unsigned}
  CONFIG.PortAWidth {32}
  CONFIG.PortBType {Unsigned}
  CONFIG.PortBWidth {32}
  CONFIG.Multiplier_Construction {Use_Mults}
  CONFIG.OutputWidthHigh {63}
  CONFIG.SyncClear {true}
} [get_ips $mult_gen]

##################################################################

