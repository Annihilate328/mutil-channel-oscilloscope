module Uart(
    input wire Clk,
    input wire Reset_n,
    input wire [7:0] Data,
    input wire send_en,
    output reg uart_tx,
    output reg tx_done
);
    wire w_tx_done;
    parameter CLOCK_FREQ = 50_000_000;
    parameter BAUD = 115200;
    parameter MCNT_BIT = 4'd9; // 4-bit counter to count 0-9
    parameter MCNT_BAUD = 20'd434; // Calculated baud rate counter (CLOCK_FREQ / BAUD - 1)

    reg [19:0] baud_div_cnt; // 20-bit counter for baud rate division
    reg en_baud_cnt;
    reg [3:0] bit_cnt; // 4-bit counter to count the bits
    reg [7:0] r_Data;

    // Enable baud counter logic
    always @(posedge Clk or negedge Reset_n) begin
        if (!Reset_n) begin
            en_baud_cnt <= 0;
        end else if (send_en) begin
            en_baud_cnt <= 1;
        end else if (w_tx_done) begin
            en_baud_cnt <= 0;
        end
    end

    // Baud rate division counter
    always @(posedge Clk or negedge Reset_n) begin
        if (!Reset_n) begin
            baud_div_cnt <= 0;
        end else if (en_baud_cnt) begin
            if (baud_div_cnt == MCNT_BAUD) begin
                baud_div_cnt <= 0;
            end else begin
                baud_div_cnt <= baud_div_cnt + 1'd1;
            end
        end else begin
            baud_div_cnt <= 0;
        end
    end

    // Bit counter logic
    always @(posedge Clk or negedge Reset_n) begin
        if (!Reset_n) begin
            bit_cnt <= 0;
        end else if (baud_div_cnt == MCNT_BAUD) begin
            if (bit_cnt == MCNT_BIT) begin
                bit_cnt <= 0;
            end else begin
                bit_cnt <= bit_cnt + 1'd1;
            end
        end
    end

    // Store data to be transmitted
    always @(posedge Clk or negedge Reset_n) begin
        if (!Reset_n) begin
            r_Data <= 0;
        end else if (send_en) begin
            r_Data <= Data;
        end
    end

    // UART transmission logic
    always @(posedge Clk or negedge Reset_n) begin
        if (!Reset_n) begin
            uart_tx <= 1;
        end else begin
            case (bit_cnt)
                4'd0: uart_tx <= 0; // Start bit
                4'd1: uart_tx <= r_Data[0];
                4'd2: uart_tx <= r_Data[1];
                4'd3: uart_tx <= r_Data[2];
                4'd4: uart_tx <= r_Data[3];
                4'd5: uart_tx <= r_Data[4];
                4'd6: uart_tx <= r_Data[5];
                4'd7: uart_tx <= r_Data[6];
                4'd8: uart_tx <= r_Data[7];
                4'd9: uart_tx <= 1; // Stop bit
                default: uart_tx <= 1;
            endcase
        end
    end

    // Transmission done signal
    assign w_tx_done = ((bit_cnt == MCNT_BIT) && (baud_div_cnt == MCNT_BAUD));

    always @(posedge Clk or negedge Reset_n) begin
        if (!Reset_n) begin
            tx_done <= 0;
        end else begin
            tx_done <= w_tx_done;
        end
    end

endmodule
