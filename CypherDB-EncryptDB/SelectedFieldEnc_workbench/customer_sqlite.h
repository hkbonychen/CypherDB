#include <stdio.h>
#define CUSTOMERMAX 15000
#define CUSTOMERNCOL 10
#define customerEncFilePath "/home/bony/PhD/CypherDB-database/DBEncryptionv3/OPE/db/enc/customer15k.enc"
#define customerCipherDebugPath "/home/bony/PhD/CypherDB-database/CypherDB_DBRewrite/debug/customer.ctr"

void *customerSchemaGen(char **schema);
void *customerTemplateGen(char *directory, float scale);
int customerSqliteModify(FILE *ifp, FILE *ofp, int pageSize, int maxPageCount, customer *customerPt, customerOTP *customerOTPPt);

