#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/aes.h>

#include "customer.h"
#include "dbload.h"
#include "print.h"
#include "crypto.h"

void freeCustomer(customer* customerPt)
{
  free(customerPt->name);
  free(customerPt->address);
  free(customerPt->phone);
  free(customerPt->mktSegment);
  free(customerPt->comment);
}

void customerOTP_malloc(customerOTP *customerOTPPt, customer *sizePt)
{
  customerOTPPt->custKey = (char *)malloc(sizeof(int));
  customerOTPPt->name = (char *)malloc(strlen(sizePt->name));
  customerOTPPt->address = (char *)malloc(strlen(sizePt->address));
  customerOTPPt->nationKey = (char *)malloc(sizeof(int));
  customerOTPPt->phone = (char *)malloc(strlen(sizePt->phone));
  customerOTPPt->acctBal = (char *)malloc(sizeof(double));
  customerOTPPt->mktSegment = (char *)malloc(strlen(sizePt->mktSegment));
  customerOTPPt->comment = (char *)malloc(strlen(sizePt->comment));
  /* OPE need not memory allocation */
}

void customerOTP_free(customerOTP *customerOTPPt)
{
  free(customerOTPPt->custKey);
  free(customerOTPPt->name);
  free(customerOTPPt->address);
  free(customerOTPPt->nationKey);
  free(customerOTPPt->phone);
  free(customerOTPPt->acctBal);
  free(customerOTPPt->mktSegment);
  free(customerOTPPt->comment);
  /* OPE need not to be freed */
}

void toCustomerOTP(customer *customerPt, customerOTP *customerOTPPt)
{
  int j;
  unsigned char *temp;
	
  temp = BytesFromInt(customerPt->custKey, 4);
  memcpy(customerOTPPt->custKey, temp, 4);
  free(temp);

  memcpy(customerOTPPt->name, customerPt->name, strlen(customerPt->name));
	
  memcpy(customerOTPPt->address, customerPt->address, strlen(customerPt->address));

  temp = BytesFromInt(customerPt->nationKey, 4);
  memcpy(customerOTPPt->nationKey, temp, 4);
  free(temp);

  memcpy(customerOTPPt->phone, customerPt->phone, strlen(customerPt->phone));

  for (j=0; j<8; j++) 
    customerOTPPt->acctBal[j] = *((char *)(&customerPt->acctBal)+7-j);

  memcpy(customerOTPPt->mktSegment, customerPt->mktSegment, strlen(customerPt->mktSegment));

  memcpy(customerOTPPt->comment, customerPt->comment, strlen(customerPt->comment));
  /* OPE transfer */
  customerOTPPt->custKeyOPE = customerPt->custKeyOPE;
  customerOTPPt->nationKeyOPE = customerPt->nationKeyOPE;
}

/* read file functions */

void 
readCustomer(customer* customerPt, FILE* ifp)
{
  readInt(&(customerPt->custKey), ifp);
  readString(&(customerPt->name), ifp);
  readString(&(customerPt->address), ifp);
  readInt(&(customerPt->nationKey), ifp);
  readString(&(customerPt->phone), ifp);
  readDouble(&(customerPt->acctBal), ifp);
  readString(&(customerPt->mktSegment), ifp);
  readString(&(customerPt->comment), ifp);
  /* read OPE value */
  readllong(&(customerPt->custKeyOPE), ifp);
  readllong(&(customerPt->nationKeyOPE), ifp);
}

void readCustomerOTP(customerOTP *customerOTPPt, customer* sizePt, FILE* ifp) 
{
  int i;

  i = fread(customerOTPPt->custKey, sizeof(unsigned char), sizeof(int), ifp);
  i = fread(customerOTPPt->name, sizeof(unsigned char), strlen(sizePt->name), ifp);
  i = fread(customerOTPPt->address, sizeof(unsigned char), strlen(sizePt->address), ifp);
  i = fread(customerOTPPt->nationKey, sizeof(unsigned char), sizeof(int), ifp);
  i = fread(customerOTPPt->phone, sizeof(unsigned char), strlen(sizePt->phone), ifp);
  i = fread(customerOTPPt->acctBal, sizeof(unsigned char), sizeof(double), ifp);	
  i = fread(customerOTPPt->mktSegment, sizeof(unsigned char), strlen(sizePt->mktSegment), ifp);
  i = fread(customerOTPPt->comment, sizeof(unsigned char), strlen(sizePt->comment), ifp);
  /* read OPE value missing */
}

/* encryption/decryption function */

