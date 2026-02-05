module mastermind(
    input clk,
    input rst,
    
    input enterA,
    input enterB,
    input [2:0] letterIn,            
   
    output reg [7:0] LEDX,
    output reg [6:0] SSD3,
    output reg [6:0] SSD2,
    output reg [6:0] SSD1,
    output reg [6:0] SSD0 
);
    
    parameter [4:0] START = 5'd0;
    parameter [4:0] SHOW_SCORE = 5'd1;
    parameter [4:0] SHOW_ACTIVE_PLAYER = 5'd2;
    parameter [4:0] CODE_MAKER_INPUT_1 = 5'd3;
    parameter [4:0] CODE_MAKER_INPUT_2 = 5'd4;
    parameter [4:0] CODE_MAKER_INPUT_3 = 5'd5;
    parameter [4:0] CODE_MAKER_INPUT_4 = 5'd6;
    parameter [4:0] SHOW_BREAKER_LIVES = 5'd7;
    parameter [4:0] CODE_BREAKER_INPUT_1 = 5'd8;
    parameter [4:0] CODE_BREAKER_INPUT_2 = 5'd9;
    parameter [4:0] CODE_BREAKER_INPUT_3 = 5'd10;
    parameter [4:0] CODE_BREAKER_INPUT_4 = 5'd11;
    parameter [4:0] CHECK_CODE = 5'd12;
    parameter [4:0] SHOW_CORRECT = 5'd13;
    parameter [4:0] WAIT_NEXT = 5'd14;
    parameter [4:0] END_ROUND = 5'd15;
    parameter [4:0] SHOW_ACTIVE_BREAKER = 5'd16;
    
    reg [4:0] cState;
    reg [4:0] nState;
    
    reg [2:0] code [3:0];
    reg [2:0] guess [3:0];
    reg [3:0] scoreA;
    reg [3:0] scoreB;
    reg [2:0] lives;         
    reg codeMaker;
    reg [7:0] waitCounter;
    
    always @(posedge clk or negedge rst) 
    begin
        if (!rst) begin
            cState <= START;
            scoreA <= 4'd0;
            scoreB <= 4'd0;
            lives <= 3'd3;
            codeMaker <= 1'b0;
            waitCounter <= 8'd0;
            code[0] <= 3'b000; code[1] <= 3'b000; code[2] <= 3'b000; code[3] <= 3'b000;
            guess[0] <= 3'b000; guess[1] <= 3'b000; guess[2] <= 3'b000; guess[3] <= 3'b000;
        end
        else 
            begin
            cState <= nState;
            
            if (cState == CODE_MAKER_INPUT_1 && ((codeMaker == 0 && enterA) || (codeMaker == 1 && enterB)) && letterIn != 3'b000)
                code[3] <= letterIn;
            if (cState == CODE_MAKER_INPUT_2 && ((codeMaker == 0 && enterA) || (codeMaker == 1 && enterB)) && letterIn != 3'b000)
                code[2] <= letterIn;
            if (cState == CODE_MAKER_INPUT_3 && ((codeMaker == 0 && enterA) || (codeMaker == 1 && enterB)) && letterIn != 3'b000)
                code[1] <= letterIn;
            if (cState == CODE_MAKER_INPUT_4 && ((codeMaker == 0 && enterA) || (codeMaker == 1 && enterB)) && letterIn != 3'b000)
                code[0] <= letterIn;
            
            if (cState == CODE_BREAKER_INPUT_1 && ((codeMaker == 1 && enterA) || (codeMaker == 0 && enterB)) && letterIn != 3'b000)
                guess[3] <= letterIn;
            if (cState == CODE_BREAKER_INPUT_2 && ((codeMaker == 1 && enterA) || (codeMaker == 0 && enterB)) && letterIn != 3'b000)
                guess[2] <= letterIn;
            if (cState == CODE_BREAKER_INPUT_3 && ((codeMaker == 1 && enterA) || (codeMaker == 0 && enterB)) && letterIn != 3'b000)
                guess[1] <= letterIn;
            if (cState == CODE_BREAKER_INPUT_4 && ((codeMaker== 1 && enterA) || (codeMaker == 0 && enterB)) && letterIn != 3'b000)
                guess[0] <= letterIn;
            
            if (cState == CHECK_CODE && nState == END_ROUND)
                begin
                    if(codeMaker == 1'b0)
                        scoreB <= scoreB + 1;
                    else
                        scoreA <= scoreA + 1;
                end
            
            if (cState == WAIT_NEXT && ((codeMaker == 1 && enterA) || (codeMaker == 0 && enterB))) 
            begin
                if(lives > 3'd1)
                    lives <= lives - 1;
                else 
                    begin
                    if(codeMaker == 1'b0)
                        scoreA <= scoreA + 1;
                    else
                        scoreB <= scoreB + 1;
                end
            end
            
            if (cState == END_ROUND && waitCounter >= 8'd100) begin
                if (scoreA != 4'd2 && scoreB != 4'd2) begin
                    lives <= 3'd3;
                    if (codeMaker == 1'b0)
                        codeMaker <= 1'b1;
                    else
                        codeMaker <= 1'b0;
                end
            end
            if (cState == START && (enterA || enterB)) 
            begin
                scoreA <= 4'd0;
                scoreB <= 4'd0;
                lives <= 3'd3;
                if (enterA)
                    codeMaker <= 1'b0;
                else
                    codeMaker <= 1'b1;
            end
            if (cState != nState) begin
                waitCounter <= 8'd0;
            end
            else if (cState == SHOW_SCORE || 
                cState == SHOW_ACTIVE_PLAYER || 
                cState == SHOW_BREAKER_LIVES || 
                cState == SHOW_CORRECT || 
                cState == END_ROUND ||
                cState == SHOW_ACTIVE_BREAKER) begin
                waitCounter <= waitCounter + 1;
            end
            else begin
                waitCounter <= 8'd0;
            end
        end
    end
    
    always @(*) begin
        nState = cState;
        case(cState)
            START: begin
                if (enterA || enterB) 
                    nState = SHOW_SCORE;
            end
            SHOW_SCORE: begin
                if (waitCounter >=8'd100) 
                    nState = SHOW_ACTIVE_PLAYER;
            end
            SHOW_ACTIVE_PLAYER: begin
                if (waitCounter >= 8'd100) 
                    nState = CODE_MAKER_INPUT_1;
            end
            CODE_MAKER_INPUT_1: begin
                if (((codeMaker == 0 && enterA) || (codeMaker == 1 && enterB)) && letterIn != 3'b000)
                    nState = CODE_MAKER_INPUT_2;
            end
            CODE_MAKER_INPUT_2: begin
                if (((codeMaker == 0 && enterA) || (codeMaker == 1 && enterB)) && letterIn != 3'b000)
                    nState = CODE_MAKER_INPUT_3;
            end
            CODE_MAKER_INPUT_3: begin
                if (((codeMaker == 0 && enterA) || (codeMaker == 1 && enterB)) && letterIn != 3'b000) 
                    nState = CODE_MAKER_INPUT_4;
            end
            CODE_MAKER_INPUT_4: begin
                if (((codeMaker == 0 && enterA) || (codeMaker == 1 && enterB)) && letterIn != 3'b000) 
                    nState = SHOW_ACTIVE_BREAKER;
            end
            SHOW_ACTIVE_BREAKER: begin
                if (waitCounter >= 8'd100)
                    nState = SHOW_BREAKER_LIVES;
            end
            SHOW_BREAKER_LIVES: begin
                if (waitCounter >= 8'd100) 
                    nState = CODE_BREAKER_INPUT_1;
            end
            CODE_BREAKER_INPUT_1: begin
                if (((codeMaker == 1 && enterA) || (codeMaker == 0 && enterB)) && letterIn != 3'b000) 
                    nState=CODE_BREAKER_INPUT_2;
            end
            CODE_BREAKER_INPUT_2: begin
                if (((codeMaker == 1 && enterA) || (codeMaker == 0 && enterB)) && letterIn != 3'b000) 
                    nState=CODE_BREAKER_INPUT_3;
            end
            CODE_BREAKER_INPUT_3: begin
                if (((codeMaker == 1 && enterA) || (codeMaker == 0 && enterB)) && letterIn != 3'b000) 
                    nState=CODE_BREAKER_INPUT_4;
            end
            CODE_BREAKER_INPUT_4: begin
                if (((codeMaker == 1 && enterA) || (codeMaker == 0 && enterB)) && letterIn != 3'b000) 
                    nState=CHECK_CODE;
            end
            CHECK_CODE: begin
                if (code[0] == guess[0] && code[1] == guess[1] && code[2] == guess[2] && code[3] == guess[3]) begin
                    if ((codeMaker==0 && enterB) || (codeMaker == 1 && enterA)) begin
                        nState = END_ROUND;
                    end
                    else begin
                        nState = CHECK_CODE;
                    end
                end
                else begin
                    nState = WAIT_NEXT;
                end
            end
            WAIT_NEXT:
                if ((codeMaker == 1 && enterA) || (codeMaker == 0 && enterB))
                    if (lives == 3'd1)
                        nState = SHOW_CORRECT;
                    else
                        nState = SHOW_BREAKER_LIVES;
            SHOW_CORRECT: 
                if (waitCounter >= 8'd100) 
                    nState = END_ROUND;
            END_ROUND:
                if (waitCounter >= 8'd100)
                    if ((scoreA == 4'd2) || (scoreB == 4'd2))
                        nState = START;
                    else
                        nState = SHOW_ACTIVE_PLAYER;
            default: nState = START;
        endcase
    end
    always @(*) begin
        SSD3 = 7'b1111111;
        SSD2 = 7'b1111111;
        SSD1 = 7'b1111111;
        SSD0 = 7'b1111111;
        LEDX = 8'b00000000;

        case (cState)

            START: begin
                SSD2 = 7'b0001000; // A
                SSD1 = 7'b0111111; // -
                SSD0 = 7'b0000011; // b
            end

            SHOW_SCORE: begin
                SSD1 = 7'b0111111; // -

                if (scoreA == 0) SSD2 = 7'b1000000;
                else if (scoreA == 1) SSD2 = 7'b1111001;
                else SSD2 = 7'b0100100;

                if (scoreB == 0) SSD0 = 7'b1000000;
                else if (scoreB == 1) SSD0 = 7'b1111001;
                else SSD0 = 7'b0100100;
            end

            SHOW_ACTIVE_PLAYER: begin
                SSD2 = 7'b0001100; // P
                SSD1 = 7'b0111111; // -
                if (codeMaker == 0) SSD0 = 7'b0001000; // A
                else SSD0 = 7'b0000011; // b
            end
            
            SHOW_ACTIVE_BREAKER: begin
                SSD2 = 7'b0001100; // P
                SSD1 = 7'b0111111; // -
                if (codeMaker == 0) SSD0 = 7'b0000011; // b
                else SSD0 = 7'b0001000; // A
            end


            CODE_MAKER_INPUT_1: begin
                if (letterIn == 3'b001) 
                    SSD3 = 7'b0001000;
                else if (letterIn == 3'b010) 
                    SSD3 = 7'b1000110;
                else if (letterIn == 3'b011) 
                    SSD3 = 7'b0000110;
                else if (letterIn == 3'b100) 
                    SSD3 = 7'b0001110;
                else if (letterIn == 3'b101) 
                    SSD3 = 7'b0001001;
                else if (letterIn == 3'b110) 
                    SSD3 = 7'b1000111;
                else if (letterIn == 3'b111) 
                    SSD3 = 7'b1000001;
            end

            CODE_MAKER_INPUT_2: begin
                SSD3 = 7'b0111111;
                if (letterIn == 3'b001) 
                    SSD2 = 7'b0001000;
                else if (letterIn == 3'b010) 
                    SSD2 = 7'b1000110;
                else if (letterIn == 3'b011) 
                    SSD2 = 7'b0000110;
                else if (letterIn == 3'b100) 
                    SSD2 = 7'b0001110;
                else if (letterIn == 3'b101) 
                    SSD2 = 7'b0001001;
                else if (letterIn == 3'b110) 
                    SSD2 = 7'b1000111;
                else if (letterIn == 3'b111) 
                    SSD2 = 7'b1000001;
            end

            CODE_MAKER_INPUT_3: begin
                SSD3 = 7'b0111111;
                SSD2 = 7'b0111111;
                if (letterIn == 3'b001) 
                    SSD1 = 7'b0001000;
                else if (letterIn == 3'b010) 
                    SSD1 = 7'b1000110;
                else if (letterIn == 3'b011) 
                    SSD1 = 7'b0000110;
                else if (letterIn == 3'b100) 
                    SSD1 = 7'b0001110;
                else if (letterIn == 3'b101) 
                    SSD1 = 7'b0001001;
                else if (letterIn == 3'b110) 
                    SSD1 = 7'b1000111;
                else if (letterIn == 3'b111) 
                    SSD1 = 7'b1000001;
            end

            CODE_MAKER_INPUT_4: begin
                SSD3 = 7'b0111111;
                SSD2 = 7'b0111111;
                SSD1 = 7'b0111111;
                if (letterIn == 3'b001) 
                    SSD0 = 7'b0001000;
                else if (letterIn == 3'b010) 
                    SSD0 = 7'b1000110;
                else if (letterIn == 3'b011) 
                    SSD0 = 7'b0000110;
                else if (letterIn == 3'b100) 
                    SSD0 = 7'b0001110;
                else if (letterIn == 3'b101) 
                    SSD0 = 7'b0001001;
                else if (letterIn == 3'b110) 
                    SSD0 = 7'b1000111;
                else if (letterIn == 3'b111) 
                    SSD0 = 7'b1000001;
            end

            SHOW_BREAKER_LIVES: begin
                if (waitCounter<8'd100) begin
                    SSD2 = 7'b1000111; // L
                    SSD1 = 7'b0111111; // -
                    if (lives == 3) SSD0 = 7'b0110000;
                    else if (lives == 2) SSD0 = 7'b0100100;
                    else SSD0 = 7'b1111001;
                end
            end

            CODE_BREAKER_INPUT_1: begin
                if (letterIn == 3'b001) 
                    SSD3 = 7'b0001000;
                else if (letterIn == 3'b010) 
                    SSD3 = 7'b1000110;
                else if (letterIn == 3'b011) 
                    SSD3 = 7'b0000110;
                else if (letterIn == 3'b100) 
                    SSD3 = 7'b0001110;
                else if (letterIn == 3'b101) 
                    SSD3 = 7'b0001001;
                else if (letterIn == 3'b110) 
                    SSD3 = 7'b1000111;
                else if (letterIn == 3'b111) 
                    SSD3 = 7'b1000001;
            end

            CODE_BREAKER_INPUT_2: begin
                case (guess[3])
                    3'b001: SSD3 = 7'b0001000;
                    3'b010: SSD3 = 7'b1000110;
                    3'b011: SSD3 = 7'b0000110;
                    3'b100: SSD3 = 7'b0001110;
                    3'b101: SSD3 = 7'b0001001;
                    3'b110: SSD3 = 7'b1000111;
                    3'b111: SSD3 = 7'b1000001;
                endcase
                if (letterIn == 3'b001) 
                    SSD2 = 7'b0001000;
                else if (letterIn == 3'b010) 
                    SSD2 = 7'b1000110;
                else if (letterIn == 3'b011) 
                    SSD2 = 7'b0000110;
                else if (letterIn == 3'b100) 
                    SSD2 = 7'b0001110;
                else if (letterIn == 3'b101) 
                    SSD2 = 7'b0001001;
                else if (letterIn == 3'b110) 
                    SSD2 = 7'b1000111;
                else if (letterIn == 3'b111) 
                    SSD2 = 7'b1000001;
            end

            CODE_BREAKER_INPUT_3: begin
                case (guess[3])
                    3'b001: SSD3 = 7'b0001000;
                    3'b010: SSD3 = 7'b1000110;
                    3'b011: SSD3 = 7'b0000110;
                    3'b100: SSD3 = 7'b0001110;
                    3'b101: SSD3 = 7'b0001001;
                    3'b110: SSD3 = 7'b1000111;
                    3'b111: SSD3 = 7'b1000001;
                endcase
                case (guess[2])
                    3'b001: SSD2 = 7'b0001000;
                    3'b010: SSD2 = 7'b1000110;
                    3'b011: SSD2 = 7'b0000110;
                    3'b100: SSD2 = 7'b0001110;
                    3'b101: SSD2 = 7'b0001001;
                    3'b110: SSD2 = 7'b1000111;
                    3'b111: SSD2 = 7'b1000001;
                endcase
                if (letterIn == 3'b001) 
                    SSD1 = 7'b0001000;
                else if (letterIn == 3'b010) 
                    SSD1 = 7'b1000110;
                else if (letterIn == 3'b011) 
                    SSD1 = 7'b0000110;
                else if (letterIn == 3'b100) 
                    SSD1 = 7'b0001110;
                else if (letterIn == 3'b101) 
                    SSD1 = 7'b0001001;
                else if (letterIn == 3'b110) 
                    SSD1 = 7'b1000111;
                else if (letterIn == 3'b111) 
                    SSD1 = 7'b1000001;
            end
            CODE_BREAKER_INPUT_4: begin
                case (guess[3])
                    3'b001: SSD3 = 7'b0001000;
                    3'b010: SSD3 = 7'b1000110;
                    3'b011: SSD3 = 7'b0000110;
                    3'b100: SSD3 = 7'b0001110;
                    3'b101: SSD3 = 7'b0001001;
                    3'b110: SSD3 = 7'b1000111;
                    3'b111: SSD3 = 7'b1000001;
                endcase
                case (guess[2])
                    3'b001: SSD2 = 7'b0001000;
                    3'b010: SSD2 = 7'b1000110;
                    3'b011: SSD2 = 7'b0000110;
                    3'b100: SSD2 = 7'b0001110;
                    3'b101: SSD2 = 7'b0001001;
                    3'b110: SSD2 = 7'b1000111;
                    3'b111: SSD2 = 7'b1000001;
                endcase
                case (guess[1])
                    3'b001: SSD1 = 7'b0001000;
                    3'b010: SSD1 = 7'b1000110;
                    3'b011: SSD1 = 7'b0000110;
                    3'b100: SSD1 = 7'b0001110;
                    3'b101: SSD1 = 7'b0001001;
                    3'b110: SSD1 = 7'b1000111;
                    3'b111: SSD1 = 7'b1000001;
                endcase
                if (letterIn == 3'b001) 
                    SSD0 = 7'b0001000;
                else if (letterIn == 3'b010) 
                    SSD0 = 7'b1000110;
                else if (letterIn == 3'b011) 
                    SSD0 = 7'b0000110;
                else if (letterIn == 3'b100) 
                    SSD0 = 7'b0001110;
                else if (letterIn == 3'b101) 
                    SSD0 = 7'b0001001;
                else if (letterIn == 3'b110) 
                    SSD0 = 7'b1000111;
                else if (letterIn == 3'b111) 
                    SSD0 = 7'b1000001;
            end
            CHECK_CODE,
            WAIT_NEXT: begin
                // 4th letter -> LEDX[7:6]
                if (guess[3] == code[3]) begin
                    LEDX[7:6] = 2'b11;
                end
                else if (guess[3] == code[2] || guess[3] == code[1] || guess[3] == code[0]) begin
                    LEDX[7:6] = 2'b01;
                end
                else begin
                    LEDX[7:6] = 2'b00;
                end

                // 3rd letter -> LEDX[5:4]
                if (guess[2] == code[2]) begin
                    LEDX[5:4] = 2'b11;
                end
                else if (guess[2] == code[3] || guess[2] == code[1] || guess[2] == code[0]) begin
                    LEDX[5:4] = 2'b01;
                end
                else begin
                    LEDX[5:4] = 2'b00;
                end

                // 2nd letter -> LEDX[3:2]
                if (guess[1] == code[1]) begin
                    LEDX[3:2] = 2'b11;
                end
                else if (guess[1] == code[3] || guess[1] == code[2] || guess[1] == code[0]) begin
                    LEDX[3:2] = 2'b01;
                end
                else begin
                    LEDX[3:2] = 2'b00;
                end

                // 1st letter -> LEDX[1:0]
                if (guess[0] == code[0]) begin
                    LEDX[1:0] = 2'b11;
                end
                else if (guess[0] == code[3] || guess[0] == code[2] || guess[0] == code[1]) begin
                    LEDX[1:0] = 2'b01;
                end
                else begin
                    LEDX[1:0] = 2'b00;
                end
            end

            SHOW_CORRECT: begin
                if (code[3] == 3'b001) 
                    SSD3 = 7'b0001000;
                else if (code[3] == 3'b010) 
                    SSD3 = 7'b1000110;
                else if (code[3] == 3'b011) 
                    SSD3 = 7'b0000110;
                else if (code[3] == 3'b100) 
                    SSD3 = 7'b0001110;
                else if (code[3] == 3'b101) 
                    SSD3 = 7'b0001001;
                else if (code[3] == 3'b110) 
                    SSD3 = 7'b1000111;
                else 
                    SSD3 = 7'b1000001;

                if (code[2] == 3'b001) 
                    SSD2 = 7'b0001000;
                else if (code[2] == 3'b010) 
                    SSD2 = 7'b1000110;
                else if (code[2] == 3'b011) 
                    SSD2 = 7'b0000110;
                else if (code[2] == 3'b100) 
                    SSD2 = 7'b0001110;
                else if (code[2] == 3'b101) 
                    SSD2 = 7'b0001001;
                else if (code[2] == 3'b110) 
                    SSD2 = 7'b1000111;
                else SSD2 = 7'b1000001;

                if (code[1] == 3'b001) 
                    SSD1 = 7'b0001000;
                else if (code[1] == 3'b010) 
                    SSD1 = 7'b1000110;
                else if (code[1] == 3'b011) 
                    SSD1 = 7'b0000110;
                else if (code[1] == 3'b100) 
                    SSD1 = 7'b0001110;
                else if (code[1] == 3'b101) 
                    SSD1 = 7'b0001001;
                else if (code[1] == 3'b110) 
                    SSD1 = 7'b1000111;
                else 
                    SSD1 = 7'b1000001;

                if (code[0] == 3'b001) SSD0 = 7'b0001000;
                else if (code[0] == 3'b010) SSD0 = 7'b1000110;
                else if (code[0] == 3'b011) SSD0 = 7'b0000110;
                else if (code[0] == 3'b100) SSD0 = 7'b0001110;
                else if (code[0] == 3'b101) SSD0 = 7'b0001001;
                else if (code[0] == 3'b110) SSD0 = 7'b1000111;
                else SSD0 = 7'b1000001;
            end

            END_ROUND: begin
                if (waitCounter<8'd100) begin
                    SSD1 = 7'b0111111; // -
                    if (scoreA == 0) SSD2 = 7'b1000000;
                    else if (scoreA == 1) SSD2 = 7'b1111001;
                    else SSD2 = 7'b0100100;

                    if (scoreB == 0) 
                        SSD0 = 7'b1000000;
                    else if (scoreB == 1) 
                        SSD0 = 7'b1111001;
                    else 
                        SSD0 = 7'b0100100;
                end
                if ((scoreA == 4'd2) || (scoreB == 4'd2)) 
                begin
                    if (waitCounter[3])
                        LEDX = 8'b11111111;
                    else
                        LEDX = 8'b00000000;
                end
                else begin
                    LEDX = 8'b00000000;
                end
            end
        endcase
    end
endmodule