module score_toggle (
    input wire clk_1MHz, // 1 MHz clock input
    input wire rst,
    input [3:0] digit1in,  // 첫 번째 자리수 (0~9)
    input [3:0] digit2in,  // 두 번째 자리수 (0~9)
    input [3:0] digit3in,  // 세 번째 자리수 (0~9)
    input [3:0] digit4in,  // 네 번째 자리수 (0~9)
    input [3:0] digit5in,  // 다섯 번째 자리수 (0~9)
    input [3:0] digit6in,  // 여섯 번째 자리수 (0~9)
    input [3:0] digit7in,  // 일곱 번째 자리수 (0~9)
    input [3:0] digit8in,  // 여덟 번째 자리수 (0~9)

    output reg [3:0] digit1out,  // 첫 번째 자리수 (0~9)
    output reg [3:0] digit2out,  // 두 번째 자리수 (0~9)
    output reg [3:0] digit3out,  // 세 번째 자리수 (0~9)
    output reg [3:0] digit4out,  // 네 번째 자리수 (0~9)
    output reg [3:0] digit5out,  // 다섯 번째 자리수 (0~9)
    output reg [3:0] digit6out,  // 여섯 번째 자리수 (0~9)
    output reg [3:0] digit7out,  // 일곱 번째 자리수 (0~9)
    output reg [3:0] digit8out  // 여덟 번째 자리수 (0~9)
);
    initial begin
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            digit1out <= 0;
            digit2out <= 0;
            digit3out <= 0;
            digit4out <= 0;
            digit5out <= 0;
            digit6out <= 0;
            digit7out <= 0;
            digit8out <= 0;
        end else begin
            digit1out <= digit1in;
            digit2out <= digit2in;
            digit3out <= digit3in;
            digit4out <= digit4in;
            digit5out <= digit5in;
            digit6out <= digit6in;
            digit7out <= digit7in;
            digit8out <= digit8in;
        end
    end
endmodule