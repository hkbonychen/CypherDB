#include <stdio.h>
#define PARTMAX 200000
#define PARTNCOL 10
#define partEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/enc/1GB/part.enc"
#define partCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/part.ctr"

void *partSchemaGen(char **schema);
void *partTemplateGen(char *directory, float scale);
int partSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, part *partPt, partOTP *partOTPPt);

