module ram (din,rx_valid,clk,rst_n,dout,tx_valid);
parameter MEM_DEPTH=256;
parameter ADDR_SIZE=8;
input [9:0] din;
input rx_valid,clk,rst_n;
output reg [ADDR_SIZE-1:0] dout;
output reg tx_valid;
reg [ADDR_SIZE-1:0] temp_address;                                  //temporary variable for storing read/write address
reg [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];                           //memory declaration
always @(posedge clk) begin
    if(!rst_n) begin
         dout<=0; tx_valid<=0;
    end
    else begin
     if (rx_valid) begin
if (din [9:8]==0)
temp_address<=din[7:0] ;
if (din [9:8]==1)
mem[temp_address]<=din[7:0] ;
if (din [9:8]==2)
temp_address<=din[7:0] ;
end
else begin
if (din [9:8]==3) begin
dout<=mem[temp_address];
tx_valid<=1;
end
end
end
       /* if(rx_valid) begin 
        case (din[9:8])
            //write operation            
            2'b00: temp_address<=din[7:0];
            2'b01: mem[temp_address]<=din[7:0];
            //read operation
            2'b10: temp_address<=din[7:0];
            2'b11: begin
                tx_valid<=1;
                dout<=mem[temp_address];
            end
        endcase
        end */
    end
endmodule