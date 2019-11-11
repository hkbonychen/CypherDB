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
#include "supplier.h"
#include "sqlite3modify.h"
#include "supplier_sqlite.h"

void *supplierSchemaGen(char **schema)
{
  char *supplierTable = "create table Supplier(s_suppkey INTEGER, s_name CHAR(25), s_address CHAR(40), s_nationkey INTEGER, s_phone CHAR(15), s_acctbal REAL, s_comment CHAR(101), s_suppkeyIDX INTEGER, s_nationkeyIDX INTEGER);";
  *schema = (char *)malloc((strlen(supplierTable)+1)*sizeof(char));
  memcpy(*schema, supplierTable, strlen(supplierTable)+1);
}

void *supplierTemplateGen(char *directory, float scale)
{
  int count, i;
  supplier *supplier_t;
  char filePath[100];
  FILE *tfp, *ifp;

  strcpy(filePath, directory);
  strcat(filePath, "/supplierTemplate.tbl");
  ifp = fopen(supplierEncFilePath, "r");
  tfp = fopen(filePath, "w");
  count = SUPPLIERMAX*scale;
  supplier_t = (supplier *)calloc(1, sizeof(supplier));
  for (i=0; i<count; i++)
    {
      readSupplier(supplier_t, ifp);
      printSupplierTemplate(supplier_t, tfp);
      freeSupplier(supplier_t);
    }
  free(supplier_t);
  fclose(ifp);
  fclose(tfp);
}

unsigned int modifyPageDataSupplier(unsigned char **pageBuffer, unsigned int recordOffset, supplier* sizePt, supplierOTP* supplierOTPPt, char *encArr)
{
  unsigned int  cursor;

  cursor = recordOffset;
  /* size [0]*/
  memcpy(&((*pageBuffer)[cursor]), supplierOTPPt->suppKey, 4);
  cursor += 4;

  // size [1]
  memcpy(&((*pageBuffer)[cursor]), supplierOTPPt->name, strlen(sizePt->name));
  cursor += strlen(sizePt->name);

  // size [2]
  memcpy(&((*pageBuffer)[cursor]), supplierOTPPt->address, strlen(sizePt->address));
  cursor += strlen(sizePt->address);

  // size [3]
  memcpy(&((*pageBuffer)[cursor]), supplierOTPPt->nationKey, 4);
  cursor += 4;

  // size [4]
  memcpy(&((*pageBuffer)[cursor]), supplierOTPPt->phone, strlen(sizePt->phone));
  cursor += strlen(sizePt->phone);

  // size [5]
  memcpy(&((*pageBuffer)[cursor]), supplierOTPPt->acctBal, 8);
  cursor += 8;

  // size [6]
  memcpy(&((*pageBuffer)[cursor]), supplierOTPPt->comment, strlen(sizePt->comment));
  cursor += strlen(sizePt->comment);

  return 1;
}

int supplierSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, supplier *supplierPt, supplierOTP *supplierOTPPt)
{
  unsigned char *pageBuffer;
  recordPageFrame *recordPagewiseAddr;
  int i, j, pageID, pageCount, cellCount, cellOffset, freeBytesCount, pageCountWrite;
  char encArray[] = {1,1,1,1,1,1,1,0,0};

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
	  /* mainly used to generate the record frame information 
	     have to modify the last entry when a new column is added */
	  cellOffset = getPageData(&pageBuffer, cellOffset, cellCount, &(recordPagewiseAddr->recordRowID[i]), &(recordPagewiseAddr->recordStartingAddr[i]), &(recordPagewiseAddr->recordEndAddr[i]), encArray, SUPPLIERNCOL);
	  /* modify the pageBuffer by storing back the encrypted data in itemOTP */
	  modifyPageDataSupplier(&pageBuffer, recordPagewiseAddr->recordStartingAddr[i], &(supplierPt[recordPagewiseAddr->recordRowID[i]-1]), &(supplierOTPPt[recordPagewiseAddr->recordRowID[i]-1]), encArray);

        }
      /* write back the page_buffer into db_modify */
      writePage(ofp, pageSize, pageBuffer, &pageCountWrite);

      free(recordPagewiseAddr->recordStartingAddr);
      free(recordPagewiseAddr->recordEndAddr);
      free(recordPagewiseAddr->recordRowID);
    }

  fprintf(stderr, "Table Supplier statistic: \n");
  fprintf(stderr, "num of page = %d \n", maxPageCount);
  fprintf(stderr, "read page count = %d \n", pageCount);
  fprintf(stderr, "write page count = %d \n", pageCountWrite);
  fprintf(stderr, "\n");

  return pageCountWrite;

}
