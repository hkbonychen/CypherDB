#include "spi.h"
#include "board.h"
#include "orsocdef.h"

char get_master_version()
{
  char v;
  v = REG8(SPI_MASTER_BASE+SPI_MASTER_VERSION_REG);
  return v;
}

int sd_init()
{
  char c;

  REG8(SPI_MASTER_BASE+TRANS_TYPE_REG) = INIT_SD;
  REG8(SPI_MASTER_BASE+TRANS_CTRL_REG) = TRANS_START;
  do {
    c = REG8(SPI_MASTER_BASE+TRANS_STS_REG);
  } while(c == SPI_TRANS_BUSY);

  REG8(SPI_MASTER_BASE+TRANS_CTRL_REG) = NO_TRANS;

  REG8(SPI_MASTER_BASE+RX_FIFO_CONTROL_REG) = 0x1;

  c = REG8(SPI_MASTER_BASE+TRANS_ERROR_REG);
  //uart_print_hex8(c);
  if ((c & 0x3)==0)
    return 0;
  else return 1;
}

int sd_block_write()
{
  int i;
  char c;

  uart_print_str("Before: TX FIFO entries:");
  c = REG8(SPI_MASTER_BASE+TX_FIFO_DATA_COUNT_MSB);
  uart_print_hex8(c);
  c = REG8(SPI_MASTER_BASE+TX_FIFO_DATA_COUNT_LSB);
  uart_print_hex8(c);
  uart_print_str("\n");

  for (i=0;i<512;i++)
    REG8(SPI_MASTER_BASE+TX_FIFO_DATA_REG) = 0x37;

  uart_print_str("After: TX FIFO entries:");
  c = REG8(SPI_MASTER_BASE+TX_FIFO_DATA_COUNT_MSB);
  uart_print_hex8(c);
  c = REG8(SPI_MASTER_BASE+TX_FIFO_DATA_COUNT_LSB);
  uart_print_hex8(c);
  uart_print_str("\n");

  REG8(SPI_MASTER_BASE+SD_ADDR_7_0_REG) = 0x00;
  REG8(SPI_MASTER_BASE+SD_ADDR_15_8_REG) = 0x06;
  REG8(SPI_MASTER_BASE+SD_ADDR_23_16_REG) = 0x00;
  REG8(SPI_MASTER_BASE+SD_ADDR_31_24_REG) = 0x00;

  REG8(SPI_MASTER_BASE+TRANS_TYPE_REG) = RW_WRITE_SD_BLOCK;
  REG8(SPI_MASTER_BASE+TRANS_CTRL_REG) = TRANS_START;
  do {
    c = REG8(SPI_MASTER_BASE+TRANS_STS_REG);
  } while(c == SPI_TRANS_BUSY);

  REG8(SPI_MASTER_BASE+TRANS_CTRL_REG) = NO_TRANS;

  c = REG8(SPI_MASTER_BASE+TRANS_ERROR_REG);

  uart_print_hex8(c);

  if ((c & 0x30) == 0)
    return 0;
  else return 1;
}

int sd_block_read()
{
  int i;
  char c;
  char buf[512];

  REG8(SPI_MASTER_BASE+SD_ADDR_7_0_REG) = 0x00;
  REG8(SPI_MASTER_BASE+SD_ADDR_15_8_REG) = 0x06;
  REG8(SPI_MASTER_BASE+SD_ADDR_23_16_REG) = 0x00;
  REG8(SPI_MASTER_BASE+SD_ADDR_31_24_REG) = 0x00;

  REG8(SPI_MASTER_BASE+TRANS_TYPE_REG) = RW_READ_SD_BLOCK;
  REG8(SPI_MASTER_BASE+TRANS_CTRL_REG) = TRANS_START;
  do {
    c = REG8(SPI_MASTER_BASE+TRANS_STS_REG);
  } while(c == SPI_TRANS_BUSY);

  REG8(SPI_MASTER_BASE+TRANS_CTRL_REG) = NO_TRANS;

  uart_print_str("After: RX FIFO entries:");
  c = REG8(SPI_MASTER_BASE+RX_FIFO_DATA_COUNT_MSB);
  uart_print_hex8(c);
  c = REG8(SPI_MASTER_BASE+RX_FIFO_DATA_COUNT_LSB);
  uart_print_hex8(c);
  uart_print_str("\n");

  c = REG8(SPI_MASTER_BASE+TRANS_ERROR_REG);

  uart_print_hex8(c);

  if ((c & 0xc) == 0)
    {
      for (i=0;i<512;i++)
	{
	  c = REG8(SPI_MASTER_BASE+RX_FIFO_DATA_REG);
	  uart_print_hex8(c);
	  uart_print_str(".");
	}
      return 0;
    }
  else return 1;
}



