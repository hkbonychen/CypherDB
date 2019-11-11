#include <stdio.h>

typedef struct _customer {
  int custKey;
  char *name;
  char *address;
  int nationKey;
  char *phone;
  double acctBal;
  char *mktSegment;
  char *comment;
} customer;

typedef struct _customerOTP {
  char *custKey;
  char *name;
  char *address;
  char *nationKey;
  char *phone;
  char *acctBal;
  char *mktSegment;
  char *comment;
} customerOTP;

void customerOTP_malloc(customerOTP *customerOTPPt, customer *sizePt);
void customerOTP_free(customerOTP *customerOTPPt);
void customer_free(customer *customerPt);
void toCustomerOTP(customer *customerPT, customerOTP *customerOTPPt);
void readCustomer(customer* customerPt, FILE* ifp);
void readCustomerOTP(customerOTP *customerOTPPt, customer* sizePt, FILE* ifp);
void encryptCustomer(customer *customerPt, customerOTP *customerOTPPt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE]);
void decryptCustomer(customerOTP *customerOTPPt, customerOTP *customerDecPt, customer *sizePt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE]);
void printCustomer(customer *customerPt, FILE * ifp);
void printCustomerOTP(customerOTP *customerOTPPt, customer *sizePt, FILE *ifp);
void printCustomerTemplate(customer *customerPt, FILE * ifp);

