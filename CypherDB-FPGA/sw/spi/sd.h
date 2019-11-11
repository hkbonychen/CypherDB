#ifndef SD_H
#define SD_H

#define SD_CMD_TIMEOUT 100


#define R1 1
#define R1B 2
#define R2 3
#define R3 4

/******************************** Basic command set **************************/
/* Reset cards to idle state */
#define CMD0 0
#define CMD0_R R1
/* Read the OCR (MMC mode, do not use for SD cards) */
#define CMD1 1
#define CMD1_R R1
/* Card sends the CSD */
#define CMD9 9
#define CMD9_R R1
/* Card sends CID */
#define CMD10 10
#define CMD10_R R1
/* Stop a multiple block (stream) read/write operation */
#define CMD12 12
#define CMD12_R R1B
/* Get the addressed card's status register */
#define CMD13 13
#define CMD13_R R2
/***************************** Block read commands **************************/
/* Set the block length */

#define CMD16 16
#define CMD16_R R1
/* Read a single block */
#define CMD17 17
#define CMD17_R R1
/* Read multiple blocks until a CMD12 */
#define CMD18 18
#define CMD18_R R1
/***************************** Block write commands *************************/
/* Write a block of the size selected with CMD16 */
#define CMD24 24
#define CMD24_R R1
/* Multiple block write until a CMD12 */
#define CMD25 25
#define CMD25_R R1
/* Program the programmable bits of the CSD */
#define CMD27 27
#define CMD27_R R1


#endif
