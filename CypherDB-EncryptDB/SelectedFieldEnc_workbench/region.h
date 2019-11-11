#include <stdio.h>

typedef struct _region {
  int regionKey;
  char *name;
  char *comment;
  long long int regionKeyOPE;
} region;

typedef struct _regionOTP {
  char *regionKey;
  char *name;
  char *comment;
  long long int regionKeyOPE;
} regionOTP;

void regionOTP_malloc(regionOTP *regionOTPPt, region *sizePt);
void regionOTP_free(regionOTP *regionOTPPt);
void toRegionOTP(region *regionPT, regionOTP *regionOTPPt);
void readRegion(region* regionPt, FILE* ifp);
void readRegionOTP(regionOTP *regionOTPPt, region* sizePt, FILE* ifp);
void encryptRegion(region *regionPt, regionOTP *regionOTPPt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE]);
void decryptRegion(regionOTP *regionOTPPt, regionOTP *regionDecPt, region *sizePt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE]);
void printRegion(region *regionPt, FILE * ifp);
void printRegionOTP(regionOTP *regionOTPPt, region *sizePt, FILE *ifp);

