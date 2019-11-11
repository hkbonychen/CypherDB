#include <stdio.h>
#define PARTSUPPMAX 800000
#define PARTSUPPNCOL 7
#define partSuppEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/enc/1GB/partsupp.enc"
#define partSuppCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/partsupp.ctr"

void *partSuppSchemaGen(char **schema);
void *partSuppTemplateGen(char *directory, float scale);
int partSuppSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, partSupp *partSuppPt, partSuppOTP *partSuppOTPPt);

