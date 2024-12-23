module counter16 (
    input wire clk,        // 입력 클럭
    input wire rst_n,      // 리셋 신호
    output reg [3:0] pos   // 4비트 출력
);

    reg [3:0] count;       // 클럭을 세는 레지스터

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'b0;
            pos <= 4'b0;
        end else begin
            count <= count + 1;    // 클럭 상승 시 카운터 증가
            // if (count == 4'b1111) begin // 16의 배수일 때
            //     count <= 4'b0;    // 카운터 초기화
            //     pos <= pos + 1;   // pos 값 증가
            // end
            pos <= count;
        end
    end

endmodule
