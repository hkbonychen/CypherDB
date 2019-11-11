#include <stdio.h>

typedef struct _partSupp {
  int partKey;
  int suppKey;
  int availQty;
  double supplyCost;
  char *comment;
  long long int partKeyOPE;
  long long int suppKeyOPE;
} partSupp;

typedef struct _partSuppOTP {
  char *partKey;
  char *suppKey;
  char *availQty;
  char *supplyCost;
  char *comment;
  long long int partKeyOPE;
  long long int suppKeyOPE;
} partSuppOTP;

void freePartSupp(partSupp* partSuppPt);
void partSuppOTP_malloc(partSuppOTP *partSuppOTPPt, partSupp *sizePt);
void partSuppOTP_free(partSuppOTP *partSuppOTPPt);
void toPartSuppOTP(partSupp *partSuppPT, partSuppOTP *partSuppOTPPt);
void readPartSupp(partSupp* partSuppPt, FILE* ifp);
void readPartSuppOTP(partSuppOTP *partSuppOTPPt, partSupp* sizePt, FILE* ifp);
void encryptPartSupp(partSupp *partSuppPt, partSuppOTP *partSuppOTPPt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE]);
void decryptPartSupp(partSuppOTP *partSuppOTPPt, partSuppOTP *partSuppDecPt, partSupp *sizePt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE]);
void printPartSupp(partSupp *partSuppPt, FILE * ifp);
void printPartSuppOTP(partSuppOTP *partSuppOTPPt, partSupp *sizePt, FILE *ifp);

