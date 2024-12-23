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
// CREATED		"Sat Dec 07 15:03:15 2024"

module test(
	clk,
	rst,
	topbottom,
	postition_rst,
	rs,
	rw,
	e,
	init_end,
	life0,
	life1,
	life2,
	die,
	piezo,
	com,
	data,
	segdata
);


input wire	clk;
input wire	rst;
input wire	topbottom;
input wire	postition_rst;
output wire	rs;
output wire	rw;
output wire	e;
output wire	init_end;
output wire	life0;
output wire	life1;
output wire	life2;
output wire	die;
output wire	piezo;
output wire	[7:0] com;
output wire	[7:0] data;
output wire	[6:0] segdata;

wire	[7:0] random;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_37;
wire	SYNTHESIZED_WIRE_38;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_39;
wire	SYNTHESIZED_WIRE_7;
wire	[7:0] SYNTHESIZED_WIRE_9;
wire	[7:0] SYNTHESIZED_WIRE_10;
wire	SYNTHESIZED_WIRE_12;
wire	SYNTHESIZED_WIRE_13;
wire	SYNTHESIZED_WIRE_15;
wire	SYNTHESIZED_WIRE_16;
wire	SYNTHESIZED_WIRE_18;
wire	SYNTHESIZED_WIRE_19;
wire	SYNTHESIZED_WIRE_21;
wire	SYNTHESIZED_WIRE_22;
wire	SYNTHESIZED_WIRE_23;
wire	SYNTHESIZED_WIRE_24;
wire	SYNTHESIZED_WIRE_26;
wire	SYNTHESIZED_WIRE_27;
wire	SYNTHESIZED_WIRE_28;
wire	SYNTHESIZED_WIRE_30;
wire	SYNTHESIZED_WIRE_31;
wire	SYNTHESIZED_WIRE_32;
wire	SYNTHESIZED_WIRE_33;
wire	SYNTHESIZED_WIRE_34;
wire	SYNTHESIZED_WIRE_36;

assign	init_end = SYNTHESIZED_WIRE_37;
assign	die = SYNTHESIZED_WIRE_39;
assign	SYNTHESIZED_WIRE_0 = 0;
assign	SYNTHESIZED_WIRE_5 = 0;
assign	SYNTHESIZED_WIRE_12 = 1;
assign	SYNTHESIZED_WIRE_24 = 0;
assign	SYNTHESIZED_WIRE_28 = 0;




mx_2x1	b2v_inst(
	.s_1(SYNTHESIZED_WIRE_0),
	.sel(SYNTHESIZED_WIRE_37),
	.s_0(clk),
	.m_out(SYNTHESIZED_WIRE_22));


trigger	b2v_inst1(
	.Din(topbottom),
	.CLK(clk),
	.rst_n(SYNTHESIZED_WIRE_38),
	.Dout(SYNTHESIZED_WIRE_33));


life_count_LED	b2v_inst10(
	.clk(clk),
	.rst(postition_rst),
	.hit(SYNTHESIZED_WIRE_3),
	.life_0(life0),
	.life_1(life1),
	.life_2(life2),
	.die(SYNTHESIZED_WIRE_39));


array8_segment	b2v_inst11(
	.clk(clk),
	.rst(postition_rst),
	.scoreUP(SYNTHESIZED_WIRE_4),
	.com(com),
	.num_data(segdata));


mx_2x1	b2v_inst12(
	.s_1(SYNTHESIZED_WIRE_5),
	.sel(SYNTHESIZED_WIRE_39),
	.s_0(SYNTHESIZED_WIRE_7),
	.m_out(SYNTHESIZED_WIRE_30));




mx_8bit_2x1	b2v_inst15(
	.ce(SYNTHESIZED_WIRE_37),
	.s0(SYNTHESIZED_WIRE_9),
	.s1(SYNTHESIZED_WIRE_10),
	.m_out(data));



