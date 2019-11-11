#include <stdio.h>
#include "tpch_sqlite.h"

#define dbsize_1GB
#define PARTSUPPNCOL 5
#define partSuppCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/partsupp.ctr"

#ifdef dbsize_100MB
	#define PARTSUPPMAX 80000
	#define partSuppEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/100MB/partsupp.tbl"
#endif

#ifdef dbsize_500MB
	#define PARTSUPPMAX 400000
	#define partSuppEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/500MB/partsupp.tbl"
#endif

#ifdef dbsize_1GB
	#define PARTSUPPMAX 800000
	#define partSuppEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/1GB/partsupp.tbl"
#endif

void *partSuppSchemaGen(char **schema);
void *partSuppTemplateGen(char *directory, float scale);
int partSuppSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, partSupp *partSuppPt, partSuppOTP *partSuppOTPPt);

