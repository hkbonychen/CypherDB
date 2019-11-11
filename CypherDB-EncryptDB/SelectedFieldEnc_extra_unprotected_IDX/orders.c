#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/aes.h>

#include "orders.h"
#include "dbload.h"
#include "print.h"
#include "crypto.h"

void freeOrders(orders *ordersPt)
{
  free(ordersPt->OrderStatus);
  free(ordersPt->OrderDate);
  free(ordersPt->OrderPriority);
  free(ordersPt->Clerk);
  free(ordersPt->Comment);
}

void ordersOTP_malloc(ordersOTP *ordersOTPPt, orders *sizePt)
{
  ordersOTPPt->OrderKey = (char *)malloc(sizeof(int));
  ordersOTPPt->CustKey = (char *)malloc(sizeof(int));
  ordersOTPPt->OrderStatus = (char *)malloc(strlen(sizePt->OrderStatus));
  ordersOTPPt->TotalPrice = (char *)malloc(sizeof(double));
  ordersOTPPt->OrderDate = (char *)malloc(strlen(sizePt->OrderDate));
  ordersOTPPt->OrderPriority = (char *)malloc(strlen(sizePt->OrderPriority));
  ordersOTPPt->Clerk = (char *)malloc(strlen(sizePt->Clerk));
  ordersOTPPt->ShipPriority = (char *)malloc(sizeof(int));
  ordersOTPPt->Comment = (char *)malloc(strlen(sizePt->Comment));
  /* OPE need not memory allocation */
}

void ordersOTP_free(ordersOTP *ordersOTPPt)
{
  free(ordersOTPPt->OrderKey);
  free(ordersOTPPt->CustKey);
  free(ordersOTPPt->OrderStatus);
  free(ordersOTPPt->TotalPrice);
  free(ordersOTPPt->OrderDate);
  free(ordersOTPPt->OrderPriority);
  free(ordersOTPPt->Clerk);
  free(ordersOTPPt->ShipPriority);
  free(ordersOTPPt->Comment);
  /* OPE need not to be freed */
}

void toOrdersOTP(orders *ordersPT, ordersOTP *ordersOTPPt)
{
  int j;
  unsigned char *temp;
	
  temp = BytesFromInt(ordersPT->OrderKey, 4);
  memcpy(ordersOTPPt->OrderKey, temp, 4);
  free(temp);

  temp = BytesFromInt(ordersPT->CustKey, 4);
  memcpy(ordersOTPPt->CustKey, temp, 4);
  free(temp);

  memcpy(ordersOTPPt->OrderStatus, ordersPT->OrderStatus, strlen(ordersPT->OrderStatus));

  for (j=0; j<8; j++) 
    ordersOTPPt->TotalPrice[j] = *((char *)(&ordersPT->TotalPrice)+7-j);

  memcpy(ordersOTPPt->OrderDate, ordersPT->OrderDate, strlen(ordersPT->OrderDate));
  memcpy(ordersOTPPt->OrderPriority, ordersPT->OrderPriority, strlen(ordersPT->OrderPriority));
  memcpy(ordersOTPPt->Clerk, ordersPT->Clerk, strlen(ordersPT->Clerk));

  temp = BytesFromInt(ordersPT->ShipPriority, 4);
  memcpy(ordersOTPPt->ShipPriority, temp, 4);
  free(temp);

  memcpy(ordersOTPPt->Comment, ordersPT->Comment, strlen(ordersPT->Comment));
  /* OPE transfer */
  ordersOTPPt->OrderKeyOPE = ordersPT->OrderKeyOPE;
  ordersOTPPt->CustKeyOPE = ordersPT->CustKeyOPE;
}

/* read file functions */

