#include <stdio.h>

typedef struct _nation {
  int nationKey;
  char *name;
  int regionKey;
  char *comment;
  long long int nationKeyOPE;
  long long int regionKeyOPE;
} nation;

typedef struct _nationOTP {
  char *nationKey;
  char *name;
  char *regionKey;
  char *comment;
  long long int nationKeyOPE;
  long long int regionKeyOPE;
} nationOTP;

void nationOTP_malloc(nationOTP *nationOTPPt, nation *sizePt);
void nationOTP_free(nationOTP *nationOTPPt);
void toNationOTP(nation *nationPT, nationOTP *nationOTPPt);
void readNation(nation* nationPt, FILE* ifp);
void readNationOTP(nationOTP *nationOTPPt, nation* sizePt, FILE* ifp);
void encryptNation(nation *nationPt, nationOTP *nationOTPPt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE]);
void decryptNation(nationOTP *nationOTPPt, nationOTP *nationDecPt, nation *sizePt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE]);
void printNation(nation *nationPt, FILE * ifp);
void printNationOTP(nationOTP *nationOTPPt, nation *sizePt, FILE *ifp);

