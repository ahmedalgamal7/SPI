module wrapper_tb ();
reg MOSI,SS_n,clk,rst_n;
wire MISO;
wrapper DUT (MOSI,MISO,SS_n,clk,rst_n);
initial begin
    clk=0;
    forever begin
        #2; clk=~clk;
    end
end
initial begin
$readmemh("mem.dat",DUT.memory.mem,255,0);
rst_n=0;           //IDLE case
repeat(3) @(negedge clk);
rst_n=1; SS_n=0;
@(negedge clk);   //CHK_CMD case
MOSI=0; @(negedge clk); //from CHK_CMD to WRITE   
MOSI=0; @(negedge clk); MOSI=0; @(negedge clk); MOSI=0; @(negedge clk); MOSI=1; @(negedge clk); MOSI=1; @(negedge clk); MOSI=0; @(negedge clk); MOSI=0; @(negedge clk);
MOSI=1; @(negedge clk); MOSI=0; @(negedge clk); MOSI=0; @(negedge clk); MOSI=1; repeat(3) @(negedge clk);
SS_n=1; @(negedge clk); //from WRITE to IDLE
SS_n=0; @(negedge clk); //from IDLE to CHK_CMD
MOSI=0; @(negedge clk); //from CHK_CMD to WRITE
MOSI=0; @(negedge clk); MOSI=0; @(negedge clk); MOSI=1; @(negedge clk); MOSI=1; @(negedge clk); MOSI=1; @(negedge clk); MOSI=0; @(negedge clk); MOSI=0; @(negedge clk);
MOSI=1; @(negedge clk); MOSI=0; @(negedge clk); MOSI=0; @(negedge clk); MOSI=1; repeat(3) @(negedge clk);
SS_n=1; @(negedge clk); //from WRITE to IDLE
SS_n=0; @(negedge clk); //from IDLE to CHK_CMD
MOSI=1; @(negedge clk); //from CHK_CMD to READ_ADD
MOSI=1; @(negedge clk); MOSI=1; @(negedge clk); MOSI=0; @(negedge clk); MOSI=0; @(negedge clk); MOSI=0; @(negedge clk); MOSI=0; @(negedge clk); MOSI=1; @(negedge clk);
MOSI=1; @(negedge clk); MOSI=0; @(negedge clk); MOSI=1; @(negedge clk); MOSI=1; repeat(3) @(negedge clk); 
SS_n=1; @(negedge clk); //from READ_ADD to IDLE
SS_n=0; @(negedge clk); //from IDLE to CHK_CMD
MOSI=1; @(negedge clk); //from CHK_CMD to READ_DATA
MOSI=1; @(negedge clk); MOSI=1; @(negedge clk); MOSI=1; @(negedge clk); MOSI=0; @(negedge clk); MOSI=0; @(negedge clk); MOSI=0; @(negedge clk); MOSI=1; @(negedge clk);
MOSI=1; @(negedge clk); MOSI=0; @(negedge clk); MOSI=1; @(negedge clk); MOSI=1; repeat(3) @(negedge clk);
repeat(8) @(negedge clk);
SS_n=1; @(negedge clk); //from READ_DATA to IDLE
$stop;       
end
endmodule