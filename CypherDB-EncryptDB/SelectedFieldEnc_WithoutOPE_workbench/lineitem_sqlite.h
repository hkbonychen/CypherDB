#include <stdio.h>
#define ITEMMAX 600572
#define ITEMNCOL 16
#define itemEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/OPE/db/tbl/100MB/lineitem.tbl"
#define itemCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/lineitem.ctr"

void *itemSchemaGen(char **schema);
void *itemTemplateGen(char *directory, float scale);
int itemSqliteModify(FILE *ifp, FILE *ofp, int dataPageSize, int maxPageCount, lineitem *itemPt, lineitemOTP *itemOTPPt);

