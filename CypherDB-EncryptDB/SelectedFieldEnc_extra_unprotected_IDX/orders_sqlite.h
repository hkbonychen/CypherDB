#include <stdio.h>
#define ORDERSMAX 1500000
#define ORDERSNCOL 11
#define ordersEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/enc/1GB/orders.enc"
#define ordersCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/orders.ctr"

void *ordersSchemaGen(char **schema);
void *ordersTemplateGen(char *directory, float scale);
int ordersSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, orders *ordersPt, ordersOTP *ordersOTPPt);

