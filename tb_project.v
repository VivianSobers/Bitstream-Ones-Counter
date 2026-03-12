module tb_project;
    reg clk;
    reg rst;
    reg load;
    reg shift;
    reg [14:0] data;
    wire [3:0] count;

    project M1(clk, rst, load, shift, data, count);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst=1;
        load=0;
        shift=0;
        data=15'b0;

        #12;
        rst=0;

        data=15'b101011101011101;
        load=1;
        #10;
        load=0;
        #10;
        shift=1;

        repeat(15) begin
            #10;
        end
        shift=0;
        #20;
        $finish;
    end
    initial begin
        $monitor("Time=%0t | shift=%b | sout=%b | count=%b", $time, shift, M1.sr.sout, count);
    end

    initial begin
        $dumpfile("project.vcd");   
        $dumpvars(0, tb_project);    
    end

endmodule
