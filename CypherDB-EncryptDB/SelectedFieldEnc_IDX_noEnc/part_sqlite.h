#include <stdio.h>
#include "tpch_sqlite.h"

#define dbsize_1GB
#define PARTNCOL 9
#define partCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/part.ctr"

#ifdef dbsize_100MB
	#define PARTMAX 20000
	#define partEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/100MB/part.tbl"
#endif

#ifdef dbsize_500MB
	#define PARTMAX 100000
	#define partEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/500MB/part.tbl"
#endif

#ifdef dbsize_1GB
	#define PARTMAX 200000
	#define partEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/1GB/part.tbl"
#endif

void *partSchemaGen(char **schema);
void *partTemplateGen(char *directory, float scale);
int partSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, part *partPt, partOTP *partOTPPt);

