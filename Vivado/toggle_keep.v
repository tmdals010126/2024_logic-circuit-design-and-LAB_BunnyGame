module toggle_keep (
    input wire in,
    input wire clk,        // 입력 클럭
    input wire rst,      // 리셋 신호
    output reg out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 0;
        end else begin
            if(in)begin
                out <= ~out;
            end
        end
    end
endmodule
