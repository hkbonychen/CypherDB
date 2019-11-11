#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/aes.h>

#include "nation.h"
#include "dbload.h"
#include "print.h"
#include "crypto.h"

void nationOTP_malloc(nationOTP *nationOTPPt, nation *sizePt)
{
  nationOTPPt->nationKey = (char *)malloc(sizeof(int));
  nationOTPPt->name = (char *)malloc(strlen(sizePt->name));
  nationOTPPt->regionKey = (char *)malloc(sizeof(int));
  nationOTPPt->comment = (char *)malloc(strlen(sizePt->comment));
    /* OPE need not memory allocation */
}

void nationOTP_free(nationOTP *nationOTPPt)
{
  free(nationOTPPt->nationKey);
  free(nationOTPPt->name);
  free(nationOTPPt->regionKey);
  free(nationOTPPt->comment);
  /* OPE need not to be freed */
}

void toNationOTP(nation *nationPt, nationOTP *nationOTPPt)
{
  int j;
  unsigned char *temp;
	
  temp = BytesFromInt(nationPt->nationKey, 4);
  memcpy(nationOTPPt->nationKey, temp, 4);
  free(temp);

  memcpy(nationOTPPt->name, nationPt->name, strlen(nationPt->name));

  temp = BytesFromInt(nationPt->regionKey, 4);
  memcpy(nationOTPPt->regionKey, temp, 4);
  free(temp);

  memcpy(nationOTPPt->comment, nationPt->comment, strlen(nationPt->comment));
  /* OPE transfer */
  nationOTPPt->nationKeyOPE = nationPt->nationKeyOPE;
  nationOTPPt->regionKeyOPE = nationPt->regionKeyOPE;
}

/* read file functions */

void 
readNation(nation* nationPt, FILE* ifp)
{
  readInt(&(nationPt->nationKey), ifp);
  readString(&(nationPt->name), ifp);
  readInt(&(nationPt->regionKey), ifp);
  readString(&(nationPt->comment), ifp);
  /* read OPE value */
  readllong(&(nationPt->nationKeyOPE), ifp);
  readllong(&(nationPt->regionKeyOPE), ifp);
}

void readNationOTP(nationOTP *nationOTPPt, nation* sizePt, FILE* ifp) 
{
  int i;

  i = fread(nationOTPPt->nationKey, sizeof(unsigned char), sizeof(int), ifp);
  i = fread(nationOTPPt->name, sizeof(unsigned char), strlen(sizePt->name), ifp);
  i = fread(nationOTPPt->regionKey, sizeof(unsigned char), sizeof(int), ifp);
  i = fread(nationOTPPt->comment, sizeof(unsigned char), strlen(sizePt->comment), ifp);
  /* read OPE value missing */
}

/* encryption/decryption function */

void encryptNation(nation *nationPt, nationOTP *nationOTPPt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE])
{
  ctrEncryptINT(nationPt->nationKey, 0, nationOTPPt->nationKey, sizeof(int), cntr, aes);
  ctrEncryptString(nationPt->name, 1, nationOTPPt->name, strlen(nationPt->name), cntr, aes);
  ctrEncryptINT(nationPt->regionKey, 2, nationOTPPt->regionKey, sizeof(int), cntr, aes);
  ctrEncryptString(nationPt->comment, 3, nationOTPPt->comment, strlen(nationPt->comment), cntr, aes);
  /* OPE value direct copy, no decryption */
  nationOTPPt->nationKeyOPE = nationPt->nationKeyOPE;
  nationOTPPt->regionKeyOPE = nationPt->regionKeyOPE;
}

void decryptNation(nationOTP *nationOTPPt, nationOTP *nationDecPt, nation *sizePt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE])
{
  ctrDecryptINT(nationOTPPt->nationKey, 0, nationDecPt->nationKey, sizeof(int), cntr, aes);
  ctrDecryptString(nationOTPPt->name, 1, nationDecPt->name, strlen(sizePt->name), cntr, aes);
  ctrDecryptINT(nationOTPPt->regionKey, 2, nationDecPt->regionKey, sizeof(int), cntr, aes);
  ctrDecryptString(nationOTPPt->comment, 3, nationDecPt->comment, strlen(sizePt->comment), cntr, aes);
  /* OPE value direct copy, no decryption */
  nationDecPt->nationKeyOPE = nationOTPPt->nationKeyOPE;
  nationDecPt->regionKeyOPE = nationOTPPt->regionKeyOPE;
}

/* print function */

void printNation(nation *nationPt, FILE * ifp)
{
  printInt(ifp, nationPt->nationKey, "|");
  printString(ifp, nationPt->name, "|");
  printInt(ifp, nationPt->regionKey, "|");
  printString(ifp, nationPt->comment, "|");
  /* print OPE value */
  printllong(ifp, nationPt->nationKeyOPE, "|");
  printllong(ifp, nationPt->regionKeyOPE, "|");
  fprintf(ifp, "\n");
}

void printNationOTP(nationOTP *nationOTPPt, nation *sizePt, FILE *ifp)
{
  printBinary(ifp, nationOTPPt->nationKey, sizeof(int));
  printBinary(ifp, nationOTPPt->name, strlen(sizePt->name));
  printBinary(ifp, nationOTPPt->regionKey, sizeof(int));
  printBinary(ifp, nationOTPPt->comment, strlen(sizePt->comment));
}	

void printNationTemplate(nation *nationPt, FILE * ifp)
{
  printInt(ifp, -96746058, "|");
  printString(ifp, nationPt->name, "|");
  printInt(ifp, -96746058, "|");
  printString(ifp, nationPt->comment, "|");
  /* print OPE value */
  printllong(ifp, nationPt->nationKeyOPE, "|");
  printllong(ifp, nationPt->regionKeyOPE, "");
  fprintf(ifp, "\n");
}
