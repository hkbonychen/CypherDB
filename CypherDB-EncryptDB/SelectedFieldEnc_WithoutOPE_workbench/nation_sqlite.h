#include <stdio.h>
#define NATIONMAX 25
#define NATIONNCOL 4
#define nationEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/OPE/db/tbl/100MB/nation.tbl"
#define nationCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/nation.ctr"

void *nationSchemaGen(char **schema);
void *nationTemplateGen(char *directory, float scale);
int nationSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, nation *nationPt, nationOTP *nationOTPPt);

