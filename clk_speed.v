module clk_speed (
    input wire clk,        // 입력 클럭
    input wire rst,      // 리셋 신호
    // output reg [3:0] pos   // 4비트 출력
    output reg game_clk,
    output reg scoreUP
);

    reg [31:0] count;       // 클럭을 세는 레지스터
    reg [31:0] div;
    reg [31:0] counter;
    reg [31:0] score_count;

    initial begin
        count = 0;
        div = 25000;        // 초기화
        game_clk <= 0;
        counter <= 0;
        scoreUP <= 0;
        score_count <= 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            game_clk <= 0;
            div <= 25000;           // 클럭을 나누는 기준
            counter <= 0;
            scoreUP <= 0;
            score_count <= 0;
        end else begin
            if (count >= (div / 2)) begin
                game_clk <= ~game_clk; // Toggle piezo signal
                count <= 0;
            end else begin
                count <= count + 1;
            end
            // count <= count + 1;    // 클럭 상승 시 카운터 증가
            // if(count < (div/2)) begin
            //     game_clk <= 1;
            // end
            // else begin
            //     game_clk <= 0;
            // end
            if(div > 10000) begin
                if(counter<1000000)begin
                    counter = counter + 1;
                end
                else begin
                    counter = 0;
                    div = div - 500;      // 점점 클럭 div가 낮아져 속도가 빨라짐
                end
            end
            else begin
                if(counter<1000000)begin
                    counter = counter + 1;
                end
                else begin
                    counter = 0;
                    div = div - 250;      // 점점 클럭 div가 낮아져 속도가 빨라짐
                    if(div < 2500) begin
                        div = 2500;
                    end
                end
            end
            if (score_count >= ((div*5))) begin
                scoreUP <= 1; // Toggle piezo signal
                score_count <= 0;
            end else begin
                score_count <= score_count + 1;
                scoreUP <= 0;
            end
        end
    end

endmodule
