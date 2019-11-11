#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <openssl/aes.h>

#include "sqlite3.h"
#include "record.h"
#include "utils.h"
#include "dbload.h"
#include "print.h"
#include "partsupp.h"
#include "sqlite3modify.h"
#include "partsupp_sqlite.h"

void *partSuppSchemaGen(char **schema)
{
  char *partSuppTable = "create table PartSupp(ps_partkey INTEGER, ps_suppkey INTEGER, ps_availqty INTEGER, ps_supplycost REAL, ps_comment CHAR(199));";
  *schema = (char *)malloc((strlen(partSuppTable)+1)*sizeof(char));
  memcpy(*schema, partSuppTable, strlen(partSuppTable)+1);
}

void *partSuppTemplateGen(char *directory, float scale)
{
  int count, i;
  partSupp partSupp_t;
  char filePath[100];
  FILE *tfp, *ifp;

  strcpy(filePath, directory);
  strcat(filePath, "/partSuppTemplate.tbl");
  ifp = fopen(partSuppEncFilePath, "r");
  tfp = fopen(filePath, "w");
  count = PARTSUPPMAX*scale;
  for (i=0; i<count; i++)
    {
      readPartSupp(&partSupp_t, ifp);
      printPartSuppTemplate(&partSupp_t, tfp);
	partSupp_free(&partSupp_t);
    }
  fclose(ifp);
  fclose(tfp);
}

unsigned int modifyPageDataPartSupp(unsigned char **pageBuffer, unsigned int recordOffset, partSupp* sizePt, partSuppOTP* partSuppOTPPt, char *encArr, unsigned int *cellsize)
{
  unsigned int  cursor;
  	unsigned int bytecount;
  	unsigned char *temp;

  cursor = recordOffset;
  /* size [0]*/
	if (sizePt->partKey > 1) {
  		temp = BytesFromIntCount(sizePt->partKey, cellsize[0]);		
		memcpy(&((*pageBuffer)[cursor]), temp, cellsize[0]);
		cursor += cellsize[0];
		free(temp);
	}

  // size [1]
	if (sizePt->suppKey > 1) {
  		temp = BytesFromIntCount(sizePt->suppKey, cellsize[1]);		
		memcpy(&((*pageBuffer)[cursor]), temp, cellsize[1]);
		cursor += cellsize[1];
		free(temp);
	}


  // size [2]
  memcpy(&((*pageBuffer)[cursor]), partSuppOTPPt->availQty, 4);
  cursor += 4;


  // size [3]
  memcpy(&((*pageBuffer)[cursor]), partSuppOTPPt->supplyCost, 8);
  cursor += 8;

  // size [4]
  memcpy(&((*pageBuffer)[cursor]), partSuppOTPPt->comment, cellsize[4]);
  cursor += cellsize[4];

  return 1;
}

int partSuppSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, partSupp *partSuppPt, partSuppOTP *partSuppOTPPt)
{
  unsigned char *pageBuffer;
  recordPageFrame *recordPagewiseAddr;
  int i, j, pageID, pageCount, cellCount, cellOffset, freeBytesCount, pageCountWrite;
  unsigned int *cellsize;
  char encArray[] = {0,0,1,1,1};

  pageCount = 0;
  pageCountWrite = 0;
  pageBuffer = (unsigned char *)calloc(pageSize, sizeof(unsigned char));
  recordPagewiseAddr = (recordPageFrame *)calloc(1, sizeof(recordPageFrame));
  while (pageCount<maxPageCount)
    {
      for(;;)
       	{
	  readPage(ifp, pageSize, pageBuffer, &pageCount);
	  if ((!isDataPage(pageBuffer)) && (pageCount<=maxPageCount))
	    writePage(ofp, pageSize, pageBuffer, &pageCountWrite);
	  else break;
       	}
      if (pageCount > maxPageCount) break;
      getDataPageHeader(pageBuffer, &pageID, &cellCount, &cellOffset, &freeBytesCount);

      /* memory allocation of the recordPagewiseAddr variable */
      recordPagewiseAddr->recordStartingAddr = (unsigned int*)calloc(cellCount, sizeof(unsigned int));
      recordPagewiseAddr->recordEndAddr = (unsigned int*)calloc(cellCount, sizeof(unsigned int));
      recordPagewiseAddr->recordRowID = (unsigned int*)calloc(cellCount, sizeof(unsigned int));

      for (i=0;i<cellCount;i++)
        {
	  /* mainly used to generate the record frame information */
	  cellOffset = getPageData(&pageBuffer, cellOffset, cellCount, &(recordPagewiseAddr->recordRowID[i]), &(recordPagewiseAddr->recordStartingAddr[i]), &(recordPagewiseAddr->recordEndAddr[i]), encArray, PARTSUPPNCOL, &cellsize);
	  /* modify the pageBuffer by storing back the encrypted data in itemOTP */
	  modifyPageDataPartSupp(&pageBuffer, recordPagewiseAddr->recordStartingAddr[i], &(partSuppPt[recordPagewiseAddr->recordRowID[i]-1]), &(partSuppOTPPt[recordPagewiseAddr->recordRowID[i]-1]), encArray, cellsize);
	  free(cellsize);
        }
      /* write back the page_buffer into db_modify */
      writePage(ofp, pageSize, pageBuffer, &pageCountWrite);

      free(recordPagewiseAddr->recordStartingAddr);
      free(recordPagewiseAddr->recordEndAddr);
      free(recordPagewiseAddr->recordRowID);
    }

  fprintf(stderr, "Table PartSupp statistic: \n");
  fprintf(stderr, "num of page = %d \n", maxPageCount);
  fprintf(stderr, "read page count = %d \n", pageCount);
  fprintf(stderr, "write page count = %d \n", pageCountWrite);
  fprintf(stderr, "\n");

  return pageCountWrite;

}