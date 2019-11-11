#include <stdio.h>
#include "tpch_sqlite.h"

#define dbsize_1GB
#define ORDERSNCOL 9
#define ordersCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/orders.ctr"

#ifdef dbsize_100MB
	#define ORDERSMAX 150000
	#define ordersEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/100MB/orders.tbl"
#endif

#ifdef dbsize_500MB
	#define ORDERSMAX 750000
	#define ordersEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/500MB/orders.tbl"
#endif

#ifdef dbsize_1GB
	#define ORDERSMAX 1500000
	#define ordersEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/1GB/orders.tbl"
#endif

void *ordersSchemaGen(char **schema);
void *ordersTemplateGen(char *directory, float scale);
int ordersSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, orders *ordersPt, ordersOTP *ordersOTPPt);

