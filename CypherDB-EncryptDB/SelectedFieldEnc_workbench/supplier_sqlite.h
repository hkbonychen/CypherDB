#include <stdio.h>
#define SUPPLIERMAX 1000
#define SUPPLIERNCOL 9
#define supplierEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/OPE/db/enc/supplier1k.enc"
#define supplierCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/supplier.ctr"

void *supplierSchemaGen(char **schema);
void *supplierTemplateGen(char *directory, float scale);
int supplierSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, supplier *supplierPt, supplierOTP *supplierOTPPt);

