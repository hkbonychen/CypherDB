// module name
`define CNT_MODULE_NAME ref_delay_counter

// counter type = [BINARY, GRAY, LFSR]
`define CNT_TYPE_BINARY
//`define CNT_TYPE_GRAY
//`define CNT_TYPE_LFSR

// q as output
//`define CNT_Q
// for gray type counter optional binary output
//`define CNT_Q_BIN

// number of CNT bins
`define CNT_LENGTH 6

// clear
//`define CNT_CLEAR

// async reset
`define CNT_RESET_VALUE `CNT_LENGTH'h0

// set
//`define CNT_SET
`define CNT_SET_VALUE `CNT_LENGTH'h0

// wrap around creates shorter cycle than maximum length
`define CNT_WRAP
`define CNT_WRAP_VALUE `CNT_LENGTH'd12

// clock enable
`define CNT_CE

// q_next as an output
//`define CNT_QNEXT

// q=0 as an output
//`define CNT_Z

// q_next=0 as a registered output
`define CNT_ZQ

