#include <stdio.h>

typedef struct _nation {
  int nationKey;
  char *name;
  int regionKey;
  char *comment;
} nation;

typedef struct _nationOTP {
  char *nationKey;
  char *name;
  char *regionKey;
  char *comment;
} nationOTP;

void nationOTP_malloc(nationOTP *nationOTPPt, nation *sizePt);
void nationOTP_free(nationOTP *nationOTPPt);
void nation_free(nation *nationPt);
void toNationOTP(nation *nationPT, nationOTP *nationOTPPt);
void readNation(nation* nationPt, FILE* ifp);
void readNationOTP(nationOTP *nationOTPPt, nation* sizePt, FILE* ifp);
void encryptNation(nation *nationPt, nationOTP *nationOTPPt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE]);
void decryptNation(nationOTP *nationOTPPt, nationOTP *nationDecPt, nation *sizePt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE]);
void printNation(nation *nationPt, FILE * ifp);
void printNationOTP(nationOTP *nationOTPPt, nation *sizePt, FILE *ifp);
void printNationTemplate(nation *nationPt, FILE * ifp);