void 
readOrders(orders* ordersPt, FILE* ifp)
{
  readInt(&(ordersPt->OrderKey), ifp);
  readInt(&(ordersPt->CustKey), ifp);
  readString(&(ordersPt->OrderStatus), ifp);
  readDouble(&(ordersPt->TotalPrice), ifp);
  readString(&(ordersPt->OrderDate), ifp);
  readString(&(ordersPt->OrderPriority), ifp);
  readString(&(ordersPt->Clerk), ifp);
  readInt(&(ordersPt->ShipPriority), ifp);
  readString(&(ordersPt->Comment), ifp);
  /* read OPE value */
  readllong(&(ordersPt->OrderKeyOPE), ifp);
  readllong(&(ordersPt->CustKeyOPE), ifp);
}

void readOrdersOTP(ordersOTP *ordersOTPPt, orders* sizePt, FILE* ifp) 
{
  int i;

  i = fread(ordersOTPPt->OrderKey, sizeof(unsigned char), sizeof(int), ifp);
  i = fread(ordersOTPPt->CustKey, sizeof(unsigned char), sizeof(int), ifp);
  i = fread(ordersOTPPt->OrderStatus, sizeof(unsigned char), strlen(sizePt->OrderStatus), ifp);
  i = fread(ordersOTPPt->TotalPrice, sizeof(unsigned char), sizeof(double), ifp);	
  i = fread(ordersOTPPt->OrderDate, sizeof(unsigned char), strlen(sizePt->OrderDate), ifp);
  i = fread(ordersOTPPt->OrderPriority, sizeof(unsigned char), strlen(sizePt->OrderPriority), ifp);
  i = fread(ordersOTPPt->Clerk, sizeof(unsigned char), strlen(sizePt->Clerk), ifp);
  i = fread(ordersOTPPt->ShipPriority, sizeof(unsigned char), sizeof(int), ifp);
  i = fread(ordersOTPPt->Comment, sizeof(unsigned char), strlen(sizePt->Comment), ifp);
  /* read OPE value missing */
}

/* encryption/decryption function */

void encryptOrders(orders *ordersPt, ordersOTP *ordersOTPPt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE])
{
  ctrEncryptINT(ordersPt->OrderKey, 0, ordersOTPPt->OrderKey, sizeof(int), cntr, aes);
  ctrEncryptINT(ordersPt->CustKey, 1, ordersOTPPt->CustKey, sizeof(int), cntr, aes);
  ctrEncryptString(ordersPt->OrderStatus, 2, ordersOTPPt->OrderStatus, strlen(ordersPt->OrderStatus), cntr, aes);
  ctrEncryptDouble(ordersPt->TotalPrice, 3, ordersOTPPt->TotalPrice, sizeof(double), cntr, aes);
  ctrEncryptString(ordersPt->OrderDate, 4, ordersOTPPt->OrderDate, strlen(ordersPt->OrderDate), cntr, aes);
  ctrEncryptString(ordersPt->OrderPriority, 5, ordersOTPPt->OrderPriority, strlen(ordersPt->OrderPriority), cntr, aes);
  ctrEncryptString(ordersPt->Clerk, 6, ordersOTPPt->Clerk, strlen(ordersPt->Clerk), cntr, aes);
  ctrEncryptINT(ordersPt->ShipPriority, 7, ordersOTPPt->ShipPriority, sizeof(int), cntr, aes);
  ctrEncryptString(ordersPt->Comment, 8, ordersOTPPt->Comment, strlen(ordersPt->Comment), cntr, aes);
  /* OPE value direct copy, no decryption */
  ordersOTPPt->OrderKeyOPE = ordersPt->OrderKeyOPE;
  ordersOTPPt->CustKeyOPE = ordersPt->CustKeyOPE;
}

