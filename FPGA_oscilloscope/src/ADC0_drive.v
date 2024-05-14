module ADC0_drive(
    input wire ADC0_bg,
    input wire ADC0_Clk, // ADC0输入时钟
    input wire rdclk,
    input wire Reset_n, // 复位
    input wire [7:0] Trigger_lever, // 触发电平
    input wire [7:0] I_AD_Data, // ADC输入数据
    input wire ADC0_rdreq,
    output wire [7:0] F_O_ADC0_Data, // FIFO数据出口
    output wire ADC_Clk,
    output wire ADC0_rdempty
);

    reg [9:0] add;
    reg bg;
    reg wrreq;
    reg ADC0_sclr;
    reg [7:0] F_I_ADC0_Data;
    wire full;

    assign ADC_Clk = ADC0_Clk;

    // FIFO 实例化
    ADC0_FIFO ADC0_FIFO_inst (
        .wrclk(ADC0_Clk),
        .rdclk(rdclk),
        .data(F_I_ADC0_Data),
        .rdreq(ADC0_rdreq),
        .wrreq(wrreq),
        .aclr(ADC0_sclr),
        .rdempty(ADC0_rdempty),
        .wrfull(full),
        .q(F_O_ADC0_Data)
    );

    // 计数器逻辑
    always @(posedge ADC0_Clk or negedge Reset_n) begin
        if (!Reset_n) begin
            add <= 10'd0;
        end else begin
            if (add != 10'd1023 && I_AD_Data != Trigger_lever)
                add <= add + 10'd1;
            else if (bg && ADC0_bg)
                add <= 10'd0;
        end
    end

    // 数据采集逻辑
    always @(posedge ADC0_Clk or negedge Reset_n) begin
        if (!Reset_n) begin
            wrreq <= 1'b0;
            bg <= 1'b0;
            ADC0_sclr <= 1'b1;
        end else begin
            ADC0_sclr <= 1'b0;
            if (!full && bg) begin
                wrreq <= 1'b1;
                F_I_ADC0_Data <= I_AD_Data;
            end else if (full) begin
                bg <= 1'b0;
                wrreq <= 1'b0;
            end else if (I_AD_Data == Trigger_lever || add == 10'd1023) begin
                bg <= 1'b1;
            end
        end
    end

endmodule
