#include <stdio.h>

int callback(void *NotUsed, int argc, char **argv, char **azColName);
int getVarint32(const unsigned char *p, unsigned int *v);
void printData(unsigned char *data, unsigned int size, columnDataType dataType);
void payloadHdr(unsigned int col, unsigned int *size, columnDataType *dataType);
void getDBHeader(FILE *db, unsigned int * pageSize, unsigned int * numOfPage);
void readPage(FILE *db, int pageSize, unsigned char *pageBuffer, int * pageCount);
void writePage(FILE *db, int pageSize, unsigned char *pageBuffer, int *pageCount);
unsigned int isDataPage(unsigned char *pageBuffer);
int getDataPage(FILE *db, int pageSize, int pageCount);
void getDataPageHeader(unsigned char *pageBuffer, int *pageID, int *cellCount, int *cellOffset, int *freeBytesCount);
unsigned int getPageData(unsigned char **pageBuffer, int Offset, int Count, unsigned int * rowID, unsigned int * startingAddr, unsigned int * endAddr, char *encArr, int columnNum);

