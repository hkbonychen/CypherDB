#include <stdio.h>
#define SUPPLIERMAX 10000
#define SUPPLIERNCOL 9
#define supplierEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/enc/1GB/supplier.enc"
#define supplierCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/supplier.ctr"

void *supplierSchemaGen(char **schema);
void *supplierTemplateGen(char *directory, float scale);
int supplierSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, supplier *supplierPt, supplierOTP *supplierOTPPt);

