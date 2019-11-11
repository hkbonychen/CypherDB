#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/aes.h>

#include "part.h"
#include "dbload.h"
#include "print.h"
#include "crypto.h"

void partOTP_malloc(partOTP *partOTPPt, part *sizePt)
{
	partOTPPt->partKey = (char *)malloc(sizeof(int));
	partOTPPt->name = (char *)malloc(strlen(sizePt->name)*sizeof(char));
	partOTPPt->mfgr = (char *)malloc(strlen(sizePt->mfgr)*sizeof(char));
	partOTPPt->brand = (char *)malloc(strlen(sizePt->brand)*sizeof(char));
	partOTPPt->type = (char *)malloc(strlen(sizePt->type)*sizeof(char));
	partOTPPt->size = (char *)malloc(sizeof(int));
	partOTPPt->container = (char *)malloc(strlen(sizePt->container)*sizeof(char));
	partOTPPt->retailPrice = (char *)malloc(sizeof(double));
	partOTPPt->comment = (char *)malloc(strlen(sizePt->comment)*sizeof(char));
	/* OPE need not memory allocation */
}

void partOTP_free(partOTP *partOTPPt)
{
	free(partOTPPt->partKey);
	free(partOTPPt->name);
	free(partOTPPt->mfgr);
	free(partOTPPt->brand);
	free(partOTPPt->type);
	free(partOTPPt->size);
	free(partOTPPt->container);
	free(partOTPPt->retailPrice);
	free(partOTPPt->comment);
	/* OPE need not to be freed */
}

void toPartOTP(part* partPt, partOTP* partOTPPt)
{
	int j;
	unsigned char *temp;


	temp = BytesFromInt(partPt->partKey, 4);
	memcpy(partOTPPt->partKey, temp, 4);
	free(temp);

	memcpy(partOTPPt->name, partPt->name, strlen(partPt->name));
	memcpy(partOTPPt->mfgr, partPt->mfgr, strlen(partPt->mfgr));
	memcpy(partOTPPt->brand, partPt->brand, strlen(partPt->brand));
	memcpy(partOTPPt->type, partPt->type, strlen(partPt->type));

	temp = BytesFromInt(partPt->size, 4);
	memcpy(partOTPPt->size, temp, 4);
	free(temp);

	memcpy(partOTPPt->container, partPt->container, strlen(partPt->container));
	
	for (j=0; j<8; j++) 
		partOTPPt->retailPrice[j] = *((char *)(&partPt->retailPrice)+7-j);

	memcpy(partOTPPt->comment, partPt->comment, strlen(partPt->comment));
	/* OPE transfer */
	partOTPPt->partKeyOPE = partPt->partKeyOPE;
}

/* read file function */

void
readPart(part* partPt, FILE* ifp) 
{
	readInt(&(partPt->partKey), ifp);
	readString(&(partPt->name), ifp);
	readString(&(partPt->mfgr), ifp);
	readString(&(partPt->brand), ifp);
	readString(&(partPt->type), ifp);
	readInt(&(partPt->size), ifp);
	readString(&(partPt->container), ifp);
	readDouble(&(partPt->retailPrice), ifp);
	readString(&(partPt->comment), ifp);
	/* read OPE value */
	readllong(&(partPt->partKeyOPE), ifp);
}

void
readPartOTP(partOTP *partOTPPt, part* sizePt, FILE* ifp) 
{
	int i;

	i = fread(partOTPPt->partKey, sizeof(unsigned char), sizeof(int), ifp);
	i = fread(partOTPPt->name, sizeof(unsigned char), strlen(sizePt->name), ifp);
	i = fread(partOTPPt->mfgr, sizeof(unsigned char), strlen(sizePt->mfgr), ifp);
	i = fread(partOTPPt->brand, sizeof(unsigned char), strlen(sizePt->brand), ifp);
	i = fread(partOTPPt->type, sizeof(unsigned char), strlen(sizePt->type), ifp);
	i = fread(partOTPPt->size, sizeof(unsigned char), sizeof(int), ifp);
	i = fread(partOTPPt->container, sizeof(unsigned char), strlen(sizePt->container), ifp);
	i = fread(partOTPPt->retailPrice, sizeof(unsigned char), sizeof(double), ifp);
	i = fread(partOTPPt->comment, sizeof(unsigned char), strlen(sizePt->comment), ifp);
	/* read OPE value missing */
}

/* encryption/decryption function */

