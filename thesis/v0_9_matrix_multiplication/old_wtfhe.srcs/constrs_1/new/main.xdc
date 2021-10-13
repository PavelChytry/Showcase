create_clock -period 10.000 -name CLK -waveform {0.000 5.000} [get_ports CLK]

set_property PACKAGE_PIN Y9 [get_ports CLK]
set_property IOSTANDARD LVCMOS33 [get_ports CLK]
set_property PACKAGE_PIN P16 [get_ports RST]
set_property IOSTANDARD LVCMOS18 [get_ports RST]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets RST_IBUF]
set_property PACKAGE_PIN AA9 [get_ports RXD]
set_property IOSTANDARD LVCMOS33 [get_ports RXD]
set_property PACKAGE_PIN Y10 [get_ports TXD]
set_property IOSTANDARD LVCMOS33 [get_ports TXD]
set_property PACKAGE_PIN T22 [get_ports {LED[0]}]
set_property PACKAGE_PIN T21 [get_ports {LED[1]}]
set_property PACKAGE_PIN U22 [get_ports {LED[2]}]
set_property PACKAGE_PIN U21 [get_ports {LED[3]}]
set_property PACKAGE_PIN V22 [get_ports {LED[4]}]
set_property PACKAGE_PIN W22 [get_ports {LED[5]}]
set_property PACKAGE_PIN U19 [get_ports {LED[6]}]
set_property PACKAGE_PIN U14 [get_ports {LED[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]

# Zedboard
#NET "CLK"  LOC = "Y9"   | IOSTANDARD=LVCMOS33;   ## 
#NET "RST" CLOCK_DEDICATED_ROUTE = FALSE;
#NET "RST"  LOC = "P16"  | IOSTANDARD=LVCMOS18; ## 
#NET "RXD"  LOC = "N15"  | IOSTANDARD=LVCMOS18; ## button
#NET "TXD"  LOC = "R18"  | IOSTANDARD=LVCMOS18; ## button

#NET "LED<0>" LOC = "T22" | IOSTANDARD=LVCMOS33;  
#NET "LED<1>" LOC = "T21" | IOSTANDARD=LVCMOS33;  
#NET "LED<2>" LOC = "U22" | IOSTANDARD=LVCMOS33;  
#NET "LED<3>" LOC = "U21" | IOSTANDARD=LVCMOS33;  
#NET "LED<4>" LOC = "V22" | IOSTANDARD=LVCMOS33;  
#NET "LED<5>" LOC = "W22" | IOSTANDARD=LVCMOS33;  
#NET "LED<6>" LOC = "U19" | IOSTANDARD=LVCMOS33;  
#NET "LED<7>" LOC = "U14" | IOSTANDARD=LVCMOS33;  

# Nexys3
#NET "CLK"  LOC = "V10"  ; ## 
#NET "RST"  LOC = "B8"  ; ## 
#NET "RXD"  LOC = "N17"  ; ##
#NET "TXD"  LOC = "N18"  ; ##

#NET "LED<0>" LOC = "U16";
#NET "LED<1>" LOC = "V16";
#NET "LED<2>" LOC = "U15";
#NET "LED<3>" LOC = "V15";
#NET "LED<4>" LOC = "M11";
#NET "LED<5>" LOC = "N11";
#NET "LED<6>" LOC = "R11";
#NET "LED<7>" LOC = "T11";