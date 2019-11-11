#include <stdio.h>
#include "tpch_sqlite.h"

#define dbsize_1GB
#define SUPPLIERNCOL 7
#define supplierCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/supplier.ctr"

#ifdef dbsize_100MB
	#define SUPPLIERMAX 1000
	#define supplierEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/100MB/supplier.tbl"
#endif

#ifdef dbsize_500MB
	#define SUPPLIERMAX 5000
	#define supplierEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/500MB/supplier.tbl"
#endif

#ifdef dbsize_1GB
	#define SUPPLIERMAX 10000
	#define supplierEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/1GB/supplier.tbl"
#endif

void *supplierSchemaGen(char **schema);
void *supplierTemplateGen(char *directory, float scale);
int supplierSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, supplier *supplierPt, supplierOTP *supplierOTPPt);
