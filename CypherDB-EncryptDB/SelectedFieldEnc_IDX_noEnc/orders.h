#include <stdio.h>

typedef struct _orders {
  int OrderKey;
  int CustKey;
  char *OrderStatus;
  double TotalPrice;
  char *OrderDate;
  char *OrderPriority;
  char *Clerk;
  int   ShipPriority;
  char *Comment;
} orders;

typedef struct _ordersOTP {
  char *OrderKey;
  char *CustKey;
  char *OrderStatus;
  char *TotalPrice;
  char *OrderDate;
  char *OrderPriority;
  char *Clerk;
  char *ShipPriority;
  char *Comment;
} ordersOTP;

void ordersOTP_malloc(ordersOTP *ordersOTPPt, orders *sizePt);
void ordersOTP_free(ordersOTP *ordersOTPPt);
void orders_free(orders *ordersPt);
void toOrdersOTP(orders *ordersPT, ordersOTP *ordersOTPPt);
void readOrders(orders* ordersPt, FILE* ifp);
void readOrdersOTP(ordersOTP *ordersOTPPt, orders* sizePt, FILE* ifp);
void encryptOrders(orders *ordersPt, ordersOTP *ordersOTPPt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE]);
void decryptOrders(ordersOTP *ordersOTPPt, ordersOTP *ordersDecPt, orders *sizePt, const AES_KEY *aes, unsigned char cntr[AES_BLOCK_SIZE]);
void printOrders(orders *ordersPt, FILE * ifp);
void printOrdersOTP(ordersOTP *ordersOTPPt, orders *sizePt, FILE *ifp);
void printOrdersTemplate(orders * ordersPt, FILE * ifp);