void decryptOrders(ordersOTP *ordersOTPPt, ordersOTP *ordersDecPt, orders *sizePt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE])
{
  ctrDecryptINT(ordersOTPPt->OrderKey, 0, ordersDecPt->OrderKey, sizeof(int), cntr, aes);
  ctrDecryptINT(ordersOTPPt->CustKey, 1, ordersDecPt->CustKey, sizeof(int), cntr, aes);
  ctrDecryptString(ordersOTPPt->OrderStatus, 2, ordersDecPt->OrderStatus, strlen(sizePt->OrderStatus), cntr, aes);
  ctrDecryptDouble(ordersOTPPt->TotalPrice, 3, ordersDecPt->TotalPrice, sizeof(double), cntr, aes);
  ctrDecryptString(ordersOTPPt->OrderDate, 4, ordersDecPt->OrderDate, strlen(sizePt->OrderDate), cntr, aes);
  ctrDecryptString(ordersOTPPt->OrderPriority, 5, ordersDecPt->OrderPriority, strlen(sizePt->OrderPriority), cntr, aes);
  ctrDecryptString(ordersOTPPt->Clerk, 6, ordersDecPt->Clerk, strlen(sizePt->Clerk), cntr, aes);
  ctrDecryptINT(ordersOTPPt->ShipPriority, 7, ordersDecPt->ShipPriority, sizeof(int), cntr, aes);
  ctrDecryptString(ordersOTPPt->Comment, 8, ordersDecPt->Comment, strlen(sizePt->Comment), cntr, aes);
  /* OPE value direct copy, no decryption */
  ordersDecPt->OrderKeyOPE = ordersOTPPt->OrderKeyOPE;
  ordersDecPt->CustKeyOPE = ordersOTPPt->CustKeyOPE;
}

/* print function */

void printOrders(orders *ordersPt, FILE * ifp)
{
  printInt(ifp, ordersPt->OrderKey, "|");
  printInt(ifp, ordersPt->CustKey, "|");	
  printString(ifp, ordersPt->OrderStatus, "|");
  printDouble(ifp, ordersPt->TotalPrice, "|");
  printString(ifp, ordersPt->OrderDate, "|");
  printString(ifp, ordersPt->OrderPriority, "|");
  printString(ifp, ordersPt->Clerk, "|");
  printInt(ifp, ordersPt->ShipPriority, "|");
  printString(ifp, ordersPt->Comment, "|");
  /* print OPE value */
  printllong(ifp, ordersPt->OrderKeyOPE, "|");
  printllong(ifp, ordersPt->CustKeyOPE, "|");
  fprintf(ifp, "\n");
}

void printOrdersOTP(ordersOTP *ordersOTPPt, orders *sizePt, FILE *ifp)
{
  printBinary(ifp, ordersOTPPt->OrderKey, sizeof(int));
  printBinary(ifp, ordersOTPPt->CustKey, sizeof(int));
  printBinary(ifp, ordersOTPPt->OrderStatus, strlen(sizePt->OrderStatus));
  printBinary(ifp, ordersOTPPt->TotalPrice, sizeof(double));
  printBinary(ifp, ordersOTPPt->OrderDate, strlen(sizePt->OrderDate));
  printBinary(ifp, ordersOTPPt->OrderPriority, strlen(sizePt->OrderPriority));
  printBinary(ifp, ordersOTPPt->Clerk, strlen(sizePt->Clerk));
  printBinary(ifp, ordersOTPPt->ShipPriority, sizeof(int));
  printBinary(ifp, ordersOTPPt->Comment, strlen(sizePt->Comment));
  /* print OPE value */
  //printBinary(ifp, ordersOTPPt->OrderKeyOPE, sizeof(long long int));
}	

void printOrdersTemplate(orders * ordersPt, FILE * ifp)
{
  printInt(ifp, -96746058, "|");
  printInt(ifp, -96746058, "|");	
  printString(ifp, ordersPt->OrderStatus, "|");
  printDouble(ifp, 24386.67, "|");
  printString(ifp, ordersPt->OrderDate, "|");
  printString(ifp, ordersPt->OrderPriority, "|");
  printString(ifp, ordersPt->Clerk, "|");
  printInt(ifp, -96746058, "|");
  printString(ifp, ordersPt->Comment, "|");
  /* print OPE value */
  printllong(ifp, ordersPt->OrderKeyOPE, "|");
  printllong(ifp, ordersPt->CustKeyOPE, "");
  fprintf(ifp, "\n");
}