PNU_CLK_DIV	b2v_inst17(
	.clk(clk),
	.rst_n(SYNTHESIZED_WIRE_38),
	.en(SYNTHESIZED_WIRE_12),
	.div_clk(SYNTHESIZED_WIRE_36));
	defparam	b2v_inst17.cnt_num = 5000;


mx_2x1	b2v_inst18(
	.s_1(SYNTHESIZED_WIRE_13),
	.sel(SYNTHESIZED_WIRE_37),
	.s_0(SYNTHESIZED_WIRE_15),
	.m_out(rs));


mx_2x1	b2v_inst19(
	.s_1(SYNTHESIZED_WIRE_16),
	.sel(SYNTHESIZED_WIRE_37),
	.s_0(SYNTHESIZED_WIRE_18),
	.m_out(rw));

assign	SYNTHESIZED_WIRE_38 =  ~rst;


mx_2x1	b2v_inst20(
	.s_1(SYNTHESIZED_WIRE_19),
	.sel(SYNTHESIZED_WIRE_37),
	.s_0(SYNTHESIZED_WIRE_21),
	.m_out(e));


clk_speed	b2v_inst21(
	.clk(SYNTHESIZED_WIRE_22),
	.rst(postition_rst),
	.game_clk(SYNTHESIZED_WIRE_7),
	.scoreUP(SYNTHESIZED_WIRE_26));

assign	SYNTHESIZED_WIRE_37 =  ~SYNTHESIZED_WIRE_23;


mx_2x1	b2v_inst23(
	.s_1(SYNTHESIZED_WIRE_24),
	.sel(SYNTHESIZED_WIRE_39),
	.s_0(SYNTHESIZED_WIRE_26),
	.m_out(SYNTHESIZED_WIRE_4));



super_mario_music	b2v_inst25(
	.clk_1MHz(SYNTHESIZED_WIRE_27),
	.rst(postition_rst),
	.piezo(piezo));


mx_2x1	b2v_inst26(
	.s_1(SYNTHESIZED_WIRE_28),
	.sel(SYNTHESIZED_WIRE_39),
	.s_0(clk),
	.m_out(SYNTHESIZED_WIRE_27));



lcd_write_object_char	b2v_inst4(
	.clk(SYNTHESIZED_WIRE_30),
	.rst(postition_rst),
	.obj_zero_bottom_one_top(random[0]),
	.char_zero_bottom_one_top(SYNTHESIZED_WIRE_31),
	.next(SYNTHESIZED_WIRE_32),
	.lcd_rs(SYNTHESIZED_WIRE_15),
	.lcd_rw(SYNTHESIZED_WIRE_18),
	.lcd_en(SYNTHESIZED_WIRE_21),
	.next_output(SYNTHESIZED_WIRE_32),
	.hit(SYNTHESIZED_WIRE_34),
	.lcd_data(SYNTHESIZED_WIRE_9));


toggle_keep	b2v_inst5(
	.in(SYNTHESIZED_WIRE_33),
	.clk(clk),
	.rst(postition_rst),
	.out(SYNTHESIZED_WIRE_31));


trigger	b2v_inst6(
	.Din(SYNTHESIZED_WIRE_34),
	.CLK(clk),
	.rst_n(SYNTHESIZED_WIRE_38),
	.Dout(SYNTHESIZED_WIRE_3));


lcd_custom_object_init	b2v_inst8(
	.clk(SYNTHESIZED_WIRE_36),
	.rst(postition_rst),
	.lcd_rw(SYNTHESIZED_WIRE_16),
	.lcd_rs(SYNTHESIZED_WIRE_13),
	.lcd_en(SYNTHESIZED_WIRE_19),
	.init_end(SYNTHESIZED_WIRE_23),
	.lcd_data(SYNTHESIZED_WIRE_10));


lfsr_random	b2v_inst9(
	.clk(clk),
	.reset(postition_rst),
	.random(random));


endmodule
