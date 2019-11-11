#include <stdio.h>
#define REGIONMAX 5
#define REGIONNCOL 4
#define regionEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/enc/1GB/region.enc"
#define regionCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/region.ctr"

void *regionSchemaGen(char **schema);
void *regionTemplateGen(char *directory, float scale);
int regionSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, region *regionPt, regionOTP *regionOTPPt);

