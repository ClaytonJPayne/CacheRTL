`ifndef CACHE_PARAMS
`define CACHE_PARAMS

package CacheParams;
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 8,
    parameter SIZE = 1024,
    parameter LINE_SIZE = 256,
    parameter NUM_LINES = SIZE / LINE_SIZE,
    parameter IDX_BITS = $clog2(NUM_LINES),
    parameter OFFSET_BITS = $clog2(LINE_SIZE)
    parameter TAG_BITS = ADDR_BITS - (IDX_BITS + OFFSET_BITS)
endpackage : CacheParams

`endif // CACHE_PARAMS