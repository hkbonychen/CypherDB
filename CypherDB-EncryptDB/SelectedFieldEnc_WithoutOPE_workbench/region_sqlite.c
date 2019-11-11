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
#include "region.h"
#include "sqlite3modify.h"
#include "region_sqlite.h"

void *regionSchemaGen(char **schema)
{
  char *regionTable = "create table Region(r_regionkey INTEGER, r_name CHAR(25),  r_comment CHAR(152));";
  *schema = (char *)malloc((strlen(regionTable)+1)*sizeof(char));
  memcpy(*schema, regionTable, strlen(regionTable)+1);
}

void *regionTemplateGen(char *directory, float scale)
{
  int count, i;
  region *regior_t;
  char filePath[100];
  FILE *tfp, *ifp;

  strcpy(filePath, directory);
  strcat(filePath, "/regionTemplate.tbl");
  ifp = fopen(regionEncFilePath, "r");
  tfp = fopen(filePath, "w");
  count = REGIONMAX*1;
  regior_t = (region *)calloc(count, sizeof(region));
  for (i=0; i<count; i++)
    {
      readRegion(&regior_t[i], ifp);
      printRegionTemplate(&regior_t[i], tfp);
    }
  fclose(ifp);
  fclose(tfp);
}

unsigned int modifyPageDataRegion(unsigned char **pageBuffer, unsigned int recordOffset, region* sizePt, regionOTP* regionOTPPt, char *encArr)
{
  unsigned int  cursor;

  cursor = recordOffset;
  /* size [0]*/
  memcpy(&((*pageBuffer)[cursor]), regionOTPPt->regionKey, 4);
  cursor += 4;

  // size [1]
  memcpy(&((*pageBuffer)[cursor]), regionOTPPt->name, strlen(sizePt->name));
  cursor += strlen(sizePt->name);

  // size [2]
  memcpy(&((*pageBuffer)[cursor]), regionOTPPt->comment, strlen(sizePt->comment));
  cursor += strlen(sizePt->comment);

  return 1;
}

int regionSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, region *regionPt, regionOTP *regionOTPPt)
{
  unsigned char *pageBuffer;
  recordPageFrame *recordPagewiseAddr;
  int i, j, pageID, pageCount, cellCount, cellOffset, freeBytesCount, pageCountWrite;
  int maxPageCount_t;
  char encArray[] = {1,1,1};

  pageCount = 0;
  pageCountWrite = 0;
  maxPageCount_t = (!maxPageCount)? 1 : maxPageCount;
  printf("maxPageCount = %d \n", maxPageCount_t);
  pageBuffer = (unsigned char *)calloc(pageSize, sizeof(unsigned char));
  recordPagewiseAddr = (recordPageFrame *)calloc(1, sizeof(recordPageFrame));
  while (pageCount<maxPageCount_t)
    {
      for(;;)
       	{
	  readPage(ifp, pageSize, pageBuffer, &pageCount);
	  if ((!isDataPage(pageBuffer)) && (pageCount<=maxPageCount_t))
	    writePage(ofp, pageSize, pageBuffer, &pageCountWrite);
	  else break;
       	}
      if (pageCount > maxPageCount_t) break;
      getDataPageHeader(pageBuffer, &pageID, &cellCount, &cellOffset, &freeBytesCount);

      /* memory allocation of the recordPagewiseAddr variable */
      recordPagewiseAddr->recordStartingAddr = (unsigned int*)calloc(cellCount, sizeof(unsigned int));
      recordPagewiseAddr->recordEndAddr = (unsigned int*)calloc(cellCount, sizeof(unsigned int));
      recordPagewiseAddr->recordRowID = (unsigned int*)calloc(cellCount, sizeof(unsigned int));

      for (i=0;i<cellCount;i++)
        {
	  /* mainly used to generate the record frame information */
	  cellOffset = getPageData(&pageBuffer, cellOffset, cellCount, &(recordPagewiseAddr->recordRowID[i]), &(recordPagewiseAddr->recordStartingAddr[i]), &(recordPagewiseAddr->recordEndAddr[i]), encArray, REGIONNCOL);
	  /* modify the pageBuffer by storing back the encrypted data in itemOTP */
	  modifyPageDataRegion(&pageBuffer, recordPagewiseAddr->recordStartingAddr[i], &(regionPt[recordPagewiseAddr->recordRowID[i]-1]), &(regionOTPPt[recordPagewiseAddr->recordRowID[i]-1]), encArray);

        }
      /* write back the page_buffer into db_modify */
      writePage(ofp, pageSize, pageBuffer, &pageCountWrite);

      free(recordPagewiseAddr->recordStartingAddr);
      free(recordPagewiseAddr->recordEndAddr);
      free(recordPagewiseAddr->recordRowID);
    }

  fprintf(stderr, "Table Region statistic: \n");
  fprintf(stderr, "num of page = %d \n", maxPageCount_t);
  fprintf(stderr, "read page count = %d \n", pageCount);
  fprintf(stderr, "write page count = %d \n", pageCountWrite);
  fprintf(stderr, "\n");

  return pageCountWrite;

}
