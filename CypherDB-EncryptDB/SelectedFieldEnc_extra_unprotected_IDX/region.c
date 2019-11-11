#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/aes.h>

#include "region.h"
#include "dbload.h"
#include "print.h"
#include "crypto.h"

void freeRegion(region* regionPt)
{
  free(regionPt->name);
  free(regionPt->comment);
}

void regionOTP_malloc(regionOTP *regionOTPPt, region *sizePt)
{
  regionOTPPt->regionKey = (char *)malloc(sizeof(int));
  regionOTPPt->name = (char *)malloc(strlen(sizePt->name));
  regionOTPPt->comment = (char *)malloc(strlen(sizePt->comment));
  /* OPE need not memory allocation */
}

void regionOTP_free(regionOTP *regionOTPPt)
{
  free(regionOTPPt->regionKey);
  free(regionOTPPt->name);
  free(regionOTPPt->comment);
  /* OPE need not to be freed */
}

void toRegionOTP(region *regionPt, regionOTP *regionOTPPt)
{
  int j;
  unsigned char *temp;
	
  temp = BytesFromInt(regionPt->regionKey, 4);
  memcpy(regionOTPPt->regionKey, temp, 4);
  free(temp);

  memcpy(regionOTPPt->name, regionPt->name, strlen(regionPt->name));

  memcpy(regionOTPPt->comment, regionPt->comment, strlen(regionPt->comment));
  /* OPE transfer */
  regionOTPPt->regionKeyOPE = regionPt->regionKeyOPE;
}

/* read file functions */

void 
readRegion(region* regionPt, FILE* ifp)
{
  readInt(&(regionPt->regionKey), ifp);
  readString(&(regionPt->name), ifp);
  readString(&(regionPt->comment), ifp);
  /* read OPE value */
  readllong(&(regionPt->regionKeyOPE), ifp);
}

void readRegionOTP(regionOTP *regionOTPPt, region* sizePt, FILE* ifp) 
{
  int i;

  i = fread(regionOTPPt->regionKey, sizeof(unsigned char), sizeof(int), ifp);
  i = fread(regionOTPPt->name, sizeof(unsigned char), strlen(sizePt->name), ifp);
  i = fread(regionOTPPt->comment, sizeof(unsigned char), strlen(sizePt->comment), ifp);
  /* read OPE value missing */
}

/* encryption/decryption function */

void encryptRegion(region *regionPt, regionOTP *regionOTPPt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE])
{
  ctrEncryptINT(regionPt->regionKey, 0, regionOTPPt->regionKey, sizeof(int), cntr, aes);
  ctrEncryptString(regionPt->name, 1, regionOTPPt->name, strlen(regionPt->name), cntr, aes);
  ctrEncryptString(regionPt->comment, 2, regionOTPPt->comment, strlen(regionPt->comment), cntr, aes);
  /* OPE value direct copy, no decryption */
  regionOTPPt->regionKeyOPE = regionPt->regionKeyOPE;
}

void decryptRegion(regionOTP *regionOTPPt, regionOTP *regionDecPt, region *sizePt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE])
{
  ctrDecryptINT(regionOTPPt->regionKey, 0, regionDecPt->regionKey, sizeof(int), cntr, aes);
  ctrDecryptString(regionOTPPt->name, 1, regionDecPt->name, strlen(sizePt->name), cntr, aes);
  ctrDecryptString(regionOTPPt->comment, 2, regionDecPt->comment, strlen(sizePt->comment), cntr, aes);
  /* OPE value direct copy, no decryption */
  regionOTPPt->regionKeyOPE = regionOTPPt->regionKeyOPE;
}

/* print function */

void printRegion(region *regionPt, FILE * ifp)
{
  printInt(ifp, regionPt->regionKey, "|");
  printString(ifp, regionPt->name, "|");
  printString(ifp, regionPt->comment, "|");
  /* print OPE value */
  printllong(ifp, regionPt->regionKeyOPE, "|");
  fprintf(ifp, "\n");
}

void printRegionOTP(regionOTP *regionOTPPt, region *sizePt, FILE *ifp)
{
  printBinary(ifp, regionOTPPt->regionKey, sizeof(int));
  printBinary(ifp, regionOTPPt->name, strlen(sizePt->name));
  printBinary(ifp, regionOTPPt->comment, strlen(sizePt->comment));
  /* print OPE value */
}	

void printRegionTemplate(region *regionPt, FILE * ifp)
{
  printInt(ifp, -96746058, "|");
  printString(ifp, regionPt->name, "|");
  printString(ifp, regionPt->comment, "|");
  /* print OPE value */
  printllong(ifp, regionPt->regionKeyOPE, "");
  fprintf(ifp, "\n");
}
