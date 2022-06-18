`ifndef SRAM_BANK
`define SRAM_BANK

module SramBank 
    #(
        parameter WIDTH = 8,
        parameter DEPTH = 512,
        parameter ADDR_BITS = $clog2(DEPTH)
    ) 
(
    input  logic [ADDR_BITS-1:0]         Addr,
    input  logic [WIDTH-1:0]             WrData,
    input  logic                         WrEn,
    output logic [WIDTH-1:0]             RdData
);     

    logic [DEPTH-1:0]                    WordLine;
    logic [WIDTH-1:0]                    DataIn;
    logic [WIDTH-1:0]                    BitLine;

    assign BitLine = (WrEn == 1) ? WrData : 'Z;
    assign RdData  = BitLine;

    Decoder #(.WIDTH(ADDR_BITS)) AddrDecoder (
        .enc           (Addr       ),
        .dec           (WordLine   )
    );

    Sram #(.WIDTH(WIDTH), .DEPTH(DEPTH)) SramArray (
        .WordLine      (WordLine   ),
        .BitLine       (BitLine    )
    );

endmodule : SramBank

`endif // SRAM_BANK