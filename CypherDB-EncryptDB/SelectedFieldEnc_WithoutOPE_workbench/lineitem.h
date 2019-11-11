#include <stdio.h>

typedef struct _lineitem {
  int 	OrderKey;		
  int 	PartKey;		
  int 	SuppKey;		
  int   LineNum;		
  int 	Quantity;		
  double ExtendedPrice;		
  double Discount;		
  double Tax;			
  char  *ReturnFlag;		
  char  *LineStatus;		
  char 	*ShipDate;		
  char 	*CommitDate;		
  char 	*ReceiptDate;	
  char 	*ShipInstruct;	
  char 	*ShipMode;		
  char 	*Comment;		
} lineitem;

typedef struct _lineitemOTP {
  char *OrderKey;		
  char *PartKey;		
  char *SuppKey;	
  char *LineNum;		
  char *Quantity;	
  char *ExtendedPrice;
  char *Discount;
  char *Tax;
  char *ReturnFlag;		
  char *LineStatus;		
  char *ShipDate;		
  char *CommitDate;		
  char *ReceiptDate;		
  char *ShipInstruct;		
  char *ShipMode;		
  char *Comment;		
} lineitemOTP;

void itemOTP_malloc(lineitemOTP *itemOTPPt, lineitem *sizePt);
void itemOTP_free(lineitemOTP *itemOTPPt);
void toItemOTP(lineitem* itemPt, lineitemOTP* itemOTPPt);
void readItem(lineitem* itemPt, FILE* ifp);
void readItemOTP(lineitemOTP *itemOTPPt, lineitem* sizePt, FILE* ifp);
void encryptItem(lineitem *itemPt, lineitemOTP *itemOTPPt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE]);
void decryptItem(lineitemOTP *itemOTPPt, lineitemOTP *itemDecPt, lineitem *sizePt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE]);
void printItem(lineitem * itemPt, FILE * ifp);
void printItemOTP(lineitemOTP *itemOTPPt, lineitem *sizePt, FILE *ifp);
void printItemTemplate(lineitem * itemPt, FILE * ifp);

