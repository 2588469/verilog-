`timescale 1ns / 1ps
//------------------------------------------------------------------------------
//  (c) Copyright 2013-2018 Xilinx, Inc. All rights reserved.
//
//  This file contains confidential and proprietary information
//  of Xilinx, Inc. and is protected under U.S. and
//  international copyright and other intellectual property
//  laws.
//
//  DISCLAIMER
//  This disclaimer is not a license and does not grant any
//  rights to the materials distributed herewith. Except as
//  otherwise provided in a valid license issued to you by
//  Xilinx, and to the maximum extent permitted by applicable
//  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
//  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
//  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//  (2) Xilinx shall not be liable (whether in contract or tort,
//  including negligence, or under any other theory of
//  liability) for any loss or damage of any kind or nature
//  related to, arising under or in connection with these
//  materials, including for any direct, or any indirect,
//  special, incidental, or consequential loss or damage
//  (including loss of data, profits, goodwill, or any type of
//  loss or damage suffered as a result of any action brought
//  by a third party) even if such damage or loss was
//  reasonably foreseeable or Xilinx had been advised of the
//  possibility of the same.
//
//  CRITICAL APPLICATIONS
//  Xilinx products are not designed or intended to be fail-
//  safe, or for use in any application requiring fail-safe
//  performance, such as life-support or safety devices or
//  systems, Class III medical devices, nuclear facilities,
//  applications related to the deployment of airbags, or any
//  other applications that could lead to death, personal
//  injury, or severe property or environmental damage
//  (individually and collectively, "Critical
//  Applications"). Customer assumes the sole risk and
//  liability of any use of Xilinx products in Critical
//  Applications, subject only to applicable laws and
//  regulations governing limitations on product liability.
//
//  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//  PART OF THIS FILE AT ALL TIMES.
//------------------------------------------------------------------------------


module prbs_generate_check
#(
	parameter CHK_MODE			= 0;
	parameter INV_PATTERN		= 0;
	parameter POLY_LenGHT		= 7;
	parameter POLY_TAP			= 6;
	parameter NBITS				= 8;
)
(
	input									rst_n					;
	input									clk						;
	input			[NBITS - 1:0]			data_in					;
	input									en						;
	output 									data_out				;
	);
	
	reg				[NBITS - 1:0]			data_out_r = {NBITS{1'b1}}	;
  //--------------------------------------------		
  // Internal variables
  //--------------------------------------------		

   wire [1:POLY_LenGHT] prbs[NBITS:0];
   wire [NBITS - 1:0] data_in;
   wire [NBITS - 1:0] prbs_xor_a;
   wire [NBITS - 1:0] prbs_xor_b;
   wire [NBITS:1] prbs_msb;
   reg  [1:POLY_LenGHT]prbs_reg = {(POLY_LenGHT){1'b1}};

  //--------------------------------------------		
  // Implementation
  //--------------------------------------------		
   assign prbs[0] = prbs_reg; 
   
   genvar I;
   generate for (I=0; I<NBITS; I=I+1) begin : g1
      assign prbs_xor_a[I] = prbs[I][POLY_TAP] ^ prbs[I][POLY_LenGHT];
      assign prbs_xor_b[I] = prbs_xor_a[I] ^ data_in[I];
      assign prbs_msb[I+1] = CHK_MODE == 0 ? prbs_xor_a[I]  :  data_in[I];  
      assign prbs[I+1] = {prbs_msb[I+1] , prbs[I][1:POLY_LenGHT-1]};
   end
   endgenerate

   always @(posedge clk) begin
      if(rst_n == 1'b 1) begin
         prbs_reg <= {POLY_LenGHT{1'b1}};
         DATA_OUT <= {NBITS{1'b1}};
      end
      else if(en == 1'b 1) begin
         DATA_OUT <= prbs_xor_b;
         prbs_reg <= prbs[NBITS];
      end
  end

endmodule
