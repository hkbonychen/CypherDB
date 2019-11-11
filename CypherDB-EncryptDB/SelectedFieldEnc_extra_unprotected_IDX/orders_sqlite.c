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
#include "orders.h"
#include "sqlite3modify.h"
#include "orders_sqlite.h"

void *ordersSchemaGen(char **schema)
{
    char *ordersTable = "create table Orders(o_orderKey INTEGER, o_custKey INTEGER, o_orderStatus CHAR(1) NOT NULL, o_totalPrice REAL, o_orderDate DATETIME, o_orderPriority CHAR(15) NOT NULL, o_clerk CHAR(15) NOT NULL, o_shipPriority INTEGER, o_comment CHAR(79) NOT NULL, o_orderKeyIDX INTEGER, o_custKeyIDX INTEGER);";
    *schema = (char *)malloc((strlen(ordersTable)+1)*sizeof(char));
    memcpy(*schema, ordersTable, strlen(ordersTable)+1);
}

void *ordersTemplateGen(char *directory, float scale)
{
    int count, i;
    orders *orders_t;
    char filePath[100];
    FILE *tfp, *ifp;
   
    strcpy(filePath, directory);
    strcat(filePath, "/ordersTemplate.tbl");
    ifp = fopen(ordersEncFilePath, "r");
    tfp = fopen(filePath, "w");
    count = ORDERSMAX*scale;
    orders_t = (orders *)calloc(1, sizeof(orders));
    for (i=0; i<count; i++)
    {
        readOrders(orders_t, ifp);
        printOrdersTemplate(orders_t, tfp);
	freeOrders(orders_t);
    }
    free(orders_t);
    fclose(ifp);
    fclose(tfp);
}

unsigned int modifyPageDataOrders(unsigned char **pageBuffer, unsigned int recordOffset, orders* sizePt, ordersOTP* ordersOTPPt, char *encArr)
{
	unsigned int  cursor;
    
	cursor = recordOffset;
	/* size [0]*/
	memcpy(&((*pageBuffer)[cursor]), ordersOTPPt->OrderKey, 4);
	cursor += 4;
    
	// size [1]
	memcpy(&((*pageBuffer)[cursor]), ordersOTPPt->CustKey, 4);
	cursor += 4;
    
	// size [2]
	memcpy(&((*pageBuffer)[cursor]), ordersOTPPt->OrderStatus, strlen(sizePt->OrderStatus));
	cursor += strlen(sizePt->OrderStatus);

	// size [3]
	memcpy(&((*pageBuffer)[cursor]), ordersOTPPt->TotalPrice, 8);
	cursor += 8;
    
	// size [4]
	memcpy(&((*pageBuffer)[cursor]), ordersOTPPt->OrderDate, strlen(sizePt->OrderDate));
	cursor += strlen(sizePt->OrderDate);

	// size [5]
	memcpy(&((*pageBuffer)[cursor]), ordersOTPPt->OrderPriority, strlen(sizePt->OrderPriority));
	cursor += strlen(sizePt->OrderPriority);

	// size [6]
	memcpy(&((*pageBuffer)[cursor]), ordersOTPPt->Clerk, strlen(sizePt->Clerk));
	cursor += strlen(sizePt->Clerk);

	/* size [7]*/
	memcpy(&((*pageBuffer)[cursor]), ordersOTPPt->ShipPriority, 4);
	cursor += 4;

	// size [8]
	memcpy(&((*pageBuffer)[cursor]), ordersOTPPt->Comment, strlen(sizePt->Comment));
	cursor += strlen(sizePt->Comment);
    
	return 1;
}

int ordersSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, orders *ordersPt, ordersOTP *ordersOTPPt)
{
    unsigned char *pageBuffer;
    recordPageFrame *recordPagewiseAddr;
    int i, j, pageID, pageCount, cellCount, cellOffset, freeBytesCount, pageCountWrite;
    char encArray[] = {1,1,1,1,1,1,1,1,1,0,0};

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
	  cellOffset = getPageData(&pageBuffer, cellOffset, cellCount, &(recordPagewiseAddr->recordRowID[i]), &(recordPagewiseAddr->recordStartingAddr[i]), &(recordPagewiseAddr->recordEndAddr[i]), encArray, ORDERSNCOL);
            /* modify the pageBuffer by storing back the encrypted data in itemOTP */
	  modifyPageDataOrders(&pageBuffer, recordPagewiseAddr->recordStartingAddr[i], &(ordersPt[recordPagewiseAddr->recordRowID[i]-1]), &(ordersOTPPt[recordPagewiseAddr->recordRowID[i]-1]), encArray); 
        
        }
	/* write back the page_buffer into db_modify */
	writePage(ofp, pageSize, pageBuffer, &pageCountWrite);

        free(recordPagewiseAddr->recordStartingAddr);
        free(recordPagewiseAddr->recordEndAddr);
        free(recordPagewiseAddr->recordRowID);
    } 
    
    fprintf(stderr, "Table Orders statistic: \n");
    fprintf(stderr, "num of page = %d \n", maxPageCount);
    fprintf(stderr, "read page count = %d \n", pageCount);
    fprintf(stderr, "write page count = %d \n", pageCountWrite);
    fprintf(stderr, "\n");
    
    return pageCountWrite;

}


