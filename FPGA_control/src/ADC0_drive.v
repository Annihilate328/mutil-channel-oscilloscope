module ADC0_drive(
	input Clk,
	input Reset_n,
	input [7:0] AD_Data,
	input [7:0] Trigger,
	input ADC0_bg,
	input rdreq,
	output reg ADC0_end,
	output empty,
	output [7:0] ADC0_F_O_Data
);
	reg wrreq;
	reg sclr;
	wire full;
	
	// 实例化 ADC0_FIFO
	ADC0_FIFO ADC0_FIFO_inst(
		.clock(Clk),
		.data(AD_Data),
		.rdreq(rdreq),
		.sclr(sclr),
		.wrreq(wrreq),
		.empty(empty),
		.full(full),
		.q(ADC0_F_O_Data),
		.usedw()
	);

	reg [12:0] count;
	reg [2:0] state;
	reg Tri;

	always @(posedge Clk or negedge Reset_n) begin
		if (!Reset_n) begin
			count <= 13'd0;
			ADC0_end <= 0;
		end else begin
			if (count <= 5130) begin
				count <= count + 1;
			end else if (count > 5129 && full == 1) begin
				ADC0_end <= 1;
			end else if (count > 5130 && ADC0_bg == 1) begin
				count <= 13'd0;
				ADC0_end <= 0;
			end else if (count > 5130 && empty == 1) begin
				ADC0_end <= 0;
			end
		end
	end

	always @(posedge Clk or negedge Reset_n) begin
		if (!Reset_n) begin
			state <= 3'd0;
		end else begin
			if (count < 9)
				state <= 3'd1;
			else if (count > 8 && count < 1033)
				state <= 3'd2;
			else if(ADC0_end ==1)
				state <= 3'd4;
			else if (count > 1032 || Tri == 1)
				state <= 3'd3;
			else state <= 3'd0;
		end
	end

	always @(posedge Clk or negedge Reset_n) begin
		if (!Reset_n) begin
			sclr <= 1'b0;
			wrreq <= 1'b0;
		end else begin
			case(state)
				3'd1: begin
					sclr <= 1'b1;
					wrreq <= 1'b0;
				end
				3'd2: begin
					sclr <= 1'b0;
					Tri <= 0;
					if (AD_Data > Trigger) begin
						Tri <= 1;
					end
				end
				3'd3: begin
					wrreq <= 1'b1;
				end
				3'd4: begin
					wrreq <= 1'b0;
				end
				default: begin
					sclr <= 1'b0;
					Tri <= 1'b0;
					wrreq <= 1'b0;
				end
			endcase
		end
	end
endmodule
