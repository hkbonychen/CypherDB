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
#include "part.h"
#include "sqlite3modify.h"
#include "part_sqlite.h"

void *partSchemaGen(char **schema)
{
  char *partTable = "create table Part(p_partKey INTEGER, p_name CHAR(55), p_mfgr CHAR(25), p_brand CHAR(10), p_type CHAR(25), p_size INTEGER, p_container CHAR(10), p_retailprice REAL, p_comment CHAR(23), p_partKeyOPE INTEGER);";
  *schema = (char *)malloc((strlen(partTable)+1)*sizeof(char));
  memcpy(*schema, partTable, strlen(partTable)+1);
}

void *partTemplateGen(char *directory, float scale)
{
  int count, i;
  part *part_t;
  char filePath[100];
  FILE *tfp, *ifp;
   
  strcpy(filePath, directory);
  strcat(filePath, "/partTemplate.tbl");
  ifp = fopen(partEncFilePath, "r");
  tfp = fopen(filePath, "w");
  count = PARTMAX*scale;
  part_t = (part *)calloc(count, sizeof(part));
  for (i=0; i<count; i++)
    {
      readPart(&part_t[i], ifp);
      printPartTemplate(&part_t[i], tfp);
    }
  fclose(ifp);
  fclose(tfp);
}

unsigned int modifyPageDataPart(unsigned char **pageBuffer, unsigned int recordOffset, part* sizePt, partOTP* partOTPPt, char *encArr)
{
  unsigned int  cursor;
    
  cursor = recordOffset;
  /* size [0]*/
  memcpy(&((*pageBuffer)[cursor]), partOTPPt->partKey, 4);
  cursor += 4;
    	
  // size [1]
  memcpy(&((*pageBuffer)[cursor]), partOTPPt->name, strlen(sizePt->name));
  cursor += strlen(sizePt->name);

  // size [2]
  memcpy(&((*pageBuffer)[cursor]), partOTPPt->mfgr, strlen(sizePt->mfgr));
  cursor += strlen(sizePt->mfgr);

  // size [3]
  memcpy(&((*pageBuffer)[cursor]), partOTPPt->brand, strlen(sizePt->brand));
  cursor += strlen(sizePt->brand);

  // size [4]
  memcpy(&((*pageBuffer)[cursor]), partOTPPt->type, strlen(sizePt->type));
  cursor += strlen(sizePt->type);

  /* size [5]*/
  memcpy(&((*pageBuffer)[cursor]), partOTPPt->size, 4);
  cursor += 4;

  // size [6]
  memcpy(&((*pageBuffer)[cursor]), partOTPPt->container, strlen(sizePt->container));
  cursor += strlen(sizePt->container);

  // size [7]
  memcpy(&((*pageBuffer)[cursor]), partOTPPt->retailPrice, 8);
  cursor += 8;

  // size [8]
  memcpy(&((*pageBuffer)[cursor]), partOTPPt->comment, strlen(sizePt->comment));
  cursor += strlen(sizePt->comment);

  return 1;
}

int partSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, part *partPt, partOTP *partOTPPt)
{
  unsigned char *pageBuffer;
  recordPageFrame *recordPagewiseAddr;
  int i, j, pageID, pageCount, cellCount, cellOffset, freeBytesCount, pageCountWrite;
  char encArray[] = {1,1,1,1,1,1,1,1,1,0};
    
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
	  cellOffset = getPageData(&pageBuffer, cellOffset, cellCount, &(recordPagewiseAddr->recordRowID[i]), &(recordPagewiseAddr->recordStartingAddr[i]), &(recordPagewiseAddr->recordEndAddr[i]), encArray, PARTNCOL);
	  /* modify the pageBuffer by storing back the encrypted data in itemOTP */
	  modifyPageDataPart(&pageBuffer, recordPagewiseAddr->recordStartingAddr[i], &(partPt[recordPagewiseAddr->recordRowID[i]-1]), &(partOTPPt[recordPagewiseAddr->recordRowID[i]-1]), encArray); 
        
        }
      /* write back the page_buffer into db_modify */
      writePage(ofp, pageSize, pageBuffer, &pageCountWrite);

      free(recordPagewiseAddr->recordStartingAddr);
      free(recordPagewiseAddr->recordEndAddr);
      free(recordPagewiseAddr->recordRowID);
    } 
    
  fprintf(stderr, "Table Part statistic: \n");
  fprintf(stderr, "num of page = %d \n", maxPageCount);
  fprintf(stderr, "read page count = %d \n", pageCount);
  fprintf(stderr, "write page count = %d \n", pageCountWrite);
  fprintf(stderr, "\n");
    
  return pageCountWrite;

}


