#include <stdio.h>
#define PARTMAX 20000
#define PARTNCOL 9
#define partEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/OPE/db/tbl/100MB/part.tbl"
#define partCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/part.ctr"

void *partSchemaGen(char **schema);
void *partTemplateGen(char *directory, float scale);
int partSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, part *partPt, partOTP *partOTPPt);

