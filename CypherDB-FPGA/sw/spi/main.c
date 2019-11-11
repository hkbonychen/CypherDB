/*
  SPI controller simple test

  Do some reads from the SPI slaves. Select a different slave each loop
  and does a read and reports the value.

  Nothing much actually gets tested here.

  Ensure the slave selects for the spi are enabled in orpsoc-defines.v

*/


//#include "cpu-utils.h"
#include "simple-spi.h"
#include "uart.h"
#include "sd.h"
#include "orsocdef.h"

void sd_delay( int cycles)
{
  int i;
  char tmp;

  for (i=0;i<cycles;i++)
    {
      
      if (spi_core_write_avail())
	spi_core_write_data(0xaa);
      while ((spi_core_get_spsr() & 0x80) != 0x80) {};
      tmp = spi_core_read_data();
      spi_core_interrupt_flag_clear();
    }
}

void sd_packarg(unsigned char *argument, int value)
{
  argument[3] = (unsigned char)(value >>24);
  argument[2] = (unsigned char)(value >>16);
  argument[1] = (unsigned char)(value >>8);
  argument[0] = (unsigned char)(value);
}

int sd_send_command(unsigned char cmd, unsigned char *argument, unsigned char response_type, unsigned char *response)
{
  int i;
  unsigned char tmp;
  char response_length;

  spi_cs_assert();
  spi_core_write_data((cmd & 0x3f) | 0x40);
  
  for (i=3; i>=0; i--)
    spi_core_write_data(argument[i]);
  spi_core_write_data(0x95);
  
  response_length=0;
  switch(response_type)
    {
    case R1:
    case R1B:
      response_length=1;
      break;
    case R2:
      response_length=2;
      break;
    case R3:
      response_length=5;
      break;
    default:
      break;
    }

  i=0;
  do{
     tmp = spi_core_read_data();
     i++;
  }while( ((tmp & 0x80) != 0) && (i < SD_CMD_TIMEOUT));

  if (i >= SD_CMD_TIMEOUT)
    {
      spi_cs_deassert();
      return 0;
    }

  for (i=response_length-1; i>=0; i--)
    {
      response[i] = tmp;
      tmp = spi_core_read_data();
    }
  spi_cs_deassert();
  return 1;
}

int main()
{
  int i;
  char dat;
  unsigned char response[5];
  unsigned char argument[4];

  // init uart
  uart_init();
  sd_packarg(argument, 0);

  spi_core_clock_setup(0, 0, 2, 2);
  spi_core_enable();

  // Play with the slaves
  
  // Select slave on SPI bus
  spi_cs_assert();
  // send out at least 74 clock cycles
  sd_delay(1000);
  spi_cs_deassert();
  sd_delay(16);

    
  if (!sd_send_command(CMD0, argument, CMD0_R, response))
    uart_print_str("send cmd0 failed!");
  else     uart_print_str("send cmd0 succeeded!");

  uart_print_str("\n");
  /*
  while (!spi_core_write_avail());      
  spi_core_write_data((i&0xff));
  while (!spi_core_data_avail());
  //report(spi_core_read_data(spi_master));
  dat = spi_core_read_data();
  uart_putc(dat);
  uart_print_str("\n");
  // Deselect slaves
  spi_core_slave_select(0);
  */	
    
  
  //exit(0x8000000d);
  
}
