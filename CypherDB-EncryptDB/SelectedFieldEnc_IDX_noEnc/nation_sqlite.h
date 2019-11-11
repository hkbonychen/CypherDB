#include <stdio.h>
#include "tpch_sqlite.h"

#define dbsize_1GB
#define NATIONNCOL 4
#define nationCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/nation.ctr"

#ifdef dbsize_100MB
	#define NATIONMAX 25
	#define nationEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/100MB/nation.tbl"
#endif

#ifdef dbsize_500MB
	#define NATIONMAX 25
	#define nationEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/500MB/nation.tbl"
#endif

#ifdef dbsize_1GB
	#define NATIONMAX 25
	#define nationEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/1GB/nation.tbl"
#endif

void *nationSchemaGen(char **schema);
void *nationTemplateGen(char *directory, float scale);
int nationSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, nation *nationPt, nationOTP *nationOTPPt);

