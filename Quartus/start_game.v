module start_game (
    input wire clk,        // 입력 클럭
    input wire rst,      // 리셋 신호
    input wire start,
    output reg gamestart
);
    initial begin
        gamestart <= 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            gamestart <= 0;
        end else begin
            if(start)begin
                gamestart <= 1;
            end
        end
    end
endmodule
