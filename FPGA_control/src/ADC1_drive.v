module ADC1_drive(
	input Clk,
	input Reset_n,
	input [7:0] AD_Data,
	input [7:0] Trigger,
	input ADC1_bg,
	input rdreq,
	input rdclk,
	output reg ADC1_end,
	output empty,
	output [7:0] ADC1_F_O_Data
);
	reg wrreq;
	reg sclr;
	wire full;
	
	// 实例化 ADC0_FIFO
	ADC1_FIFO ADC1_FIFO(
		.wrclk(Clk),
		.rdclk(rdclk),
		.data(AD_Data),
		.rdreq(rdreq),
		.aclr(sclr),
		.wrreq(wrreq),
		.rdempty(empty),
		.wrfull(full),
		.q(ADC1_F_O_Data)
	);

	reg [13:0] count;
	reg [2:0] state;
	reg Tri;
	
	reg [7:0]T0;
	reg [7:0]T1;
	always @(posedge Clk or negedge Reset_n) begin
		if (!Reset_n) begin
			count <= 13'd0;
			ADC1_end <= 0;
		end else begin
			if (ADC1_bg== 1) begin
				if (count <= 5130) begin
					count <= count + 1'd1;
					if (count >8 && count <1033 && Tri == 1) begin
						count <= 13'd1033;
					end
				end else if (full == 1) begin
						ADC1_end <= 1;
				end
			end else if(ADC1_bg== 0)begin 
				count <= 13'd0;
				ADC1_end <= 0;
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
			else if(ADC1_end ==1)
				state <= 3'd4;
			else if (count > 1032 && count <5132)
				state <= 3'd3;
			else if (Tri == 1)
				state <= 3'd3;
			else state <= 3'd0;
		end
	end
	always @(posedge Clk or negedge Reset_n) begin
		if (!Reset_n) begin
			sclr <= 1'b0;
			wrreq <= 1'b0;
			Tri<=0;
		end else begin
			case(state)
				3'd1: begin
					sclr <= 1'b1;
					wrreq <= 1'b0;
					Tri <= 0;
				end
				3'd2: begin
					sclr <= 1'b0;
					if (AD_Data > Trigger && AD_Data < (Trigger+4'd5)) begin
						if( T0 < AD_Data)
							Tri<=1;
					end else begin
						T0<=AD_Data;
					end
				end
				3'd3: begin
					Tri<=0;
					wrreq <= 1'b1;
				end
				3'd4: begin
					wrreq <= 1'b0;
				end
				default: begin
					sclr <= 1'b1;
					Tri <= 1'b0;
					wrreq <= 1'b0;
				end
			endcase
		end
	end
endmodule
