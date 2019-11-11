#include <stdio.h>

typedef struct _supplier {
  int suppKey;
  char *name;
  char *address;
  int nationKey;
  char *phone;
  double acctBal;
  char *comment;
} supplier;

typedef struct _supplierOTP {
  char *suppKey;
  char *name;
  char *address;
  char *nationKey;
  char *phone;
  char *acctBal;
  char *comment;
} supplierOTP;

void supplierOTP_malloc(supplierOTP *supplierOTPPt, supplier *sizePt);
void supplierOTP_free(supplierOTP *supplierOTPPt);
void toSupplierOTP(supplier *supplierPT, supplierOTP *supplierOTPPt);
void readSupplier(supplier* supplierPt, FILE* ifp);
void readSupplierOTP(supplierOTP *supplierOTPPt, supplier* sizePt, FILE* ifp);
void encryptSupplier(supplier *supplierPt, supplierOTP *supplierOTPPt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE]);
void decryptSupplier(supplierOTP *supplierOTPPt, supplierOTP *supplierDecPt, supplier *sizePt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE]);
void printSupplier(supplier *supplierPt, FILE * ifp);
void printSupplierOTP(supplierOTP *supplierOTPPt, supplier *sizePt, FILE *ifp);
void printSupplierTemplate(supplier *supplierPt, FILE * ifp);

