#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/aes.h>

#include "partsupp.h"
#include "dbload.h"
#include "print.h"
#include "crypto.h"

void partSuppOTP_malloc(partSuppOTP *partSuppOTPPt, partSupp *sizePt)
{
  partSuppOTPPt->partKey = (char *)malloc(sizeof(int));
  partSuppOTPPt->suppKey = (char *)malloc(sizeof(int));
  partSuppOTPPt->availQty = (char *)malloc(sizeof(int));
  partSuppOTPPt->supplyCost = (char *)malloc(sizeof(double));
  partSuppOTPPt->comment = (char *)malloc(strlen(sizePt->comment));
}

void partSuppOTP_free(partSuppOTP *partSuppOTPPt)
{
  free(partSuppOTPPt->partKey);
  free(partSuppOTPPt->suppKey);
  free(partSuppOTPPt->availQty);
  free(partSuppOTPPt->supplyCost);
  free(partSuppOTPPt->comment);
}

void partSupp_free(partSupp *partSuppPt)
{
  free(partSuppPt->comment);
}

void toPartSuppOTP(partSupp *partSuppPt, partSuppOTP *partSuppOTPPt)
{
  int j;
  unsigned char *temp;
	
  temp = BytesFromInt(partSuppPt->partKey, 4);
  memcpy(partSuppOTPPt->partKey, temp, 4);
  free(temp);

  temp = BytesFromInt(partSuppPt->suppKey, 4);
  memcpy(partSuppOTPPt->suppKey, temp, 4);
  free(temp);

  temp = BytesFromInt(partSuppPt->availQty, 4);
  memcpy(partSuppOTPPt->availQty, temp, 4);
  free(temp);

  for (j=0; j<8; j++) 
    partSuppOTPPt->supplyCost[j] = *((char *)(&partSuppPt->supplyCost)+7-j);

  memcpy(partSuppOTPPt->comment, partSuppPt->comment, strlen(partSuppPt->comment));
}

/* read file functions */

void 
readPartSupp(partSupp* partSuppPt, FILE* ifp)
{
  readInt(&(partSuppPt->partKey), ifp);
  readInt(&(partSuppPt->suppKey), ifp);
  readInt(&(partSuppPt->availQty), ifp);
  readDouble(&(partSuppPt->supplyCost), ifp);
  readString(&(partSuppPt->comment), ifp);
}

void readPartSuppOTP(partSuppOTP *partSuppOTPPt, partSupp* sizePt, FILE* ifp) 
{
  int i;

  i = fread(partSuppOTPPt->partKey, sizeof(unsigned char), sizeof(int), ifp);
  i = fread(partSuppOTPPt->suppKey, sizeof(unsigned char), sizeof(int), ifp);
  i = fread(partSuppOTPPt->availQty, sizeof(unsigned char), sizeof(int), ifp);
  i = fread(partSuppOTPPt->supplyCost, sizeof(unsigned char), sizeof(double), ifp);	
  i = fread(partSuppOTPPt->comment, sizeof(unsigned char), strlen(sizePt->comment), ifp);
}

/* encryption/decryption function */

void encryptPartSupp(partSupp *partSuppPt, partSuppOTP *partSuppOTPPt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE])
{
  ctrEncryptINT(partSuppPt->partKey, 0, partSuppOTPPt->partKey, sizeof(int), cntr, aes);
  ctrEncryptINT(partSuppPt->suppKey, 1, partSuppOTPPt->suppKey, sizeof(int), cntr, aes);
  ctrEncryptINT(partSuppPt->availQty, 2, partSuppOTPPt->availQty, sizeof(int), cntr, aes);
  ctrEncryptDouble(partSuppPt->supplyCost, 3, partSuppOTPPt->supplyCost, sizeof(double), cntr, aes);
  ctrEncryptString(partSuppPt->comment, 4, partSuppOTPPt->comment, strlen(partSuppPt->comment), cntr, aes);
}

void decryptPartSupp(partSuppOTP *partSuppOTPPt, partSuppOTP *partSuppDecPt, partSupp *sizePt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE])
{
  ctrDecryptINT(partSuppOTPPt->partKey, 0, partSuppDecPt->partKey, sizeof(int), cntr, aes);
  ctrDecryptINT(partSuppOTPPt->suppKey, 1, partSuppDecPt->suppKey, sizeof(int), cntr, aes);
  ctrDecryptINT(partSuppOTPPt->availQty, 2, partSuppDecPt->availQty, sizeof(int), cntr, aes);
  ctrDecryptDouble(partSuppOTPPt->supplyCost, 3, partSuppDecPt->supplyCost, sizeof(double), cntr, aes);
  ctrDecryptString(partSuppOTPPt->comment, 4, partSuppDecPt->comment, strlen(sizePt->comment), cntr, aes);

}

/* print function */

void printPartSupp(partSupp *partSuppPt, FILE * ifp)
{
  printInt(ifp, partSuppPt->partKey, "|");
  printInt(ifp, partSuppPt->suppKey, "|");
  printInt(ifp, partSuppPt->availQty, "|");
  printDouble(ifp, partSuppPt->supplyCost, "|");
  printString(ifp, partSuppPt->comment, "|");
  fprintf(ifp, "\n");
}

void printPartSuppOTP(partSuppOTP *partSuppOTPPt, partSupp *sizePt, FILE *ifp)
{
  printBinary(ifp, partSuppOTPPt->partKey, sizeof(int));
  printBinary(ifp, partSuppOTPPt->suppKey, sizeof(int));
  printBinary(ifp, partSuppOTPPt->availQty, sizeof(int));
  printBinary(ifp, partSuppOTPPt->supplyCost, sizeof(double));
  printBinary(ifp, partSuppOTPPt->comment, strlen(sizePt->comment));
}	

void printPartSuppTemplate(partSupp *partSuppPt, FILE * ifp)
{
  printInt(ifp, partSuppPt->partKey, "|");
  printInt(ifp,  partSuppPt->suppKey, "|");
  printInt(ifp, -96746058, "|");
  printDouble(ifp, 24386.67, "|");
  printString(ifp, partSuppPt->comment, "");
  fprintf(ifp, "\n");
}	
