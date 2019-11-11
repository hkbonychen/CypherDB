#include <stdio.h>
#define ITEMMAX 600572
#define ITEMNCOL 19
#define itemEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/OPE/db/enc/lineitem600k.enc"
#define itemCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/lineitem.ctr"

void *itemSchemaGen(char **schema);
void *itemTemplateGen(char *directory, float scale);
int itemSqliteModify(FILE *ifp, FILE *ofp, int dataPageSize, int maxPageCount, lineitem *itemPt, lineitemOTP *itemOTPPt);

