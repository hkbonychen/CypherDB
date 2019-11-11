#include <stdio.h>

typedef struct _part {
  int 	partKey;
  char  *name;
  char  *mfgr;
  char  *brand;
  char  *type;
  int 	size;
  char  *container;
  double retailPrice;
  char 	*comment;
  long long int partKeyOPE;
} part;

typedef struct _partOTP {
  char *partKey;		
  char *name;		
  char *mfgr;	
  char *brand;		
  char *type;	
  char *size;
  char *container;
  char *retailPrice;
  char *comment;
  long long int partKeyOPE;
} partOTP;

void partOTP_malloc(partOTP *partOTPPt, part *sizePt);
void partOTP_free(partOTP *partOTPPt);
void topartOTP(part* partPt, partOTP* partOTPPt);
void readPart(part* partPt, FILE* ifp);
void readPartOTP(partOTP *partOTPPt, part* sizePt, FILE* ifp);
void encryptpart(part *partPt, partOTP *partOTPPt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE]);
void decryptpart(partOTP *partOTPPt, partOTP *partDecPt, part *sizePt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE]);
void printpart(part * partPt, FILE * ifp);
void printpartOTP(partOTP *partOTPPt, part *sizePt, FILE *ifp);

