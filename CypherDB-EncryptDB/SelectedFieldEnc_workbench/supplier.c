#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/aes.h>

#include "supplier.h"
#include "dbload.h"
#include "print.h"
#include "crypto.h"

void supplierOTP_malloc(supplierOTP *supplierOTPPt, supplier *sizePt)
{
  supplierOTPPt->suppKey = (char *)malloc(sizeof(int));
  supplierOTPPt->name = (char *)malloc(strlen(sizePt->name));
  supplierOTPPt->address = (char *)malloc(strlen(sizePt->address));
  supplierOTPPt->nationKey = (char *)malloc(sizeof(int));
  supplierOTPPt->phone = (char *)malloc(strlen(sizePt->phone));
  supplierOTPPt->acctBal = (char *)malloc(sizeof(double));
  supplierOTPPt->comment = (char *)malloc(strlen(sizePt->comment));
  /* OPE need not memory allocation */
}

void supplierOTP_free(supplierOTP *supplierOTPPt)
{
  free(supplierOTPPt->suppKey);
  free(supplierOTPPt->name);
  free(supplierOTPPt->address);
  free(supplierOTPPt->nationKey);
  free(supplierOTPPt->phone);
  free(supplierOTPPt->acctBal);
  free(supplierOTPPt->comment);
  /* OPE need not to be freed */
}

void toSupplierOTP(supplier *supplierPt, supplierOTP *supplierOTPPt)
{
  int j;
  unsigned char *temp;
	
  temp = BytesFromInt(supplierPt->suppKey, 4);
  memcpy(supplierOTPPt->suppKey, temp, 4);
  free(temp);

  memcpy(supplierOTPPt->name, supplierPt->name, strlen(supplierPt->name));
	
  memcpy(supplierOTPPt->address, supplierPt->address, strlen(supplierPt->address));

  temp = BytesFromInt(supplierPt->nationKey, 4);
  memcpy(supplierOTPPt->nationKey, temp, 4);
  free(temp);

  memcpy(supplierOTPPt->phone, supplierPt->phone, strlen(supplierPt->phone));

  for (j=0; j<8; j++) 
    supplierOTPPt->acctBal[j] = *((char *)(&supplierPt->acctBal)+7-j);

  memcpy(supplierOTPPt->comment, supplierPt->comment, strlen(supplierPt->comment));
  /* OPE transfer */
  supplierOTPPt->suppKeyOPE = supplierPt->suppKeyOPE;
  supplierOTPPt->nationKeyOPE = supplierPt->nationKeyOPE;
}

/* read file functions */

void 
readSupplier(supplier* supplierPt, FILE* ifp)
{
  readInt(&(supplierPt->suppKey), ifp);
  readString(&(supplierPt->name), ifp);
  readString(&(supplierPt->address), ifp);
  readInt(&(supplierPt->nationKey), ifp);
  readString(&(supplierPt->phone), ifp);
  readDouble(&(supplierPt->acctBal), ifp);
  readString(&(supplierPt->comment), ifp);
  /* read OPE value */
  readllong(&(supplierPt->suppKeyOPE), ifp);
  readllong(&(supplierPt->nationKeyOPE), ifp);
}

void readSupplierOTP(supplierOTP *supplierOTPPt, supplier* sizePt, FILE* ifp) 
{
  int i;

  i = fread(supplierOTPPt->suppKey, sizeof(unsigned char), sizeof(int), ifp);
  i = fread(supplierOTPPt->name, sizeof(unsigned char), strlen(sizePt->name), ifp);
  i = fread(supplierOTPPt->address, sizeof(unsigned char), strlen(sizePt->address), ifp);
  i = fread(supplierOTPPt->nationKey, sizeof(unsigned char), sizeof(int), ifp);
  i = fread(supplierOTPPt->phone, sizeof(unsigned char), strlen(sizePt->phone), ifp);
  i = fread(supplierOTPPt->acctBal, sizeof(unsigned char), sizeof(double), ifp);      
  i = fread(supplierOTPPt->comment, sizeof(unsigned char), strlen(sizePt->comment), ifp);
  /* read OPE value missing */
}

/* encryption/decryption function */

