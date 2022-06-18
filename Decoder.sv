`ifndef DECODER
`define DECODER

module Decoder 
    #(
        parameter WIDTH = 8,
        parameter DEC_LINES = 2**WIDTH;
    ) 
(
    input   logic [WIDTH-1:0]     enc,
    output  logic [DEC_LINES-1:0] dec
);
    for (genvar i=0; i<DEC_LINES; i++) begin : GenDecode
        assign dec[i] = (enc == i) ? 1'b1 : 1'b0;
    end
endmodule : Decoder

`endif // DECODER