void encryptCustomer(customer *customerPt, customerOTP *customerOTPPt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE])
{
  ctrEncryptINT(customerPt->custKey, 0, customerOTPPt->custKey, sizeof(int), cntr, aes);
  ctrEncryptString(customerPt->name, 1, customerOTPPt->name, strlen(customerPt->name), cntr, aes);
  ctrEncryptString(customerPt->address, 2, customerOTPPt->address, strlen(customerPt->address), cntr, aes);
  ctrEncryptINT(customerPt->nationKey, 3, customerOTPPt->nationKey, sizeof(int), cntr, aes);
  ctrEncryptString(customerPt->phone, 4, customerOTPPt->phone, strlen(customerPt->phone), cntr, aes);
  ctrEncryptDouble(customerPt->acctBal, 5, customerOTPPt->acctBal, sizeof(double), cntr, aes);
  ctrEncryptString(customerPt->mktSegment, 6, customerOTPPt->mktSegment, strlen(customerPt->mktSegment), cntr, aes);
  ctrEncryptString(customerPt->comment, 7, customerOTPPt->comment, strlen(customerPt->comment), cntr, aes);
  /* OPE value direct copy, no decryption */
  customerOTPPt->custKeyOPE = customerPt->custKeyOPE;
  customerOTPPt->nationKeyOPE = customerPt->nationKeyOPE;
}

void decryptCustomer(customerOTP *customerOTPPt, customerOTP *customerDecPt, customer *sizePt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE])
{
  ctrDecryptINT(customerOTPPt->custKey, 0, customerDecPt->custKey, sizeof(int), cntr, aes);
  ctrDecryptString(customerOTPPt->name, 1, customerDecPt->name, strlen(sizePt->name), cntr, aes);
  ctrDecryptString(customerOTPPt->address, 2, customerDecPt->address, strlen(sizePt->address), cntr, aes);
  ctrDecryptINT(customerOTPPt->nationKey, 3, customerDecPt->nationKey, sizeof(int), cntr, aes);
  ctrDecryptString(customerOTPPt->phone, 4, customerDecPt->phone, strlen(sizePt->phone), cntr, aes);
  ctrDecryptDouble(customerOTPPt->acctBal, 5, customerDecPt->acctBal, sizeof(double), cntr, aes);
  ctrDecryptString(customerOTPPt->mktSegment, 6, customerDecPt->mktSegment, strlen(sizePt->mktSegment), cntr, aes);
  ctrDecryptString(customerOTPPt->comment, 7, customerDecPt->comment, strlen(sizePt->comment), cntr, aes);
  /* OPE value direct copy, no decryption */
  customerDecPt->custKeyOPE = customerOTPPt->custKeyOPE;
  customerDecPt->nationKeyOPE = customerOTPPt->nationKeyOPE;
}

/* print function */

void printCustomer(customer *customerPt, FILE * ifp)
{
  printInt(ifp, customerPt->custKey, "|");
  printString(ifp, customerPt->name, "|");
  printString(ifp, customerPt->address, "|");
  printInt(ifp, customerPt->nationKey, "|");	
  printString(ifp, customerPt->phone, "|");
  printDouble(ifp, customerPt->acctBal, "|");
  printString(ifp, customerPt->mktSegment, "|");
  printString(ifp, customerPt->comment, "|");
  /* print OPE value */
  printllong(ifp, customerPt->custKeyOPE, "|");
  printllong(ifp, customerPt->nationKeyOPE, "|");
  fprintf(ifp, "\n");
}

void printCustomerOTP(customerOTP *customerOTPPt, customer *sizePt, FILE *ifp)
{
  printBinary(ifp, customerOTPPt->custKey, sizeof(int));
  printBinary(ifp, customerOTPPt->name, strlen(sizePt->name));
  printBinary(ifp, customerOTPPt->address, strlen(sizePt->address));
  printBinary(ifp, customerOTPPt->nationKey, sizeof(int));
  printBinary(ifp, customerOTPPt->phone, strlen(sizePt->phone));
  printBinary(ifp, customerOTPPt->acctBal, sizeof(double));
  printBinary(ifp, customerOTPPt->mktSegment, strlen(sizePt->mktSegment));
  printBinary(ifp, customerOTPPt->comment, strlen(sizePt->comment));
  /* print OPE value */
}	

void printCustomerTemplate(customer *customerPt, FILE * ifp)
{
  printInt(ifp, -96746058, "|");
  printString(ifp, customerPt->name, "|");
  printString(ifp, customerPt->address, "|");
  printInt(ifp, -96746058, "|");	
  printString(ifp, customerPt->phone, "|");
  printDouble(ifp, 24386.67, "|");
  printString(ifp, customerPt->mktSegment, "|");
  printString(ifp, customerPt->comment, "|");
  /* print OPE value */
  printllong(ifp, customerPt->custKeyOPE, "|");
  printllong(ifp, customerPt->nationKeyOPE, "");
  fprintf(ifp, "\n");
}