void encryptPart(part *partPt, partOTP *partOTPPt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE])
{
	ctrEncryptINT(partPt->partKey, 0, partOTPPt->partKey, sizeof(int), cntr, aes);
	ctrEncryptString(partPt->name, 1, partOTPPt->name, strlen(partPt->name), cntr, aes);
	ctrEncryptString(partPt->mfgr, 2, partOTPPt->mfgr, strlen(partPt->mfgr), cntr, aes);
	ctrEncryptString(partPt->brand, 3, partOTPPt->brand, strlen(partPt->brand), cntr, aes);
	ctrEncryptString(partPt->type, 4, partOTPPt->type, strlen(partPt->type), cntr, aes);
	ctrEncryptINT(partPt->size, 5, partOTPPt->size, sizeof(int), cntr, aes);
	ctrEncryptString(partPt->container, 6, partOTPPt->container, strlen(partPt->container), cntr, aes);
	ctrEncryptDouble(partPt->retailPrice, 7, partOTPPt->retailPrice, sizeof(double), cntr, aes);
	ctrEncryptString(partPt->comment, 8, partOTPPt->comment, strlen(partPt->comment), cntr, aes);
	/* OPE value direct copy, no decryption */
	partOTPPt->partKeyOPE = partPt->partKeyOPE;
}

void decryptPart(partOTP *partOTPPt, partOTP *partDecPt, part *sizePt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE])
{
	ctrDecryptINT(partOTPPt->partKey, 0, partDecPt->partKey, sizeof(int), cntr, aes);
	ctrDecryptString(partOTPPt->name, 1, partDecPt->name, strlen(sizePt->name), cntr, aes);
	ctrDecryptString(partOTPPt->mfgr, 2, partDecPt->mfgr, strlen(sizePt->mfgr), cntr, aes);
	ctrDecryptString(partOTPPt->brand, 3, partDecPt->brand, strlen(sizePt->brand), cntr, aes);
	ctrDecryptString(partOTPPt->type, 4, partDecPt->type, strlen(sizePt->type), cntr, aes);
	ctrDecryptINT(partOTPPt->size, 5, partDecPt->size, sizeof(int), cntr, aes);
	ctrDecryptString(partOTPPt->container, 6, partDecPt->container, strlen(sizePt->container), cntr, aes);
	ctrDecryptDouble(partOTPPt->retailPrice, 7, partDecPt->retailPrice, sizeof(double), cntr, aes);
	ctrDecryptString(partOTPPt->comment, 8, partDecPt->comment, strlen(sizePt->comment), cntr, aes);
	/* OPE value direct copy, no decryption */
	partDecPt->partKeyOPE = partOTPPt->partKeyOPE;
}

/* print function */

void printPart(part * partPt, FILE * ifp)
{
	printInt(ifp, partPt->partKey, "|");
	printString(ifp, partPt->name, "|");
	printString(ifp, partPt->mfgr, "|");
	printString(ifp, partPt->brand, "|");
	printString(ifp, partPt->type, "|");
	printInt(ifp, partPt->size, "|");
	printString(ifp, partPt->container, "|");
	printDouble(ifp, partPt->retailPrice, "|");
	printString(ifp, partPt->comment, "|");
	/* print OPE value */
	printllong(ifp, partPt->partKeyOPE, "|");
	fprintf(ifp, "\n");
}

void printPartOTP(partOTP *partOTPPt, part *sizePt, FILE *ifp)
{
	printBinary(ifp, partOTPPt->partKey, sizeof(int));
	printBinary(ifp, partOTPPt->name, strlen(sizePt->name));
	printBinary(ifp, partOTPPt->mfgr, strlen(sizePt->mfgr));
	printBinary(ifp, partOTPPt->brand, strlen(sizePt->brand));
	printBinary(ifp, partOTPPt->type, strlen(sizePt->type));
	printBinary(ifp, partOTPPt->size, sizeof(int));
	printBinary(ifp, partOTPPt->container, strlen(sizePt->container));
	printBinary(ifp, partOTPPt->retailPrice, sizeof(double));
	printBinary(ifp, partOTPPt->comment, strlen(sizePt->comment));
	/* print OPE value */
	//printBinary(ifp, ordersOTPPt->OrderKeyOPE, sizeof(long long int));
}

void printPartTemplate(part * partPt, FILE * ifp)
{
	printInt(ifp, -96746058, "|");
	printString(ifp, partPt->name, "|");
	printString(ifp, partPt->mfgr, "|");
	printString(ifp, partPt->brand, "|");
	printString(ifp, partPt->type, "|");
	printInt(ifp, -96746058, "|");
	printString(ifp, partPt->container, "|");
	printDouble(ifp, 24386.67, "|");
	printString(ifp, partPt->comment, "|");
	printllong(ifp, partPt->partKeyOPE, "");
	fprintf(ifp, "\n");
}	

