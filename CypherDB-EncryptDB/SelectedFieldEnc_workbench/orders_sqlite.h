#include <stdio.h>
#define ORDERSMAX 150000
#define ORDERSNCOL 11
#define ordersEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/OPE/db/enc/orders150k.enc"
#define ordersCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/orders.ctr"

void *ordersSchemaGen(char **schema);
void *ordersTemplateGen(char *directory, float scale);
int ordersSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, orders *ordersPt, ordersOTP *ordersOTPPt);

