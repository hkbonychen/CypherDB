#include <stdio.h>
#include "tpch_sqlite.h"

#define dbsize_1GB
#define CUSTOMERNCOL 8
#define customerCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/customer.ctr"

#ifdef dbsize_100MB
	#define CUSTOMERMAX 15000
	#define customerEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/100MB/customer.tbl"
#endif

#ifdef dbsize_500MB
	#define CUSTOMERMAX 75000
	#define customerEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/500MB/customer.tbl"
#endif

#ifdef dbsize_1GB
	#define CUSTOMERMAX 150000
	#define customerEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/tbl/1GB/customer.tbl"
#endif

void *customerSchemaGen(char **schema);
void *customerTemplateGen(char *directory, float scale);
int customerSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, customer *customerPt, customerOTP *customerOTPPt);

