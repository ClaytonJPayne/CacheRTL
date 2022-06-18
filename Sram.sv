`ifndef SRAM
`define SRAM

module Sram 
    #(
        parameter WIDTH = 8,
        parameter DEPTH = 512
    ) 
(
    input logic [DEPTH-1:0]             WordLine,
    inout logic [DEPTH-1:0][WIDTH-1:0]  BitLine
);

    logic [WIDTH-1:0][DEPTH-1:0] Data;

    for (genvar i=0; i<DEPTH; i++) begin : GenSramArray
        assign BitLine[i] = WordLine[i] ? Data[i] : 'Z;
        always_latch begin
            if (WordLine[i]) Data[i] = BitLine[i];
        end
    end
    
endmodule : Sram

`endif // SRAM
