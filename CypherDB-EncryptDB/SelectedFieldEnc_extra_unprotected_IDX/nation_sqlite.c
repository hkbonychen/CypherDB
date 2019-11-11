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
#include "nation.h"
#include "sqlite3modify.h"
#include "nation_sqlite.h"

void *nationSchemaGen(char **schema)
{
  char *nationTable = "create table Nation(n_nationkey INTEGER, n_name CHAR(25), n_regionkey INTEGER, n_comment CHAR(152), n_nationkeyIDX INTEGER, n_regionkeyIDX INTEGER);";
  *schema = (char *)malloc((strlen(nationTable)+1)*sizeof(char));
  memcpy(*schema, nationTable, strlen(nationTable)+1);
}

void *nationTemplateGen(char *directory, float scale)
{
  int count, i;
  nation *nation_t;
  char filePath[100];
  FILE *tfp, *ifp;

  strcpy(filePath, directory);
  strcat(filePath, "/nationTemplate.tbl");
  ifp = fopen(nationEncFilePath, "r");
  tfp = fopen(filePath, "w");
  count = NATIONMAX*1;
  nation_t = (nation *)calloc(1, sizeof(nation));
  for (i=0; i<count; i++)
    {
      readNation(nation_t, ifp);
      printNationTemplate(nation_t, tfp);
      freeNation(nation_t);
    }
  free(nation_t);
  fclose(ifp);
  fclose(tfp);
}

unsigned int modifyPageDataNation(unsigned char **pageBuffer, unsigned int recordOffset, nation* sizePt, nationOTP* nationOTPPt, char *encArr)
{
  unsigned int  cursor;

  cursor = recordOffset;
  /* size [0]*/
  memcpy(&((*pageBuffer)[cursor]), nationOTPPt->nationKey, 4);
  cursor += 4;

  // size [1]
  memcpy(&((*pageBuffer)[cursor]), nationOTPPt->name, strlen(sizePt->name));
  cursor += strlen(sizePt->name);

  // size [2]
  memcpy(&((*pageBuffer)[cursor]), nationOTPPt->regionKey, 4);
  cursor += 4;

  // size [3]
  memcpy(&((*pageBuffer)[cursor]), nationOTPPt->comment, strlen(sizePt->comment));
  cursor += strlen(sizePt->comment);

  return 1;
}

int nationSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, nation *nationPt, nationOTP *nationOTPPt)
{
  unsigned char *pageBuffer;
  recordPageFrame *recordPagewiseAddr;
  int i, j, pageID, pageCount, cellCount, cellOffset, freeBytesCount, pageCountWrite;
  int maxPageCount_t;
  char encArray[] = {1,1,1,1,0,0};

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
	  cellOffset = getPageData(&pageBuffer, cellOffset, cellCount, &(recordPagewiseAddr->recordRowID[i]), &(recordPagewiseAddr->recordStartingAddr[i]), &(recordPagewiseAddr->recordEndAddr[i]),encArray, NATIONNCOL);
	  /* modify the pageBuffer by storing back the encrypted data in itemOTP */
	  modifyPageDataNation(&pageBuffer, recordPagewiseAddr->recordStartingAddr[i], &(nationPt[recordPagewiseAddr->recordRowID[i]-1]), &(nationOTPPt[recordPagewiseAddr->recordRowID[i]-1]), encArray);

        }
      /* write back the page_buffer into db_modify */
      writePage(ofp, pageSize, pageBuffer, &pageCountWrite);

      free(recordPagewiseAddr->recordStartingAddr);
      free(recordPagewiseAddr->recordEndAddr);
      free(recordPagewiseAddr->recordRowID);
    }

  fprintf(stderr, "Table Nation statistic: \n");
  fprintf(stderr, "num of page = %d \n", maxPageCount_t);
  fprintf(stderr, "read page count = %d \n", pageCount);
  fprintf(stderr, "write page count = %d \n", pageCountWrite);
  fprintf(stderr, "\n");

  return pageCountWrite;

}
