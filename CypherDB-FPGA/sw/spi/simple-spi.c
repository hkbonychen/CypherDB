/*
 * Simple SPI module driver
 *
 * Julius Baxter, julius.baxter@orsoc.se
 *
 */

#include "board.h"
#include "simple-spi.h"
#include "orsocdef.h"
#include "uart.h"

// For older builds - need to change them all over to newer format
#ifdef SPI0_BASE
const int SPI_BASE_ADR = {SPI0_BASE};
#endif


void 
spi_core_enable()
{
  REG8((SPI_BASE_ADR + SIMPLESPI_SPCR)) |= SIMPLESPI_SPCR_SPE;
}

void 
spi_core_disable()
{
  REG8((SPI_BASE_ADR + SIMPLESPI_SPCR)) &= ~SIMPLESPI_SPCR_SPE;
}

void 
spi_core_interrupt_enable()
{
  REG8((SPI_BASE_ADR + SIMPLESPI_SPCR)) |= SIMPLESPI_SPCR_SPIE;
}

void 
spi_core_interrupt_disable()
{
  REG8((SPI_BASE_ADR + SIMPLESPI_SPCR)) &= ~SIMPLESPI_SPCR_SPIE;
}

void 
spi_core_interrupt_flag_clear()
{
  REG8((SPI_BASE_ADR + SIMPLESPI_SPSR)) = SIMPLESPI_SPSR_SPIF;
}

void 
spi_core_clock_setup(char polarity, char phase, char rate,
			  char ext_rate)
{
  char spcr;
 
  spcr = REG8((SPI_BASE_ADR + SIMPLESPI_SPCR));
  if (polarity)
    spcr |= SIMPLESPI_SPCR_CPOL;
  else
    spcr &= ~SIMPLESPI_SPCR_CPOL;

  if (phase)
    spcr |= SIMPLESPI_SPCR_CPHA;
  else
    spcr &= ~SIMPLESPI_SPCR_CPHA;

  // with interrupt enable
  //spcr |=  SIMPLESPI_SPSR_SPIF;

  spcr = (spcr & ~SIMPLESPI_SPCR_SPR) | (rate & SIMPLESPI_SPCR_SPR);

  REG8((SPI_BASE_ADR + SIMPLESPI_SPCR)) = spcr;

  char sper = REG8((SPI_BASE_ADR + SIMPLESPI_SPER));
  
  sper = (sper & ~SIMPLESPI_SPER_ESPR) | (ext_rate & SIMPLESPI_SPER_ESPR);

  REG8((SPI_BASE_ADR + SIMPLESPI_SPER)) = sper;

}

void 
spi_core_set_int_count(char cnt)
{  
  char sper = REG8((SPI_BASE_ADR + SIMPLESPI_SPER));
  
  sper = (sper & ~SIMPLESPI_SPER_ICNT) | cnt;
  
  REG8((SPI_BASE_ADR + SIMPLESPI_SPER)) = sper;
  
}
// No decode on slave select lines, so assert correct bit to select slave
void 
spi_core_slave_select(char slave_sel_dec)
{  
  REG8((SPI_BASE_ADR + SIMPLESPI_SSPU)) = slave_sel_dec;
}

int 
spi_core_data_avail()
{
  return !!!(REG8((SPI_BASE_ADR+SIMPLESPI_SPSR))&SIMPLESPI_SPSR_RFEMPTY);
}

int 
spi_core_write_avail()
{
  return !!!(REG8((SPI_BASE_ADR+SIMPLESPI_SPSR))&SIMPLESPI_SPSR_WFFULL);
}

// Should call spi_core_write_avail() before calling this, we don't check
void 
spi_core_write_data(char data)
{
  REG8((SPI_BASE_ADR + SIMPLESPI_SPDR)) = data;
}

char 
spi_core_read_data()
{
  return REG8((SPI_BASE_ADR + SIMPLESPI_SPDR));
}

/* -----------------UDF---------------------*/

void spi_cs_assert()
{
  REG8((SPI_BASE_ADR + SIMPLESPI_SSPU)) = 1;
}

void spi_cs_deassert()
{
  REG8((SPI_BASE_ADR + SIMPLESPI_SSPU)) = 0;
}

char spi_core_get_spsr()
{
  return  REG8(SPI_BASE_ADR + SIMPLESPI_SPSR);
}

/* -----------------UDF---------------------*/
