#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>
#include "record.h"
#include "sqlite3modify.h"

int callback(void *NotUsed, int argc, char **argv, char **azColName)
{
    int i;
    for(i=0; i<argc; i++)
    {
        printf("%s = %s\n", azColName[i], argv[i] ? argv[i] : "NULL");
    }
    printf("\n");
    return 0;
}

int getVarint32(const unsigned char *p, unsigned int *v){
  unsigned int x;
  int n;
  unsigned char c;
  if( ((signed char*)p)[0]>=0 ){
    *v = p[0];
    return 1;
  }
  x = p[0] & 0x7f;
  if( ((signed char*)p)[1]>=0 ){
    *v = (x<<7) | p[1];
    return 2;
  }
  x = (x<<7) | (p[1] & 0x7f);
  n = 2;
  do{
    x = (x<<7) | ((c = p[n++])&0x7f);
  }while( (c & 0x80)!=0 && n<9 );
  *v = x;
  return n;
}

void printData(unsigned char *data, unsigned int size, columnDataType dataType)
{
    unsigned char* container;
    long double f1;
    char* pEnd;
    unsigned int i;
    
    if (dataType == integer)
        printf("%d|", IntFromBytes(data,size));
    if (dataType == doubleFloat)
    {
        container = (unsigned char*)calloc(size, sizeof(unsigned char));
        for (i=0;i<8;i++) container[i] = data[i];
        //printHex(stdout, container, 8);
        //printf("|");
        //f1 = *(long double*)(container);
        //printf("%Lf|", f1);
        free(container);
    }
    if (dataType == zero)
        printf("0|");
    if (dataType == one)
        printf("1|");
    if (dataType == string)
    {
        container = (unsigned char*)calloc(size, sizeof(unsigned char));
        for (i=0;i<size;i++) container[i] = data[i];
        printf("%s|", container);
        free(container);
    }
}

void payloadHdr(unsigned int col, unsigned int *size, columnDataType *dataType)
{
	unsigned int serialType;
	int columnByte;

	if (col==0) { *size = 0; *dataType = Nil;};
	if (col==1) { *size = 1; *dataType = integer;};
	if (col==2) { *size = 2; *dataType = integer;};
	if (col==3) { *size = 3; *dataType = integer;};
	if (col==4) { *size = 4; *dataType = integer;};
	if (col==5) { *size = 6; *dataType = longInt;};
	if (col==6) { *size = 8; *dataType = longInt;};
	if (col==7) { *size = 8; *dataType = doubleFloat;};
	if (col==8) { *size = 0; *dataType = zero;};
	if (col==9) { *size = 0; *dataType = one;};
	if (col==10) { *size = 0; *dataType = Nil;};
	if (col==11) { *size = 0; *dataType = Nil;};
    if ((col>=12) && (col % 2 == 0))
        { *size = (col-12)/2; *dataType = BLOB;}
    if ((col>=13) && (col % 2 == 1))
        { *size = (col-13)/2; *dataType = string;}
	//printf("serial type = %d \n", serialType);
}

void getDBHeader(FILE *db, unsigned int * pageSize, unsigned int * numOfPage)
{
	int i;
	unsigned char *buffer;
	unsigned char *pageSizeBuffer, *numOfPageBuffer;

	buffer = (unsigned char *)calloc(1, sizeof(unsigned char));
	pageSizeBuffer = (unsigned char *)calloc(2, sizeof(unsigned char));
    	numOfPageBuffer = (unsigned char *)calloc(4, sizeof(unsigned char));
	for (i=0;i<16;i++)
		fread(buffer, sizeof(unsigned char), 1, db);
	fread(pageSizeBuffer, sizeof(unsigned char), 2, db);
	*pageSize = IntFromBytes(pageSizeBuffer, 2);
        for (i=0;i<10;i++)
		fread(buffer, sizeof(unsigned char), 1, db);
    	fread(numOfPageBuffer, sizeof(unsigned char), 4, db);
    	*numOfPage = IntFromBytes(numOfPageBuffer, 4);
	free(pageSizeBuffer);
    	free(numOfPageBuffer);
	free(buffer);
}

