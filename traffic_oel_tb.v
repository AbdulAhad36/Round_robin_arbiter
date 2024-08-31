module traffic_oel_tb;
reg clk, reset, maint;
wire Ga,Ya,Ra,Gb,Yb,Rb,Gw,Rw;
traffic_control_ to(clk,reset,maint,Ga,Ya,Ra,Gb,Yb,Rb,Gw,Rw);
always begin #10 clk=~clk; end
initial begin
clk=0; reset=1; maint=0;
#50 
reset=0;
#3900
maint=1;
#900
maint=0;
end
endmodule