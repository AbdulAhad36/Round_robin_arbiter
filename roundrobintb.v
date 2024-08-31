module roundrobintb;
  reg clk;
  reg rst_n;
  reg [3:0] REQ;
  wire [3:0] GNT;
  
  //Instantiate Design Under Test
  
  roundrobin_fixedtimeslice DUT(.clk(clk), .rst_n(rst_n), .REQ(REQ), .GNT(GNT));
  
  //Generate a 10 ns  Time Period Clock 
  always #5 clk = ~clk;
  
  //Drive the DUT or Generate stimuli for the DUT
  
  initial begin
    clk = 0;
    rst_n = 1;
    REQ = 4'b0;
    // Assert the Asynchronous Reset after 1 clock period 
    #10 rst_n = 0;
    //Deassert the Reset
    #5 rst_n = 1;
    
    @(negedge clk) REQ = 4'b0010;	//REQ[1] 
    @(negedge clk) REQ = 4'b1110;	//REQ[2]
    @(negedge clk) REQ = 4'b0010;	//REQ[1]   
    @(negedge clk) REQ = 4'b1010;    	//REQ[3]
    @(negedge clk) REQ = 4'b0100;   	//REQ[2]
    @(negedge clk) REQ = 4'b1111;    	//REQ[3]
    @(negedge clk) REQ = 4'b0110;   	//REQ[1]
    @(negedge clk) REQ = 4'b1000;       //REQ[3]  
    @(negedge clk) REQ = 4'b0010;    	//REQ[1]
    @(negedge clk) REQ = 4'b1010;    	//REQ[3]
    @(negedge clk) REQ = 4'b0100;     	//REQ[2]
    #5 rst_n = 0;
    
  end   
endmodule
    
    
  