void readPage(FILE *db, int pageSize, unsigned char *pageBuffer, int * pageCount)
{
	fread(pageBuffer, sizeof(unsigned char), pageSize, db);
	(*pageCount)++;
}

void writePage(FILE *db, int pageSize, unsigned char *pageBuffer, int *pageCount)
{
    fwrite(pageBuffer, sizeof(unsigned char), pageSize, db);
    (*pageCount)++;
}

unsigned int isDataPage(unsigned char *pageBuffer)
{
	return ((*pageBuffer)==13)? 1:0;
}

int getDataPage(FILE *db, int pageSize, int pageCount)
{
	int i;
	unsigned char *pageBuffer;
	unsigned char *buffer;

	buffer = (unsigned char *)calloc(1, sizeof(unsigned char));
	pageBuffer = (unsigned char *)calloc(pageSize, sizeof(unsigned char));
	for (i=0;i<pageCount;i++)
		fread(buffer, sizeof(unsigned char), pageSize, db);
	i=0;
	do {
		fread(buffer, sizeof(unsigned char), 1, db);
		if ((*buffer)!=13) 
			fread(pageBuffer, sizeof(unsigned char), pageSize-1, db);
		i++;
	} while((*buffer)!=13);
	free(buffer);
	free(pageBuffer);
	return i;
}

void getDataPageHeader(unsigned char *pageBuffer, int *pageID, int *cellCount, int *cellOffset, int *freeBytesCount)
{
	unsigned int dataPageCheck;

	if (IntFromBytes(&pageBuffer[0], 1) != 13)
	{
		printf("Error! This is not a data page! \n");
		return;
	}
	*pageID = IntFromBytes(&pageBuffer[1], 2);
    //printf("free offset = %d \n", *freeOffset);
	*cellCount = IntFromBytes(&pageBuffer[3], 2);
	*cellOffset = IntFromBytes(&pageBuffer[5], 2);
	*freeBytesCount = IntFromBytes(&pageBuffer[7], 1);
}

unsigned int getPageData(unsigned char **pageBuffer, int Offset, int Count, unsigned int * rowID, unsigned int * startingAddr, unsigned int * endAddr, char *encArr, int columnNum)
{
	int i, bytesRead;
	unsigned int payloadLength, unused, cursor;
	unsigned int *columnLen, *size;
	columnDataType *columnType;

	columnLen = (unsigned int *)calloc(columnNum, sizeof(unsigned int));
	size = (unsigned int *)calloc(columnNum, sizeof(unsigned int));
	columnType = (columnDataType *)calloc(columnNum, sizeof(columnDataType));

	/* payload is organized like
	   payload length -> rowID -> unused byte -> payload header -> real record */

	/* read the payload length and rowID */
	cursor = Offset;
	bytesRead = getVarint32(&(*pageBuffer)[cursor], &payloadLength);
	cursor += bytesRead;
	bytesRead = getVarint32(&(*pageBuffer)[cursor], rowID);
	cursor += bytesRead;
	bytesRead = getVarint32(&(*pageBuffer)[cursor], &unused);
	cursor += bytesRead;
    
	/* read the payload header and store them into the header array*/
   	for (i=0;i<columnNum;i++)
	{
		bytesRead = getVarint32(&(*pageBuffer)[cursor], &columnLen[i]);
		payloadHdr(columnLen[i], &size[i], &columnType[i]);
		if (encArr[i]) {
		  switch (columnLen[i])
		  {
		  case 4:
		    (*pageBuffer)[cursor] = 10;
		    break;
		  case 7:
		    (*pageBuffer)[cursor] = 11;
		    break;
		  default:
		    break;
		  }
		}	 
		cursor += bytesRead;
	}
    
	/* start reading the actual db record */
	*startingAddr = cursor;
	for (i=0; i<columnNum; i++)
	{
        	//printHex(stdout, &(*pageBuffer)[cursor], 1);
		//printData(&(*pageBuffer)[cursor], size[i], columnType[i]);
		cursor += size[i];
	}
    	*endAddr = cursor-1;
	//printf("rowID = %d \n", rowID);
    	free(columnLen);
	free(size);
	free(columnType);
    return cursor;
	
}

