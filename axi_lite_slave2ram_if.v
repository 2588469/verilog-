
`timescale 1ns/100ps

module axi_lite_slave2ram_if #(

	parameter	BASE_ADDR	= 32'h0000_0000						,
	parameter	MEM_SIZE	= 32'h0002_0000						
	) (
	
	// reset and clocks
	
	input								rst_n				,
	input								clk					,
	
	// axi4 interface
	
	input								s_axi_awvalid		,
	input			[31:0]				s_axi_awaddr		,
	output								s_axi_awready		,
	
	input								s_axi_wvalid		,
	input			[31:0]				s_axi_wdata			,
	input			[3:0]				s_axi_wstrb			,
	output								s_axi_wready		,
	
	output								s_axi_bvalid		,
	output			[1:0]				s_axi_bresp			,
	input								s_axi_bready		,
	
	input								s_axi_arvalid		,
	input			[31:0]				s_axi_araddr		,
	output								s_axi_arready		,
	
	output								s_axi_rvalid		,
	output			[1:0]				s_axi_rresp			,
	output			[31:0]				s_axi_rdata			,
	input								s_axi_rready		,
	
	// pcore interface
	(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 bram_port CLK" *)
	output								bram_clk			,
	(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 bram_port RST" *)
	output								bram_rst			,
	
	(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 bram_port WE" *)
	output			[3:0]				bram_we				,
	(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 bram_port ADDR" *)
	output			[31:0]				bram_addr			,
	(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 bram_port DOUT" *)
	output			[31:0]				bram_dout			,
	(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 bram_port DIN" *)
	input			[31:0]				bram_din			,
	(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 bram_port EN" *)
	output								bram_en				
	);
	
	// internal registers
	localparam		BUS_IDLE_STATE			= 4'd0			;
	localparam		WRITE_ADDR_STATE		= 4'd1			;
	localparam		WRITE_DATA_STATE		= 4'd2			;
	localparam		WRITE_RESP_STATE		= 4'd3			;
	localparam		READ_ADDR_STATE			= 4'd4			;
	localparam		READ_DATA_STATE			= 4'd5			;
	
	reg				[3:0]				state_r				;
	
	always @(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				begin
					state_r <= BUS_IDLE_STATE;
				end
			else
				begin
					case(state_r)
						BUS_IDLE_STATE:
							begin//write first
								if(s_axi_awvalid&s_axi_arvalid)
									begin
										state_r <= WRITE_ADDR_STATE;
									end
								else if(s_axi_awvalid)
									begin
										state_r <= WRITE_ADDR_STATE;
									end
								else if(s_axi_arvalid)
									begin
										state_r <= READ_ADDR_STATE;
									end
								else
									begin
										state_r <= BUS_IDLE_STATE;
									end
							end
						WRITE_ADDR_STATE:
							begin
								if(s_axi_awvalid&s_axi_awready)
									begin
										state_r <= WRITE_DATA_STATE;
									end
								else
									begin
										state_r <= WRITE_ADDR_STATE;
									end
							end
						WRITE_DATA_STATE:
							begin
								if(s_axi_wvalid&s_axi_wready)
									begin
										state_r <= WRITE_RESP_STATE;
									end
								else
									begin
										state_r <= WRITE_DATA_STATE;
									end
							end
						WRITE_RESP_STATE:
							begin
								if(s_axi_bvalid&s_axi_bready)
									begin
										state_r <= BUS_IDLE_STATE;
									end
								else
									begin
										state_r <= WRITE_RESP_STATE;
									end
							end
						READ_ADDR_STATE:
							begin
								if(s_axi_arvalid&s_axi_arready)
									begin
										state_r <= READ_DATA_STATE;
									end
								else
									begin
										state_r <= READ_ADDR_STATE;
									end
							end
						READ_DATA_STATE:
							begin
								if(s_axi_rvalid&s_axi_rready)
									begin
										state_r <= BUS_IDLE_STATE;
									end
								else
									begin
										state_r <= READ_DATA_STATE;
									end
							end
					endcase
				end
		end

//==================================================================
//s_axi_awready
//{
reg			s_axi_awready_r							;
assign s_axi_awready			= s_axi_awready_r;
always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				s_axi_awready_r <= 1'b0			;
			end
		else
			begin
				if(s_axi_awvalid & s_axi_awready_r)
					begin
						s_axi_awready_r <= 1'b0;
					end
				else if( s_axi_awvalid & (state_r == BUS_IDLE_STATE) )
					begin
						s_axi_awready_r <= 1'b1		;
					end
				else
					begin
						s_axi_awready_r <= s_axi_awready_r;
					end
			end
	end
//}

//==================================================================
//s_axi_awaddr
//{
reg			[31:0]		addr_lock_r		;
always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				addr_lock_r	<= 32'h0000_0000;
			end
		else if(s_axi_awready&s_axi_awvalid)
			begin
				addr_lock_r <= s_axi_awaddr - BASE_ADDR ;
			end
		else if(s_axi_arready&s_axi_arvalid)
			begin
				addr_lock_r <= s_axi_araddr - BASE_ADDR ;
			end
	end
//}

//==================================================================
//s_axi_wready
//{
reg			s_axi_wready_r							;
assign s_axi_wready			= s_axi_wready_r	;
always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				s_axi_wready_r <= 1'b0			;
			end
		else 
			begin
				if( s_axi_wready_r & s_axi_wvalid )
					begin
						s_axi_wready_r <= 1'b0;
					end
				else if( s_axi_wvalid & (state_r == WRITE_DATA_STATE) )
					begin
						s_axi_wready_r <= 1'b1;
					end
				else
					begin
						s_axi_wready_r <= s_axi_wready_r;
					end
			end
	end
//}

//==================================================================
//s_axi_bvalid
//{
reg			[31:0]		s_axi_bvalid_r		;
assign s_axi_bvalid = s_axi_bvalid_r;
always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				s_axi_bvalid_r	<= 1'b0;
			end
		else if(bram_en&(state_r == WRITE_RESP_STATE))
			begin
				s_axi_bvalid_r <= 1'b1	;
			end
		else
			begin
				s_axi_bvalid_r	<= 1'b0;
			end
	end
//}

//==================================================================
//s_axi_wdata
//{
reg			[31:0]		data_lock_r		;
always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				data_lock_r	<= 32'h0000_0000;
			end
		else if(s_axi_wready&s_axi_wvalid)
			begin
				data_lock_r <= s_axi_wdata	;
			end
		else
			begin
				data_lock_r <= 32'h0000_0000;
			end
	end
//}

//==================================================================
//s_axi_arready
//{
reg			s_axi_arready_r							;
assign s_axi_arready			= s_axi_arready_r ;
always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				s_axi_arready_r <= 1'b0			;
			end
		else
			begin
				if(s_axi_arvalid & s_axi_arready_r)
					begin
						s_axi_arready_r <= 1'b0;
					end
				else if( s_axi_arvalid & (state_r == BUS_IDLE_STATE) )
					begin
						s_axi_arready_r <= 1'b1		;
					end
				else
					begin
						s_axi_arready_r <= s_axi_arready_r;
					end
			end
	end
//}

//====================================================================
//bram_we
//{
reg		[3:0]			bram_we_r		;
assign bram_we = bram_we_r	;
always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				bram_we_r <= 4'h0;
			end
		else
			begin
				if(state_r==WRITE_DATA_STATE)
					begin
						bram_we_r <= s_axi_wstrb;
					end
				else if(state_r==READ_DATA_STATE)
					begin
						bram_we_r <= 4'h0;
					end
				else
					begin
						bram_we_r <= 4'h0;
					end
			end
	end
//}

//====================================================================
//s_axi_rresp
//{
assign s_axi_rresp = 2'b00;
//}

//====================================================================
//s_axi_bresp
//{
assign s_axi_bresp = 2'b00;
//}

//====================================================================
//bram_addr
//{
assign bram_addr = addr_lock_r;
//}

//====================================================================
//bram_clk
//{
assign bram_clk = clk;
//}

//====================================================================
//bram_rst_n
//{
assign bram_rst = ~rst_n;
//}

//====================================================================
//bram_dout
//{
assign bram_dout = (bram_en&(|s_axi_wstrb))?data_lock_r:32'd0;
//}

//s_axi_rdata
//{
assign s_axi_rdata = (s_axi_rvalid&s_axi_rready)?bram_din:32'd0;
//}

//====================================================================
//bram_en
//{
reg			bram_en_r				;
assign bram_en = bram_en_r			;
always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				bram_en_r	<= 1'b0;
			end
		else
			begin
				if( s_axi_wready&s_axi_wvalid )
					begin
						bram_en_r <= 1'b1	;
					end
				else if( s_axi_arvalid&s_axi_arready )
					begin
						bram_en_r <= 1'b1	;
					end
				else
					begin
						bram_en_r <= 1'b0	;
					end

			end
	end
//}

//====================================================================
//s_axi_rvalid
//{
reg		s_axi_rvalid_r				;
assign s_axi_rvalid = s_axi_rvalid_r;
always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				s_axi_rvalid_r <= 1'b0;
			end
		else
			begin
				if(s_axi_rvalid_r)
					begin
						s_axi_rvalid_r <= 1'b0;
					end
				else if (bram_en&(bram_we == 4'h0))
					begin
						s_axi_rvalid_r <= 1'b1;
					end
				else
					begin
						s_axi_rvalid_r <= 1'b0;
					end
			end
	end
//}

endmodule
