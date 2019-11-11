#include <stdio.h>
#define PARTMAX 20000
#define PARTNCOL 10
#define partEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/OPE/db/enc/part20k.enc"
#define partCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/part.ctr"

void *partSchemaGen(char **schema);
void *partTemplateGen(char *directory, float scale);
int partSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, part *partPt, partOTP *partOTPPt);