void encryptSupplier(supplier *supplierPt, supplierOTP *supplierOTPPt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE])
{
  ctrEncryptINT(supplierPt->suppKey, 0, supplierOTPPt->suppKey, sizeof(int), cntr, aes);
  ctrEncryptString(supplierPt->name, 1, supplierOTPPt->name, strlen(supplierPt->name), cntr, aes);
  ctrEncryptString(supplierPt->address, 2, supplierOTPPt->address, strlen(supplierPt->address), cntr, aes);
  ctrEncryptINT(supplierPt->nationKey, 3, supplierOTPPt->nationKey, sizeof(int), cntr, aes);
  ctrEncryptString(supplierPt->phone, 4, supplierOTPPt->phone, strlen(supplierPt->phone), cntr, aes);
  ctrEncryptDouble(supplierPt->acctBal, 5, supplierOTPPt->acctBal, sizeof(double), cntr, aes);
  ctrEncryptString(supplierPt->comment, 6, supplierOTPPt->comment, strlen(supplierPt->comment), cntr, aes);
  /* OPE value direct copy, no decryption */
  supplierOTPPt->suppKeyOPE = supplierPt->suppKeyOPE;
  supplierOTPPt->nationKeyOPE = supplierPt->nationKeyOPE;
}

void decryptSupplier(supplierOTP *supplierOTPPt, supplierOTP *supplierDecPt, supplier *sizePt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE])
{
  ctrDecryptINT(supplierOTPPt->suppKey, 0, supplierDecPt->suppKey, sizeof(int), cntr, aes);
  ctrDecryptString(supplierOTPPt->name, 1, supplierDecPt->name, strlen(sizePt->name), cntr, aes);
  ctrDecryptString(supplierOTPPt->address, 2, supplierDecPt->address, strlen(sizePt->address), cntr, aes);
  ctrDecryptINT(supplierOTPPt->nationKey, 3, supplierDecPt->nationKey, sizeof(int), cntr, aes);
  ctrDecryptString(supplierOTPPt->phone, 4, supplierDecPt->phone, strlen(sizePt->phone), cntr, aes);
  ctrDecryptDouble(supplierOTPPt->acctBal, 5, supplierDecPt->acctBal, sizeof(double), cntr, aes);
  ctrDecryptString(supplierOTPPt->comment, 6, supplierDecPt->comment, strlen(sizePt->comment), cntr, aes);
  /* OPE value direct copy, no decryption */
  supplierDecPt->suppKeyOPE = supplierOTPPt->suppKeyOPE;
  supplierDecPt->nationKeyOPE = supplierOTPPt->nationKeyOPE;
}

/* print function */

void printSupplier(supplier *supplierPt, FILE * ifp)
{
  printInt(ifp, supplierPt->suppKey, "|");
  printString(ifp, supplierPt->name, "|");
  printString(ifp, supplierPt->address, "|");
  printInt(ifp, supplierPt->nationKey, "|");	
  printString(ifp, supplierPt->phone, "|");
  printDouble(ifp, supplierPt->acctBal, "|");
  printString(ifp, supplierPt->comment, "|");
   /* print OPE value */
  printllong(ifp, supplierPt->suppKeyOPE, "|");
  printllong(ifp, supplierPt->nationKeyOPE, "|");
  fprintf(ifp, "\n");
}

void printSupplierOTP(supplierOTP *supplierOTPPt, supplier *sizePt, FILE *ifp)
{
  printBinary(ifp, supplierOTPPt->suppKey, sizeof(int));
  printBinary(ifp, supplierOTPPt->name, strlen(sizePt->name));
  printBinary(ifp, supplierOTPPt->address, strlen(sizePt->address));
  printBinary(ifp, supplierOTPPt->nationKey, sizeof(int));
  printBinary(ifp, supplierOTPPt->phone, strlen(sizePt->phone));
  printBinary(ifp, supplierOTPPt->acctBal, sizeof(double));
  printBinary(ifp, supplierOTPPt->comment, strlen(sizePt->comment));
  /* print OPE value */
}	

void printSupplierTemplate(supplier *supplierPt, FILE * ifp)
{
  printInt(ifp, -96746058, "|");
  printString(ifp, supplierPt->name, "|");
  printString(ifp, supplierPt->address, "|");
  printInt(ifp, -96746058, "|");	
  printString(ifp, supplierPt->phone, "|");
  printDouble(ifp, 24386.67, "|");
  printString(ifp, supplierPt->comment, "|");
   /* print OPE value */
  printllong(ifp, supplierPt->suppKeyOPE, "|");
  printllong(ifp, supplierPt->nationKeyOPE, "");
  fprintf(ifp, "\n");
}
