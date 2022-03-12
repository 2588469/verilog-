`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/09 15:21:00
// Design Name: 
// Module Name: ram_en_switch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ram_en_switch
(
	input		[31:0]			addr			,
	input						bram_en			,
												
	output		[24:0]			bram_en_out		,
	
	input		[25*32-1:0]		bram_data_in	,
	
	output		[31:0]			bram_data_out	
	);

assign bram_en_out[0]	= (addr[19:12]==(8'h00))?bram_en:1'b0;
assign bram_en_out[1]	= (addr[19:12]==(8'h01))?bram_en:1'b0;
assign bram_en_out[2]	= (addr[19:12]==(8'h02))?bram_en:1'b0;
assign bram_en_out[3]	= (addr[19:12]==(8'h03))?bram_en:1'b0;
assign bram_en_out[4]	= (addr[19:12]==(8'h04))?bram_en:1'b0;
assign bram_en_out[5]	= (addr[19:12]==(8'h05))?bram_en:1'b0;
assign bram_en_out[6]	= (addr[19:12]==(8'h06))?bram_en:1'b0;
assign bram_en_out[7]	= (addr[19:12]==(8'h07))?bram_en:1'b0;
assign bram_en_out[8]	= (addr[19:12]==(8'h08))?bram_en:1'b0;
assign bram_en_out[9]	= (addr[19:12]==(8'h09))?bram_en:1'b0;
assign bram_en_out[10]	= (addr[19:12]==(8'h0a))?bram_en:1'b0;
assign bram_en_out[11]	= (addr[19:12]==(8'h0b))?bram_en:1'b0;
assign bram_en_out[12]	= (addr[19:12]==(8'h0c))?bram_en:1'b0;
assign bram_en_out[13]	= (addr[19:12]==(8'h0d))?bram_en:1'b0;
assign bram_en_out[14]	= (addr[19:12]==(8'h0e))?bram_en:1'b0;
assign bram_en_out[15]	= (addr[19:12]==(8'h0f))?bram_en:1'b0;
assign bram_en_out[16]	= (addr[19:12]==(8'h10))?bram_en:1'b0;
assign bram_en_out[17]	= (addr[19:12]==(8'h11))?bram_en:1'b0;
assign bram_en_out[18]	= (addr[19:12]==(8'h12))?bram_en:1'b0;
assign bram_en_out[19]	= (addr[19:12]==(8'h13))?bram_en:1'b0;
assign bram_en_out[20]	= (addr[19:12]==(8'h14))?bram_en:1'b0;
assign bram_en_out[21]	= (addr[19:12]==(8'h15))?bram_en:1'b0;
assign bram_en_out[22]	= (addr[19:12]==(8'h16))?bram_en:1'b0;
assign bram_en_out[23]	= (addr[19:12]==(8'h17))?bram_en:1'b0;
assign bram_en_out[24]	= (addr[19:12]==(8'h18))?bram_en:1'b0;

assign bram_data_out	= (addr[19:12]==(8'h00))?bram_data_in[(1*32)-1:0*32]	:
						((addr[19:12]==(8'h01))?bram_data_in[(2*32)-1:1*32]	:
						((addr[19:12]==(8'h02))?bram_data_in[(3*32)-1:2*32]	:
						((addr[19:12]==(8'h03))?bram_data_in[(4*32)-1:3*32]	:
						((addr[19:12]==(8'h04))?bram_data_in[(5*32)-1:4*32]	:
						((addr[19:12]==(8'h05))?bram_data_in[(6*32)-1:5*32]	:
						((addr[19:12]==(8'h06))?bram_data_in[(7*32)-1:6*32]	:
						((addr[19:12]==(8'h07))?bram_data_in[(8*32)-1:7*32]	:
						((addr[19:12]==(8'h08))?bram_data_in[(9*32)-1:8*32]	:
						((addr[19:12]==(8'h09))?bram_data_in[(10*32)-1:9*32]	:
						((addr[19:12]==(8'h0a))?bram_data_in[(11*32)-1:10*32]	:
						((addr[19:12]==(8'h0b))?bram_data_in[(12*32)-1:11*32]	:
						((addr[19:12]==(8'h0c))?bram_data_in[(13*32)-1:12*32]	:
						((addr[19:12]==(8'h0d))?bram_data_in[(14*32)-1:13*32]	:
						((addr[19:12]==(8'h0e))?bram_data_in[(15*32)-1:14*32]	:
						((addr[19:12]==(8'h0f))?bram_data_in[(16*32)-1:15*32]	:
						((addr[19:12]==(8'h10))?bram_data_in[(17*32)-1:16*32]	:
						((addr[19:12]==(8'h11))?bram_data_in[(18*32)-1:17*32]	:
						((addr[19:12]==(8'h12))?bram_data_in[(19*32)-1:18*32]	:
						((addr[19:12]==(8'h13))?bram_data_in[(20*32)-1:19*32]	:
						((addr[19:12]==(8'h14))?bram_data_in[(21*32)-1:20*32]	:
						((addr[19:12]==(8'h15))?bram_data_in[(22*32)-1:21*32]	:
						((addr[19:12]==(8'h16))?bram_data_in[(23*32)-1:22*32]	:
						((addr[19:12]==(8'h17))?bram_data_in[(24*32)-1:23*32]	:
						((addr[19:12]==(8'h18))?bram_data_in[(25*32)-1:24*32]	:32'd0
						))))))))))))))))))))))));
endmodule
