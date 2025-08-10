module SPI_slave (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
parameter IDLE=3'b000;
parameter CHK_CMD=3'b001;
parameter WRITE=3'b011;
parameter READ_DATA=3'b111;
parameter READ_ADD=3'b110;
input MOSI,SS_n,clk,rst_n,tx_valid;
input [7:0] tx_data;
output reg MISO,rx_valid;
output reg [9:0] rx_data;
(*fsm_encoding="sequential"*)
reg [2:0] cs,ns;
reg temp; //internal signal
integer count_1,count_2;                  
reg [10:0] rx_data_temp;
//next state logic
always @(*) begin
    case (cs)
        IDLE: begin
            if(SS_n==1) ns=IDLE;
            else ns=CHK_CMD;
        end
        CHK_CMD: begin
            if(SS_n==1) ns=IDLE;
            else begin
          if( MOSI==0 ) ns=WRITE;
            else if( (MOSI==1)&&(temp==1)) ns=READ_DATA;
            else if((MOSI==1)&&(temp==0)) ns=READ_ADD; 
            end 
        end
        WRITE: begin
            if(SS_n) ns=IDLE;
            else ns=WRITE;
        end 
        READ_DATA: begin
            if(SS_n) ns=IDLE;
            else ns=READ_DATA;
        end
        READ_ADD: begin
            if(SS_n) ns=IDLE;
            else ns=READ_ADD;
        end
        default: ns=IDLE;
    endcase
end
//state memory
always @(posedge clk) begin
    if(!rst_n) cs<=IDLE;
    else cs<=ns;
end
//output logic
always @(posedge clk) begin
    if(!rst_n) begin
        rx_data<=0; rx_valid<=0; MISO<=0; rx_data_temp<=0; count_1<=0; count_2<=7; temp<=0;
    end
    else begin
        if(!SS_n) begin
        case (cs)
            IDLE: begin rx_data<=0; rx_valid<=0; MISO<=0; count_1<=0; rx_data_temp<=0; count_2<=7; end
            WRITE: begin
               if( (count_1==11) && ( (rx_data_temp[10:8]==3'b000) || (rx_data_temp[10:8]==3'b001) ) ) begin
                rx_data<=rx_data_temp[9:0]; rx_valid<=1; count_1<=0;
               end
               else begin
               rx_data_temp<={rx_data_temp,MOSI};
               count_1<=count_1+1'd1;
               end                
            end
            READ_ADD: begin
                if((count_1==11)&&(rx_data_temp[10:8]==3'b110)) begin
                rx_data<=rx_data_temp[9:0]; rx_valid<=1; count_1<=0; temp<=1;
               end
               else begin
               rx_data_temp<={rx_data_temp,MOSI};
               count_1<=count_1+1'd1;
               end                 
            end
            READ_DATA: begin
               if( (count_1==11)&&(rx_data_temp[10:8]==3'b111) ) begin
                rx_data<=rx_data_temp[9:0]; count_1<=0; 
               end
               else begin
               rx_data_temp<={rx_data_temp,MOSI};
               count_1<=count_1+1'd1;
               end
                if(tx_valid==1'b1) begin
                if(count_2==-1) begin temp<=0; count_2<=7; end
                else begin
                MISO<=tx_data[count_2];
                count_2<=count_2-1'd1;    
                end                      
                end
            end
            default: begin
                 rx_data<=0; rx_valid<=0; MISO<=0; count_1<=0; rx_data_temp<=0; count_2<=7;
            end 
        endcase
    end
    else begin
        rx_data<=0; rx_valid<=0; MISO<=0; count_1<=0; rx_data_temp<=0; count_2<=7;
    end
    end
end
endmodule