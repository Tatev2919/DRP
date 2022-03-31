`timescale 1 ns/1 ps
module tb; 
reg clk,rst_n,control_tgt;		

top t (clk,rst_n,control_tgt);

initial begin 
	clk = 1'b0;
	control_tgt = 1'b0;
	rst_n = 1'b0;
	#15;
	rst_n = 1'b1;
	@(posedge clk) control_tgt = 1'b1;
	wait(t.over);
	@(posedge clk) control_tgt = 1'b1;
	$finish;	
end

always #10 clk = ~clk;

endmodule;
