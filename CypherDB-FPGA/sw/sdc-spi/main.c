#include "uart.h"
#include "spi.h"
#include "board.h"
#include "orsocdef.h"

int main()
{
  char c;
  char block[512];
  int i;

  uart_init();
  /* version = get_master_version(); */
  /* uart_print_str("0x"); */
  /* uart_print_hex8(version); */
  /* uart_print_str("\n"); */
  
  if (!sd_init())
    uart_print_str("sd card initialized!");
  else uart_print_str("sd card initialisation fails!");
  uart_print_str("\n");

  uart_print_str("Before: RX FIFO entries:");
  while(1)
  c = REG8(SPI_MASTER_BASE+RX_FIFO_DATA_COUNT_MSB);
  uart_print_hex8(c);
  c = REG8(SPI_MASTER_BASE+RX_FIFO_DATA_COUNT_LSB);
  uart_print_hex8(c);
  uart_print_str("\n");

  /* if (!sd_block_write()) */
  /*   uart_print_str("sd card write succeeds!"); */
  /* else uart_print_str("sd card write fails!"); */
  /* uart_print_str("\n"); */

  /* if (!sd_block_read()) */
  /*   uart_print_str("sd card read succeeds!"); */
  /* else uart_print_str("sd card read fails!"); */
  /* uart_print_str("\n"); */
  
  /* for (i=0;i<512;i++) */
  /*   { */
  /*     uart_print_hex8(block[i]); */
  /*     uart_print_str("."); */
  /*   } */
  uart_print_str("\n");
  return 0;
}
