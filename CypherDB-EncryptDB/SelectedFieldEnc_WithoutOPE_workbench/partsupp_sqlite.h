#include <stdio.h>
#define PARTSUPPMAX 80000
#define PARTSUPPNCOL 5
#define partSuppEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/OPE/db/tbl/100MB/partsupp.tbl"
#define partSuppCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/partsupp.ctr"

void *partSuppSchemaGen(char **schema);
void *partSuppTemplateGen(char *directory, float scale);
int partSuppSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, partSupp *partSuppPt, partSuppOTP *partSuppOTPPt);

