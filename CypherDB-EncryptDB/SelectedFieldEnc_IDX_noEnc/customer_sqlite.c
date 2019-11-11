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
#include "customer.h"
#include "sqlite3modify.h"
#include "customer_sqlite.h"

void *customerSchemaGen(char **schema)
{
  char *customerTable = "create table Customer(c_custkey INTEGER, c_name CHAR(25), c_address CHAR(40), c_nationkey INTEGER, c_phone CHAR(15), c_acctbal REAL,c_mktsegment CHAR(10),c_comment CHAR(117));";
  *schema = (char *)malloc((strlen(customerTable)+1)*sizeof(char));
  memcpy(*schema, customerTable, strlen(customerTable)+1);
}

void *customerTemplateGen(char *directory, float scale)
{
  int count, i;
  customer customer_t;
  char filePath[100];
  FILE *tfp, *ifp;

  strcpy(filePath, directory);
  strcat(filePath, "/customerTemplate.tbl");
  ifp = fopen(customerEncFilePath, "r");
  tfp = fopen(filePath, "w");
  count = CUSTOMERMAX*scale;
  for (i=0; i<count; i++)
    {
      readCustomer(&customer_t, ifp);
      printCustomerTemplate(&customer_t, tfp);
      customer_free(&customer_t);
    }
  fclose(ifp);
  fclose(tfp);
}

unsigned int modifyPageDataCustomer(unsigned char **pageBuffer, unsigned int recordOffset, customer* sizePt, customerOTP* customerOTPPt, unsigned int *cellsize)
{
  unsigned int  cursor;
  unsigned int bytecount;
  unsigned char *temp; 

  cursor = recordOffset;
  /* size [0]*/
	if (sizePt->custKey > 1) {
  		temp = BytesFromIntCount(sizePt->custKey, cellsize[0]);		
		memcpy(&((*pageBuffer)[cursor]), temp, cellsize[0]);
		cursor += cellsize[0];
		free(temp);
	}

  // size [1]
  memcpy(&((*pageBuffer)[cursor]), customerOTPPt->name, cellsize[1]);
  cursor += cellsize[1];

  // size [2]
  memcpy(&((*pageBuffer)[cursor]), customerOTPPt->address, cellsize[2]);
  cursor += cellsize[2];

  // size [3]
	if (sizePt->nationKey > 1) {
  		temp = BytesFromIntCount(sizePt->nationKey, cellsize[3]);		
		memcpy(&((*pageBuffer)[cursor]), temp, cellsize[3]);
		cursor += cellsize[3];
		free(temp);
	}

  // size [4]
  memcpy(&((*pageBuffer)[cursor]), customerOTPPt->phone, cellsize[4]);
  cursor += cellsize[4];

  // size [5]
  memcpy(&((*pageBuffer)[cursor]), customerOTPPt->acctBal, 8);
  cursor += 8;

  // size [6]
  memcpy(&((*pageBuffer)[cursor]), customerOTPPt->mktSegment, cellsize[6]);
  cursor += cellsize[6];

  // size [7]
  memcpy(&((*pageBuffer)[cursor]), customerOTPPt->comment, cellsize[7]);
  cursor += cellsize[7];

  return 1;
}

int customerSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, customer *customerPt, customerOTP *customerOTPPt)
{
  unsigned char *pageBuffer;
  recordPageFrame *recordPagewiseAddr;
  int i, j, pageID, pageCount, cellCount, cellOffset, freeBytesCount, pageCountWrite;
  unsigned int *cellsize;
  char custEncArray[] = {0,1,1,0,1,1,1,1};

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
	  cellOffset = getPageData(&pageBuffer, cellOffset, cellCount, &(recordPagewiseAddr->recordRowID[i]), &(recordPagewiseAddr->recordStartingAddr[i]), &(recordPagewiseAddr->recordEndAddr[i]), custEncArray, CUSTOMERNCOL, &cellsize);
	  /* modify the pageBuffer by storing back the encrypted data in itemOTP */
	  modifyPageDataCustomer(&pageBuffer, recordPagewiseAddr->recordStartingAddr[i], &(customerPt[recordPagewiseAddr->recordRowID[i]-1]), &(customerOTPPt[recordPagewiseAddr->recordRowID[i]-1]), cellsize);
   	  free(cellsize);
        }
      /* write back the page_buffer into db_modify */
      writePage(ofp, pageSize, pageBuffer, &pageCountWrite);

      free(recordPagewiseAddr->recordStartingAddr);
      free(recordPagewiseAddr->recordEndAddr);
      free(recordPagewiseAddr->recordRowID);
    }

  fprintf(stderr, "Table Customer statistic: \n");
  fprintf(stderr, "num of page = %d \n", maxPageCount);
  fprintf(stderr, "read page count = %d \n", pageCount);
  fprintf(stderr, "write page count = %d \n", pageCountWrite);
  fprintf(stderr, "\n");

  return pageCountWrite;

}