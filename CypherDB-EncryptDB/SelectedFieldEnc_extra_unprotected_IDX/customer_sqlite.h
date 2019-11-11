#include <stdio.h>
#define CUSTOMERMAX 150000
#define CUSTOMERNCOL 10
#define customerEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/CTR_plainIDX/db/enc/1GB/customer.enc"
#define customerCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/customer.ctr"

void *customerSchemaGen(char **schema);
void *customerTemplateGen(char *directory, float scale);
int customerSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, customer *customerPt, customerOTP *customerOTPPt);

