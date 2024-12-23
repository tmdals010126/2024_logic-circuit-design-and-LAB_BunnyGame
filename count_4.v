// Copyright (C) 2020  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"
// CREATED		"Wed Nov 13 16:24:01 2024"

module count_4(
	clk,
	rst_n,
	Q0,
	Q1
);


input wire	clk;
input wire	rst_n;
output wire	Q0;
output wire	Q1;

reg	[0:0] result;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
reg	DFF_inst;

assign	Q1 = DFF_inst;




always@(posedge clk or negedge rst_n)
begin
if (!rst_n)
	begin
	DFF_inst <= 0;
	end
else
	begin
	DFF_inst <= SYNTHESIZED_WIRE_0;
	end
end


always@(posedge clk or negedge rst_n)
begin
if (!rst_n)
	begin
	result[0] <= 0;
	end
else
	begin
	result[0] <= SYNTHESIZED_WIRE_1;
	end
end

assign	SYNTHESIZED_WIRE_1 =  ~result;

assign	SYNTHESIZED_WIRE_0 = result ^ DFF_inst;

assign	Q0 = result;

endmodule
