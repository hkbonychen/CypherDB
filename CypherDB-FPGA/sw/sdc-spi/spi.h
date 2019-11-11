#ifndef SPI_H
#define SPI_H

/* spi-master register naming */

#define SPI_MASTER_VERSION_REG 0x0
#define SPI_MASTER_CONTROL_REG 0x1
#define TRANS_TYPE_REG 0x2
#define TRANS_CTRL_REG 0x3
#define TRANS_STS_REG 0x4
#define TRANS_ERROR_REG 0x5
#define DIRECT_ACCESS_DATA_REG 0x6
#define SD_ADDR_7_0_REG 0x7
#define SD_ADDR_15_8_REG 0x8
#define SD_ADDR_23_16_REG 0x9
#define SD_ADDR_31_24_REG 0xa
#define SPI_CLK_DEL_REG 0xb
#define RX_FIFO_DATA_REG 0x10
#define RX_FIFO_DATA_COUNT_MSB 0x12
#define RX_FIFO_DATA_COUNT_LSB 0x13
#define RX_FIFO_CONTROL_REG 0x14
#define TX_FIFO_DATA_REG 0x20
#define TX_FIFO_DATA_COUNT_MSB 0x22
#define TX_FIFO_DATA_COUNT_LSB 0x23
#define TX_FIFO_CONTROL_REG 0x24

/* spi-master options */

/* options for TRANS_TYPE_REG */
#define DIRECT_ACCESS 0x0
#define INIT_SD 0x1
#define RW_READ_SD_BLOCK 0x2
#define RW_WRITE_SD_BLOCK 0x3

/* options for TRANS_CTRL_REG */
#define TRANS_START 0x1
#define NO_TRANS 0x0

/* options for TRANS_STS_REG */
#define SPI_TRANS_BUSY 0x1

/* function declaration */

char get_master_version();
int sd_init();
int sd_block_write();
int sd_block_read();

#endif
