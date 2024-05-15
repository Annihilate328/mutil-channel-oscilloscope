module mutil_channel_oscilloscope (
	input CLk,
	input Reset_n,
	input [7:0] AD_Data,
	input wrreq,
	input [7:0] Trigger,
	output empty,
	output [7:0] ADC0_F_O_Data,
);
	reg rdreq;
	reg sclr;
	wire full;
ADC0_FIFO ADC0_FIFO(
	.clock(CLk),
	.data(AD_Data),
	.rdreq(rdreq),
	.sclr(sclr),
	.wrreq(wrreq),
	.empty(empty),
	.full(full),
	.q(ADC0_F_O_Data)
);
	reg [12:0] count;
	reg [2:0] state;
	reg [7:0] R_Data;
	reg Tri;
	always@(posedge Clk or negedge Reset_n)begin
		if(!Reset_n)begin
			count <= 12'd0;
		end else begin
			if(count <= 5129)
				count <= count + 1'd1;
			else if(count > 5129)
				count <= 12'd0;
		end
	end
	always@(posedge Clk or negedge Reset_n)begin
		if(!Reset_n)begin
			state <= 0;
		end else begin
			if(count <=8)
				state <= 2'd1;
			else if(count >12'd8 && count <= 12'd1032)
				state <= 2'd2;
			else if((count >1032 && count <=12'd5129)|| Tri == 1)
				state <= 2'd3;
		end
	end
	always@(posedge Clk or negedge Reset_n)begin
		if(!Reset_n)begin
		end else begin
			if(state == 1'd1)begin
				sclr <= 1;
				wrreq <= 0;
			end else if(state == 2'd2)begin
				wrreq <= 1;
				Tri <= 0;
				if(#25 AD_Data >= Trigger)begin
					R_Data <= AD_Data;
					Tri <= 1;
				end
			end else if(state == 2'd3)begin
				wrreq <= 1;
				#25 R_Data <= AD_Data;
			end
		end 
	end
endmodule
			