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
#include "crypto.h"
#include "lineitem.h"
#include "sqlite3modify.h"
#include "lineitem_sqlite.h"

void *itemSchemaGen(char **schema)
{
    char *itemTable = "create table lineitem(l_orderKey INTEGER, l_partKey INTEGER, l_suppKey INTEGER, l_lineNumber INTEGER, l_quantity INTEGER, l_extendedPrice REAL, l_discount REAL, l_tax REAL, l_returnFlag CHAR(1) NOT NULL, l_lineStatus CHAR(1) NOT NULL, l_shipDate DATETIME, l_commitDate DATETIME, l_receiptDate DATETIME, l_shipInstruct CHAR(25) NOT NULL, l_shipMode CHAR(10) NOT NULL, l_comment CHAR(44) NOT NULL, l_orderKeyOPE INTEGER, l_partKeyOPE INTEGER, l_suppKeyOPE INTEGER);";
    *schema = (char *)malloc((strlen(itemTable)+1)*sizeof(char));
    memcpy(*schema, itemTable, strlen(itemTable)+1);
}

void *itemTemplateGen(char *directory, float scale)
{
    int count, i;
    lineitem *item;
    char filePath[100];
    FILE *tfp, *ifp;
   
    strcpy(filePath, directory);
    strcat(filePath, "/lineitemTemplate.tbl");
    ifp = fopen(itemEncFilePath, "r");
    tfp = fopen(filePath, "w");
    count = ITEMMAX*scale;
    item = (lineitem *)calloc(count, sizeof(lineitem));
    for (i=0; i<count; i++)
    {
        readItem(&item[i], ifp);
        printItemTemplate(&item[i], tfp);
    }
    fclose(ifp);
    fclose(tfp);
}

unsigned int modifyPageDataItem(unsigned char **pageBuffer, unsigned int recordOffset, lineitem* sizePt, lineitemOTP* itemOTPPt, char *encArr)
{
	unsigned int  cursor;
    
	cursor = recordOffset;
	/* size [0]*/
	memcpy(&((*pageBuffer)[cursor]), itemOTPPt->OrderKey, 4);
	cursor += 4;
    
	// size [1]
	memcpy(&((*pageBuffer)[cursor]), itemOTPPt->PartKey, 4);
	cursor += 4;
    
	// size [2]
	memcpy(&((*pageBuffer)[cursor]), itemOTPPt->SuppKey, 4);
	cursor += 4;
    
	// size [3]
	memcpy(&((*pageBuffer)[cursor]), itemOTPPt->LineNum, 4);
	cursor += 4;
    
	// size [4]
	memcpy(&((*pageBuffer)[cursor]), itemOTPPt->Quantity, 4);
	cursor += 4;
    
	// size [5]
	memcpy(&((*pageBuffer)[cursor]), itemOTPPt->ExtendedPrice, 8);
	cursor += 8;
    
	// size [6]
	memcpy(&((*pageBuffer)[cursor]), itemOTPPt->Discount, 8);
	cursor += 8;
    
	// size [7]
	memcpy(&((*pageBuffer)[cursor]), itemOTPPt->Tax, 8);
	cursor += 8;
    
	// size [8]
	memcpy(&((*pageBuffer)[cursor]), itemOTPPt->ReturnFlag, strlen(sizePt->ReturnFlag));
	cursor += strlen(sizePt->ReturnFlag);
    
	// size [9]
	memcpy(&((*pageBuffer)[cursor]), itemOTPPt->LineStatus, strlen(sizePt->LineStatus));
	cursor += strlen(sizePt->LineStatus);
    
	// size [10]
	memcpy(&((*pageBuffer)[cursor]), itemOTPPt->ShipDate, strlen(sizePt->ShipDate));
	cursor += strlen(sizePt->ShipDate);
    
	// size [11]
	memcpy(&((*pageBuffer)[cursor]), itemOTPPt->CommitDate, strlen(sizePt->CommitDate));
	cursor += strlen(sizePt->CommitDate);
    
	// size [12]
	memcpy(&((*pageBuffer)[cursor]), itemOTPPt->ReceiptDate, strlen(sizePt->ReceiptDate));
	cursor += strlen(sizePt->ReceiptDate);
    
	// size [13]
	memcpy(&((*pageBuffer)[cursor]), itemOTPPt->ShipInstruct, strlen(sizePt->ShipInstruct));
	cursor += strlen(sizePt->ShipInstruct);
    
	// size [14]
	memcpy(&((*pageBuffer)[cursor]), itemOTPPt->ShipMode, strlen(sizePt->ShipMode));
	cursor += strlen(sizePt->ShipMode);
    
	// size [15]
	memcpy(&((*pageBuffer)[cursor]), itemOTPPt->Comment, strlen(sizePt->Comment));
	cursor += strlen(sizePt->Comment);
	
	return 1;
}


int itemSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, lineitem *itemPt, lineitemOTP *itemOTPPt)
{
    unsigned char *pageBuffer;
    recordPageFrame *recordPagewiseAddr;
    int i, j, pageID, pageCount, cellCount, cellOffset, freeBytesCount, pageCountWrite;
    char encArray[] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0};

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
	  cellOffset = getPageData(&pageBuffer, cellOffset, cellCount, &(recordPagewiseAddr->recordRowID[i]), &(recordPagewiseAddr->recordStartingAddr[i]), &(recordPagewiseAddr->recordEndAddr[i]), encArray, ITEMNCOL);
            /* modify the pageBuffer by storing back the encrypted data in itemOTP */
	  modifyPageDataItem(&pageBuffer, recordPagewiseAddr->recordStartingAddr[i], &(itemPt[recordPagewiseAddr->recordRowID[i]-1]), &(itemOTPPt[recordPagewiseAddr->recordRowID[i]-1]), encArray); 
        
        }
	/* write back the page_buffer into db_modify */
	writePage(ofp, pageSize, pageBuffer, &pageCountWrite);

        free(recordPagewiseAddr->recordStartingAddr);
        free(recordPagewiseAddr->recordEndAddr);
        free(recordPagewiseAddr->recordRowID);
    } 
    
    fprintf(stderr, "Table lineitem statistic: \n");
    fprintf(stderr, "num of page = %d \n", maxPageCount);
    fprintf(stderr, "read page count = %d \n", pageCount);
    fprintf(stderr, "write page count = %d \n", pageCountWrite);
    fprintf(stderr, "\n");
    
    return pageCountWrite;

}

