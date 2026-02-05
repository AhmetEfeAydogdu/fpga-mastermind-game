module top_module(
    input clk,
    input  [3:0] btn,   // btn[3]=A, btn[0]=B, btn[2]=Reset
    input  [3:0] sw,    // sw[2:0] = letterIn

    output [7:0] led,
    output [7:0] seven,
    output [3:0] segment
);
    wire rst_mastermind = btn[2]; 
    wire rst_debouncer = ~btn[2]; 
    wire btnA_inverted = ~btn[3];
    wire btnB_inverted = ~btn[0];
    
    wire [2:0] letterIn = sw[2:0];

    wire clk_div;
    clk_divider clk_div_inst (
        .clk_in(clk),
        .divided_clk(clk_div)
    );

    wire enterA_clean;
    wire enterB_clean;

    debouncer dbA (
        .clk(clk_div),
        .rst(rst_debouncer),
        .noisy_in(btnA_inverted),
        .clean_out(enterA_clean)
    );

    debouncer dbB (
        .clk(clk_div),
        .rst(rst_debouncer),
        .noisy_in(btnB_inverted),
        .clean_out(enterB_clean)
    );

    wire [7:0] LEDX;
    wire [6:0] SSD3, SSD2, SSD1, SSD0;

    mastermind mm (
        .clk(clk_div),
        .rst(rst_mastermind),
        .enterA(enterA_clean),
        .enterB(enterB_clean),
        .letterIn(letterIn),
        .LEDX(LEDX),
        .SSD3(SSD3),
        .SSD2(SSD2),
        .SSD1(SSD1),
        .SSD0(SSD0)
    );

    assign led = LEDX;

    ssd ssd_inst (
        .clk(clk),
        .disp0({1'b0, ~SSD0}), 
        .disp1({1'b0, ~SSD1}),
        .disp2({1'b0, ~SSD2}),
        .disp3({1'b0, ~SSD3}),
        .seven(seven),
        .segment(segment)
    );

endmodule