module VerySimpleCPU(clk, rst, data_fromRAM, wrEn, addr_toRAM, data_toRAM);
	parameter SIZE = 14;
	input clk, rst;
	input wire [31:0] data_fromRAM;
	output reg wrEn;
	output reg [SIZE-1:0] addr_toRAM;
	output reg [31:0] data_toRAM;
	reg [3:0] state_current, state_next;
  reg [31:0] pc_current, pc_next,iw_current, iw_next, r1_current, r1_next;
  	always @(posedge clk) begin
    	state_current  <= state_next;
			pc_current  <= pc_next;
			iw_current  <= iw_next;
			r1_current  <= r1_next;
  	end
  always @* begin
    if (rst) begin
      pc_next = 0;
      state_next = 3'h0;
     end
     else begin
       addr_toRAM = 14'hxxxx;
       data_toRAM = 32'hxxxxxxxx;
       wrEn=1'b0;
       pc_next = pc_current;
       iw_next = iw_current;
       r1_next = r1_current;
       case (state_current) 
         3'h0: begin
         	addr_toRAM = pc_current;
        	wrEn = 1'b0;
           	state_next = 3'h1; 
         end
         3'h1:begin
           iw_next = data_fromRAM;
			case(data_fromRAM [31:28])
				{3'b000 ,1'b0}: begin // ADD
					addr_toRAM = data_fromRAM [27:14];
					state_next = 2;
				end
				{3'b000 ,1'b1}: begin // ADDi
                  wrEn=0;
					addr_toRAM = data_fromRAM [27:14];
					iw_next = data_fromRAM;
					r1_next = data_fromRAM[13:0];
					state_next = 3;
				end
				{3'b001 ,1'b0}: begin // NAND
					addr_toRAM = data_fromRAM [27:14];
					iw_next = data_fromRAM;
					state_next = 2;
				end
				{3'b001 ,1'b1}: begin // NANDi
					addr_toRAM = data_fromRAM [27:14];
					iw_next = data_fromRAM;
					state_next = 3;
				end
				{3'b010 ,1'b0}: begin // SRL
					addr_toRAM = data_fromRAM [27:14];
					iw_next = data_fromRAM;
					state_next = 2;
				end
				{3'b010 ,1'b1}: begin // SRLi
					addr_toRAM = data_fromRAM [27:14];
					iw_next = data_fromRAM;
					state_next = 3;
				end			
				{3'b011 ,1'b0}: begin // LT
					addr_toRAM = data_fromRAM [27:14];
					iw_next = data_fromRAM;
					state_next = 2;
				end
				{3'b011 ,1'b1}: begin // LTi
					addr_toRAM = data_fromRAM [27:14];
					iw_next = data_fromRAM;
					state_next = 3;
				end
				{3'b111 ,1'b0}: begin // MUL
					addr_toRAM = data_fromRAM [27:14];
					iw_next = data_fromRAM;
					state_next = 2;
				end
				{3'b111 ,1'b1}: begin // MULi
					addr_toRAM = data_fromRAM [27:14];
					iw_next = data_fromRAM;
					state_next = 3;
				end
				{3'b100 ,1'b0}: begin // CP
					addr_toRAM = data_fromRAM [13:0];
					iw_next = data_fromRAM;
					state_next = 2;
				end
				{3'b100 ,1'b1}: begin // CPi
					addr_toRAM = data_fromRAM [13:0];
					iw_next = data_fromRAM;
					state_next = 3;
				end
				{3'b101 ,1'b0}: begin // CPI
					addr_toRAM = data_fromRAM [13:0];
					iw_next = data_fromRAM;
					state_next = 2;
				end					
				{3'b101 ,1'b1}: begin // CPIi
					addr_toRAM = data_fromRAM [27:14];
					iw_next = data_fromRAM;
					state_next = 2;
				end	
				{3'b110 ,1'b0}: begin // BZJ
					addr_toRAM = data_fromRAM [27:14];
					iw_next = data_fromRAM;
					state_next = 2;
				end	
				{3'b110 ,1'b1}: begin // BZJi
					addr_toRAM = data_fromRAM [27:14];
					iw_next = data_fromRAM;
					state_next = 3;
				end	
				default: begin
					pc_next = pc_current;
					state_next = 0;
				end
			endcase
		end
         3'h2: begin
           if (iw_current[31:28] == 4'b1010) begin //CPI

				addr_toRAM = data_fromRAM [13:0];
				state_next = 3;
			end
			else if(iw_current[31:28] == 4'b1011) begin //CPIi
				
				r1_next = data_fromRAM[13:0];
				addr_toRAM = iw_current[13:0];
				state_next = 3;
			end
			else begin
				r1_next = data_fromRAM;
				addr_toRAM = iw_current [13:0];
				state_next = 3;
			end
         end
         3'h3: begin
           case(iw_current [31:28])
				{3'b000 ,1'b0}: begin // ADD
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = data_fromRAM + r1_current;
					pc_next = pc_current + 1'b1;
					state_next = 0;
				end
				{3'b000,1'b1}: begin // ADDi
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = r1_current + data_fromRAM;
					pc_next = pc_current + 1'b1;
					state_next = 0;
				end
				{3'b001,1'b0}: begin // NAND
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = ~(data_fromRAM & r1_current);
					pc_next = pc_current + 1'b1;
					state_next = 0;
				end
				{3'b001,1'b1}: begin // NANDi
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = ~(data_fromRAM[13:0] & iw_current[13:0]);
					pc_next = pc_current + 1'b1;
					state_next = 0;
				end
				{3'b010,1'b0}: begin // SRL
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = (data_fromRAM < 32) ?  (r1_current >> data_fromRAM) : (r1_current << (data_fromRAM - 32)) ;
					pc_next = pc_current + 1'b1;
					state_next = 0;
				end
				{3'b010,1'b1}: begin // SRLi
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = (iw_current[13:0] < 32) ?  (data_fromRAM[13:0] >> iw_current[13:0]) : (r1_current << (iw_current[13:0] - 32)) ;
					pc_next = pc_current + 1'b1;
					state_next = 0;
				end
				{3'b011,1'b0}: begin // LT
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = (r1_current < data_fromRAM) ? 1 : 0;
					pc_next = pc_current + 1'b1;
					state_next = 0;
				end
				{3'b011,1'b1}: begin // LTi
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = (data_fromRAM[13:0] < iw_current[13:0]) ? 1 : 0;
					pc_next = pc_current + 1'b1;
					state_next = 0;
				end
				{3'b111 ,1'b0}: begin // MUL
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = data_fromRAM * r1_current;
					pc_next = pc_current + 1'b1;
					state_next = 0;
				end
				{3'b111,1'b1}: begin // MULi
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = data_fromRAM[13:0] * iw_current[13:0];
					pc_next = pc_current + 1'b1;
					state_next = 0;
				end				
				{3'b100 ,1'b0}: begin // CP
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = r1_current;
					pc_next = pc_current + 1'b1;
					state_next = 0;
				end
				{3'b100 ,1'b1}: begin // CPi
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = iw_current[13:0];
					pc_next = pc_current + 1'b1;
					state_next = 0;
				end
				{3'b101 ,1'b0}: begin // CPI
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = data_fromRAM;
					pc_next = pc_current + 1'b1;
					state_next = 0;
				end	
				{3'b101 ,1'b1}: begin // CPIi
					wrEn = 1;
					addr_toRAM = r1_current[13:0];
					data_toRAM = data_fromRAM;
					pc_next = pc_current + 1'b1;
					state_next = 0;
				end	
				{3'b110 ,1'b0}: begin // BZJ
					wrEn = 1;
					pc_next = (data_fromRAM == 0) ? (r1_current) : (pc_next + 1);
					state_next = 0;
				end	
				{3'b110 ,1'b1}: begin // BZJi
					wrEn = 1;
					pc_next = data_fromRAM[13:0] + iw_current[13:0];
					state_next = 0;
				end							
			endcase
         end
        endcase
     end
  end
endmodule
