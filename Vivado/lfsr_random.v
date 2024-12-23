module lfsr_random(
    input clk,              // 클럭 입력
    input reset,            // 리셋 입력
    output reg [7:0] random // 8비트 난수 출력
);

    // 초기 시드 값. 모든 비트가 0이면 LFSR이 동작하지 않으므로 1로 초기화
    initial random = 8'b00011111;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            random <= 8'b00000001;   // 리셋 시 초기값
        end else begin
            random <= {random[6:0], random[7] ^ random[5] ^ random[4] ^ random[3]};
        end
    end
endmodule