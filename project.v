module tff(
    input wire clk,
    input wire t,
    input wire rst,
    output reg q
);
    always @(posedge clk or posedge rst) begin
        if(rst)
            q <= 1'b0;
        else if(t)
            q <= ~q;
    end
endmodule

module shift_reg(
    input wire clk,
    input wire rst,
    input wire load,
    input wire [14:0] data,
    input wire shift,
    output wire sout
);
    reg [14:0] r;
    always @(posedge clk) begin
        if(rst)
            r <= 15'b0;
        else if(load)
            r <= data;
        else if(shift)
            r <= {1'b0,r[14:1]};
    end
    assign sout = r[0];
endmodule

module counter(
    input wire clk,
    input wire rst,
    input wire en,
    output wire [3:0] q 
);
    wire t0, t1, t2, t3;
    wire q0, q1, q2, q3;

    assign t0 = en;
    assign t1 = q0 & en;
    assign t2 = q0 & q1 & en;
    assign t3 = q0 & q1 & q2 & en;

    tff ff0(clk, t0, rst, q0);
    tff ff1(clk, t1, rst, q1);
    tff ff2(clk, t2, rst, q2);
    tff ff3(clk, t3, rst, q3);

    assign q = {q3, q2, q1, q0};
endmodule

module project(
    input wire clk,
    input wire rst,
    input wire load,
    input wire shift,
    input wire [14:0] data,
    output wire [3:0] count
);
    wire sout;
    wire en;

    shift_reg sr(clk, rst, load, data, shift, sout);

    assign en = shift & sout;  

    counter cnt(clk, rst, en, count);
endmodule