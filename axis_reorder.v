
`timescale 1ns/100ps

module axis_data_reorder
#(
	parameter	DATA_WIDE		= 64						,
	parameter	DATA_TAP		= 32						
 ) (
	output								m_axis_tvalid		,
	input								m_axis_tready		,
	output		[DATA_WIDE-1:0]			m_axis_tdata		,
	output		[(DATA_WIDE/8)-1:0]		m_axis_tkeep		,
	output		[DATA_WIDE-1:0]			m_axis_tlast		,
 
	input								s_axis_tvalid		,
	output								s_axis_tready		,
	input		[DATA_WIDE-1:0]			s_axis_tdata		,
	input		[(DATA_WIDE/8)-1:0]		s_axis_tkeep		,
	input		[DATA_WIDE-1:0]			s_axis_tlast		
);
	localparam	REORDER_NUM		= DATA_WIDE/DATA_TAP		;
	
	assign m_axis_tvalid	= s_axis_tvalid		;
	assign s_axis_tready	= m_axis_tready		;
	assign m_axis_tkeep		= s_axis_tkeep		;
	assign m_axis_tlast		= s_axis_tlast		;
	
	generate
		if(REORDER_NUM == 2)
			begin
				assign m_axis_tdata =  {s_axis_tdata[DATA_TAP-1:0],
										s_axis_tdata[DATA_WIDE-1:DATA_TAP]};
			end
		else if(REORDER_NUM == 4)
			begin
				assign m_axis_tdata =  {s_axis_tdata[(DATA_WIDE-DATA_TAP*3)-1:(DATA_WIDE-DATA_TAP*4)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*2)-1:(DATA_WIDE-DATA_TAP*3)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*1)-1:(DATA_WIDE-DATA_TAP*2)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*0)-1:(DATA_WIDE-DATA_TAP*1)]};
			end
		else if(REORDER_NUM == 8)
			begin
				assign m_axis_tdata =  {s_axis_tdata[(DATA_WIDE-DATA_TAP*7)-1:(DATA_WIDE-DATA_TAP*8)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*6)-1:(DATA_WIDE-DATA_TAP*7)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*5)-1:(DATA_WIDE-DATA_TAP*6)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*4)-1:(DATA_WIDE-DATA_TAP*5)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*3)-1:(DATA_WIDE-DATA_TAP*4)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*2)-1:(DATA_WIDE-DATA_TAP*3)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*1)-1:(DATA_WIDE-DATA_TAP*2)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*0)-1:(DATA_WIDE-DATA_TAP*1)]};
			end
		else if(REORDER_NUM == 16)
			begin
				assign m_axis_tdata =  {s_axis_tdata[(DATA_WIDE-DATA_TAP*15)-1:(DATA_WIDE-DATA_TAP*16)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*14)-1:(DATA_WIDE-DATA_TAP*15)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*13)-1:(DATA_WIDE-DATA_TAP*14)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*12)-1:(DATA_WIDE-DATA_TAP*13)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*11)-1:(DATA_WIDE-DATA_TAP*12)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*10)-1:(DATA_WIDE-DATA_TAP*11)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*9)-1:(DATA_WIDE-DATA_TAP*10)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*8)-1:(DATA_WIDE-DATA_TAP*9)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*7)-1:(DATA_WIDE-DATA_TAP*8)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*6)-1:(DATA_WIDE-DATA_TAP*7)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*5)-1:(DATA_WIDE-DATA_TAP*6)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*4)-1:(DATA_WIDE-DATA_TAP*5)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*3)-1:(DATA_WIDE-DATA_TAP*4)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*2)-1:(DATA_WIDE-DATA_TAP*3)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*1)-1:(DATA_WIDE-DATA_TAP*2)],
										s_axis_tdata[(DATA_WIDE-DATA_TAP*0)-1:(DATA_WIDE-DATA_TAP*1)]};
			end
	endgenerate
	
endmodule