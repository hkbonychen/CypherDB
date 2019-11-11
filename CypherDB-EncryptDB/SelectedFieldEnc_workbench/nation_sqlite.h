#include <stdio.h>
#define NATIONMAX 25
#define NATIONNCOL 6
#define nationEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/OPE/db/enc/nation25.enc"
#define nationCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/nation.ctr"

void *nationSchemaGen(char **schema);
void *nationTemplateGen(char *directory, float scale);
int nationSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, nation *nationPt, nationOTP *nationOTPPt);

