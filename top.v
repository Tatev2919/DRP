module top (clk,rst_n,control_tgt);
	input reg clk,rst_n,control_tgt;
	reg [2:0] state,next_state;
	reg control_tgt1;

	localparam IDLE = 3'b0,
		   S1 = 3'b1,
		   S2 = 3'b10,
		   S3 = 3'b11,
		   S4 = 3'b100;

	reg DEN,DWE;
	reg [5:0] DADDR;
	reg [3:0] DI;
	wire DRDY;
	wire [3:0] DO;
	
	reg [3:0] doubled_val;

	reg over;

	always @(posedge clk or negedge rst_n) begin 
		if (!rst_n) begin 
			control_tgt1 <= 0;
			state <= IDLE;
		end
		else begin  
			control_tgt1 <= control_tgt;
			state <= next_state;
		end
	end

		

	always @(posedge clk) begin 
		case (state) 
			IDLE:
				over <= 1'b1;
				if (control_tgt !== control_tgt1) begin 
					DADDR <= 6'h0x10;
					next_state <= state;
				end
				else begin 
					DEN <= 1'b1;
					next_state <= S1;
				end	
			S1:
				if (DEN) begin 
					DEN <= 1'b0;
					next_state <= S2;
				end
				else begin 
					next_state <= state;
				end
			S2: 
				if (DRDY) begin 
					DWE <= 1'b1;
					next_state <= S3;
				end
				else begin 
					next_state <= state;
				end
			S3: 
				if (DWE) begin 
					DI  <= 4'hA;
					DWE <= 1'b0;
					next_state <= S2;
				end
				else begin  
					next_state <= state;
				end
			S4: 
				if (DRDY) begin 
					next_state <= IDLE;
				end
				else begin  
					next_state <= state;
				end
			default:
				next_state <= S1;
					
		endcase
	end

endmodule
