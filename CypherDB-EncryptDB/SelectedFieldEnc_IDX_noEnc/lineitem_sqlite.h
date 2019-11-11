#include <stdio.h>
#include "tpch_sqlite.h"

#define dbsize_1GB
#define ITEMNCOL 16
#define itemCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/lineitem.ctr"

#ifdef dbsize_100MB
	#define ITEMMAX 600572
	#define itemEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/100MB/lineitem.tbl"
#endif

#ifdef dbsize_500MB
	#define ITEMMAX 2999671
	#define itemEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/500MB/lineitem.tbl"
#endif

#ifdef dbsize_1GB
	#define ITEMMAX 6001215
	#define itemEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/1GB/lineitem.tbl"
#endif

void *itemSchemaGen(char **schema);
void *itemTemplateGen(char *directory, float scale);
int itemSqliteModify(FILE *ifp, FILE *ofp, int dataPageSize, int maxPageCount, lineitem *itemPt, lineitemOTP *itemOTPPt);

