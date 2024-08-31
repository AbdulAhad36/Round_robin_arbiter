// Define the traffic light controller module
module traffic_control_ (clk,reset,maint,Ga,Ya,Ra,Gb,Yb,Rb,Gw,Rw);
    input clk, reset, maint;
    output reg Ga,Ya,Ra,Gb,Yb,Rb,Gw,Rw;

reg [8:0]state_count;
reg [2:0]i=0; 
wire clk_baud;

//Define the states for the traffic light sequence

parameter GA_RB_RW = 3'd0; // Green for A, Red for B and W
parameter YA_RB_RW = 3'd1; // Yellow for A, Red for B and W
parameter RA_GB_RW = 3'd2; // Red for A, Green for B, Red for W
parameter RA_YB_RW = 3'd3; // Red for A, Yellow for B, Red for W
parameter RA_RB_GW = 3'd4; // Red for A and B, Green for W
parameter RA_RB_RW = 3'd5; // Red for A and B, Red for W


parameter rw_max= 'd136;		
parameter flash='d68;
parameter solid = 'd10;
// Instantiate the clock divider
clock_divider cd(clk , reset, state_count,clk_baud);

// Declare the variables for the state machine
reg [2:0] state=0; // Current state
reg [2:0] next_state=0; // Next state

always @ (posedge clk) begin
    case (state)
        GA_RB_RW: begin
            // Set the lights for this state
 	    state_count='d160;
            {Ra,Ya,Ga} = 3'b001; // Green
            {Rb,Yb,Gb}= 3'b100; // Red
            {Rw,Gw}= 2'b10; // Red
            // Check the counter value      
                // Move to the next state
		if(i==1)
                next_state = 3'd1;
        end


        YA_RB_RW: begin
            // Set the lights for this state
 	    state_count='d160;
            {Ra,Ya,Ga} = 3'b010; // Green
            {Rb,Yb,Gb}= 3'b100; // Red
            {Rw,Gw}= 2'b10; // Red
            // Check the counter value   
		if(i==2)
                next_state = 3'd2;                  
        end
        RA_GB_RW: begin
            // Set the lights for this state
 	    state_count='d160;
            {Ra,Ya,Ga} = 3'b100; // Green
            {Rb,Yb,Gb}= 3'b001; // Red
            {Rw,Gw}= 2'b10; // Red
            // Check the counter value   
		if(i==3)
                next_state = 3'd3;                  
        end

        RA_YB_RW: begin
            // Set the lights for this state
 	    state_count='d160;
            {Ra,Ya,Ga} = 3'b100; // Green
            {Rb,Yb,Gb}= 3'b010; // Red
            {Rw,Gw}= 2'b10; // Red
            // Check the counter value   
		if(i==4)
                next_state = 3'd4;                  
        end

        RA_RB_GW: begin
            // Set the lights for this state
 	    state_count='d160;
            {Ra,Ya,Ga} = 3'b100; // Green
            {Rb,Yb,Gb}= 3'b100; // Red
            {Rw,Gw}= 2'b01; // Red
            // Check the counter value   
		if(i==5)
                next_state = 3'd5;                  
        end

       RA_RB_RW : begin
            // Set the lights for this state
 	    state_count='d80;
            {Ra,Ya,Ga} = 3'b100; // Green
            {Rb,Yb,Gb}= 3'b100; // Red
            Gw= 0; // Red
             Rw=~Rw;    
	// Check the counter value   
	    if(i==6)
		begin

 	    state_count= solid;
            {Ra,Ya,Ga} = 3'b100; //RA solid
	   state_count = flash;
            {Rb,Ya,Ga}= 3'b100; // Red
            {Rb,Yb,Gb}= 3'b100; // Red
              Gw=0;
		Rw=~Rw 	;  
		end
	if(i==6)
	begin
	state_count=solid;
          	 {Rb,Ya,Ga}= 3'b100; // Red
            	{Rb,Yb,Gb}= 3'b100;
		{Rw,Gw}=2'b10;
        end
	
	if(i==0) begin
		next_state=3'b0;
	end
	end
endcase
end

//MAINTENANCE MODE
always @ (posedge clk) begin
if (reset | maint)
begin
next_state=0;
state=0;
i=0;
Ra<=~Ra;
Rb<=~Rb;
Rw<=~Rw;
{Ya,Ga} = 2'b00; // Green
{Yb,Gb}= 2'b00; // Red
Gw= 0;
end

else
state = next_state;
end

//TRANSITION ON BASISI OF BAUD_OUNT OF CLOCK DIVIDER
always @(clk_baud)
begin
if(clk_baud)
begin
i=i+1;
if(i==7)
i=0;
end
end
endmodule

module clock_divider (
	input  clk ,
	input  reset,
	input [8:0] state_duration,
	output clk_baud
);
	
	reg [8:0] count = 0;
	
	always @(posedge clk ) 
	begin
		if(reset == 1'b1) begin
			count <= 0;
		end
		else if(count>=state_duration) begin 			
			count <= 0;
		end
		else begin
			count <= count + 1  ;
		end
		
	end
	assign clk_baud= count == state_duration;

	
	
endmodule
