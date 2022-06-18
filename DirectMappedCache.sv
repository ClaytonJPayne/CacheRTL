`ifndef DIRECT_MAPPED_CACHE
`define DIRECT_MAPPED_CACHE

module DirectMappedCache 
import CacheParams::*;
(
    input  logic                             Rst,
    input  logic [ADDR_WIDTH-1:0]            Addr,
    input  logic                             AddrVal,
    input  logic [DATA_WIDTH-1:0]            WrData,
    input  logic                             ReplaceEn,
    input  logic                             WrEn,
    output logic [DATA_WIDTH-1:0]            RdData,
    output logic                             Hit,
    output logic                             Dirty
);

    logic [IDX_BITS-1:0]                     CacheIdx;
    logic [OFFSET_BITS-1:0]                  CacheAddr;
    logic                                    CacheDataWrEn;

    logic                                    ValidBitRdData;
    logic                                    ValidBitWrData;
    logic                                    ValidBitWrEn;

    logic                                    DirtyBitRdData;
    logic                                    DirtyBitWrData;
    logic                                    DirtyBitWrEn;

    logic [TAG_BITS-1:0]                     TagIn;
    logic [TAG_BITS-1:0]                     TagRdData;
    logic                                    TagWrEn;

    assign TagIn            = Addr[ADDR_WIDTH-1:IDX_BITS+OFFSET_BITS];
    assign CacheIdx         = Addr[IDX_BITS+OFFSET_BITS-1:OFFSET_BITS];
    assign CacheAddr        = Addr[IDX_BITS-1:0];
    
    assign CacheDataWrEn    = AddrVal && (ReplaceEn || WrEn);
    assign DirtyBitWrData   = WrEn;
    assign DirtyBitWrEn     = ~Rst && CacheDataWrEn;
    assign TagWrEn          = AddrVal && ReplaceEn;

    assign Hit              = AddrVal && ValidBitRdData && (TagIn == TagRdData);
    assign Dirty            = DirtyBitRdData;
    assign ValidBitWrData   = ~Rst && Hit;
    assign ValidBitWrEn     = Rst || (AddrVal && ~Hit);

    SramBank #(.WIDTH(1), .DEPTH(NUM_LINES)) 
    ValidBits (
        .Addr       (CacheIdx       ),
        .RdData     (ValidBitRdData ),
        .WrData     (ValidBitWrData ),
        .WrEn       (ValidBitWrEn   )
    );
    SramBank #(.WIDTH(1), .DEPTH(NUM_LINES)) 
    DirtyBits (
        .Addr       (CacheIdx       ),
        .RdData     (DirtyBitRdData ),
        .WrData     (DirtyBitWrData ),
        .WrEn       (DirtyBitWrEn   )
    );
    SramBank #(.WIDTH(TAG_BITS), .DEPTH(NUM_LINES)) 
    Tags (
        .Addr       (CacheIdx       ),
        .RdData     (TagRdData      ),
        .WrData     (TagIn          ),
        .WrEn       (TagWrEn        )
    );
    SramBank #(.WIDTH(DATA_WIDTH), .DEPTH(LINE_SIZE))
    Data (
        .Addr       (CacheAddr      ),
        .RdData     (RdData         ),
        .WrData     (WrData         ),
        .WrEn       (CacheDataWrEn  )
    );

endmodule : DirectMappedCache

`endif // DIRECT_MAPPED_CACHE