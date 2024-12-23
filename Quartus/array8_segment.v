module array8_segment(
    input clk,
    input rst,
    input scoreUP,
    output reg [7:0] com,
    output reg [6:0] num_data,
    output reg [3:0] digit1,  // 첫 번째 자리수 (0~9)
    output reg [3:0] digit2,  // 두 번째 자리수 (0~9)
    output reg [3:0] digit3,  // 세 번째 자리수 (0~9)
    output reg [3:0] digit4,  // 네 번째 자리수 (0~9)
    output reg [3:0] digit5,  // 다섯 번째 자리수 (0~9)
    output reg [3:0] digit6,  // 여섯 번째 자리수 (0~9)
    output reg [3:0] digit7,  // 일곱 번째 자리수 (0~9)
    output reg [3:0] digit8  // 여덟 번째 자리수 (0~9)
);

    reg [6:0] segment_num[9:0]; // segment 숫자 설정 저장
    reg [3:0] index = 0;        // 숫자 출력에 해당하는 인덱스
    reg [3:0] state = 0;
    reg [3:0] score[7:0];
    reg [3:0] num = 0;

    initial begin
        segment_num[0] = 7'b1111110;
        segment_num[1] = 7'b0110000;
        segment_num[2] = 7'b1101101;
        segment_num[3] = 7'b1111001;
        segment_num[4] = 7'b0110011;
        segment_num[5] = 7'b1011011;
        segment_num[6] = 7'b1011111;
        segment_num[7] = 7'b1110000;
        segment_num[8] = 7'b1111111;
        segment_num[9] = 7'b1111011;
        score[0] = 0;
        score[1] = 0;
        score[2] = 0;
        score[3] = 0;
        score[4] = 0;
        score[5] = 0;
        score[6] = 0;
        score[7] = 0;
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            score[0] = 0;
            score[1] = 0;
            score[2] = 0;
            score[3] = 0;
            score[4] = 0;
            score[5] = 0;
            score[6] = 0;
            score[7] = 0;

            digit1 = score[0];
            digit2 = score[1];
            digit3 = score[2];
            digit4 = score[3];
            digit5 = score[4];
            digit6 = score[5];
            digit7 = score[6];
            digit8 = score[7];

            index <= 0;
            state <= 0;
            com <= 0;
            num_data <= 0;
            num <= 0;
        end
        else begin
            if(scoreUP)begin
                score[0] = score[0] + 1;
                if(score[0]>9) begin
                    score[0] = 0;
                    score[1] = score[1] + 1;
                    if(score[1]>9) begin
                        score[1] = 0;
                        score[2] = score[2] + 1;
                        if(score[2]>9) begin
                            score[2] = 0;
                            score[3] = score[3] + 1;
                            if(score[3]>9) begin
                                score[3] = 0;
                                score[4] = score[4] + 1;
                                if(score[4]>9) begin
                                    score[4] = 0;
                                    score[5] = score[5] + 1;
                                    if(score[5]>9) begin
                                        score[5] = 0;
                                        score[6] = score[6] + 1;
                                        if(score[6]>9) begin
                                            score[6] = 0;
                                            score[7] = score[7] + 1;
                                            if(score[7]>9) begin
                                                score[0] = 9;
                                                score[1] = 9;
                                                score[2] = 9;
                                                score[3] = 9;
                                                score[4] = 9;
                                                score[5] = 9;
                                                score[6] = 9;
                                                score[7] = 9;
                                            end                                            
                                        end                                        
                                    end                                    
                                end
                            end
                        end
                    end
                end
            end
            case (state)
                0: begin
                    index <= score[7];
                    state <= 8;
                    num <= 0;
                end
                1: begin
                    index <= score[6];
                    state <= 8;
                    num <= 1;
                end
                2: begin
                    index <= score[5];
                    state <= 8;
                    num <= 2;
                end
                3: begin
                    index <= score[4];
                    state <= 8;
                    num <= 3;
                end
                4: begin
                    index <= score[3];
                    state <= 8;
                    num <= 4;
                end
                5: begin
                    index <= score[2];
                    state <= 8;
                    num <= 5;
                end
                6: begin
                    index <= score[1];
                    state <= 8;
                    num <= 6;
                end
                7: begin
                    index <= score[0];
                    state <= 8;
                    num <= 7;
                end
                8: begin
                    digit1 <= score[0];
                    digit2 <= score[1];
                    digit3 <= score[2];
                    digit4 <= score[3];
                    digit5 <= score[4];
                    digit6 <= score[5];
                    digit7 <= score[6];
                    digit8 <= score[7];
                    num_data <= segment_num[index];
                    case (num)
                        0: com <= 8'b01111111;
                        1: com <= 8'b10111111;
                        2: com <= 8'b11011111;
                        3: com <= 8'b11101111;
                        4: com <= 8'b11110111;
                        5: com <= 8'b11111011;
                        6: com <= 8'b11111101;
                        7: com <= 8'b11111110;
                    endcase
                    if(num == 7) begin
                        state <= 0;
                    end
                    else begin
                        state <= num + 1; // 다음 state로 진행
                    end
                end
            endcase

        end
    end
endmodule
