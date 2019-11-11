#include <stdio.h>
#include "tpch_sqlite.h"

#define dbsize_1GB
#define REGIONNCOL 3
#define regionCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/region.ctr"

#ifdef dbsize_100MB
	#define REGIONMAX 5
	#define regionEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/100MB/region.tbl"
#endif

#ifdef dbsize_500MB
	#define REGIONMAX 5
	#define regionEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/500MB/region.tbl"
#endif

#ifdef dbsize_1GB
	#define REGIONMAX 5
	#define regionEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/1GB/region.tbl"
#endif

void *regionSchemaGen(char **schema);
void *regionTemplateGen(char *directory, float scale);
int regionSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, region *regionPt, regionOTP *regionOTPPt);

