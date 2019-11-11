#include <stdio.h> 
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <openssl/aes.h>

#include "record.h"
#include "utils.h"
#include "orders.h"
#include "crypto.h"

void * orders_main(int count, AES_KEY *aes, unsigned char seed[AES_BLOCK_SIZE])
{
	
	int choice, i,j;

	printf("OTP Encryption and Decryption function:\n");
	printf("[1] OTP Encryption of orders\n");
	printf("[2] OTP Decryption of orders\n");
	printf("[3] Rewrite lineitem\n");
	printf("Please select your choice: ");

	i = scanf("%d",&choice);
  
  if (choice == 1) 
  {
	  	FILE *ifp = fopen("/home/bony/db/encrypt_check/orders.tbl", "r");
	  	FILE *ofp = fopen("/home/bony/db/encrypt_check/orders.ctr", "wb");
  	  	orders *orders_t;
		ordersOTP *ordersOTP_t;

		  orders_t = (orders *)malloc(count*sizeof(orders));
		  ordersOTP_t = (ordersOTP *)malloc(count*sizeof(ordersOTP));
		  for (i=0; i<count; i++)
		  {
			readOrders(&orders_t[i], ifp);
			ordersOTP_malloc(&ordersOTP_t[i], &orders_t[i]);
			encryptOrders(&orders_t[i], &ordersOTP_t[i], aes, seed);
			incr_row_128(seed, 1);
			printOrdersOTP(&ordersOTP_t[i], &orders_t[i], ofp);
		  }
		  fclose(ifp); 
		  fclose(ofp);	
		  free(orders_t);
		  free(ordersOTP_t);	
		  printf("Encryption of %d items is done!\n", count);
  }

  if (choice == 2) 
  {
		FILE *sizefp = fopen("/home/bony/db/encrypt_check/orders.tbl", "r");
	  	FILE *ifp = fopen("/home/bony/db/encrypt_check/orders.ctr", "rb");
	  	FILE *ofp = fopen("/home/bony/db/encrypt_check/orders.dec", "wb");
  	  	ordersOTP *ordersDec_t; 
		orders *sizeRef;
		ordersOTP *ordersOTP_t;

		  ordersDec_t = (ordersOTP *)malloc(count*sizeof(ordersOTP));
		  sizeRef = (orders *)malloc(count*sizeof(orders));
		  ordersOTP_t = (ordersOTP *)malloc(count*sizeof(ordersOTP));
		  for (i=0; i<count; i++)
		  {
			readOrders(&sizeRef[i], sizefp);
			ordersOTP_malloc(&ordersOTP_t[i], &sizeRef[i]);
			ordersOTP_malloc(&ordersDec_t[i], &sizeRef[i]);
		     	readOrdersOTP(&ordersOTP_t[i], &sizeRef[i], ifp);
			decryptOrders(&ordersOTP_t[i], &ordersDec_t[i], &sizeRef[i], aes, seed);
			incr_row_128(seed, 1);
			printOrdersOTP(&ordersDec_t[i], &sizeRef[i], ofp);
		  }
		  fclose(ifp); 
		  fclose(ofp);	
		  fclose(sizefp);
		  free(ordersDec_t);	
		  free(sizeRef);	
		  free(ordersOTP_t);	
		  printf("Decryption of %d items is done!\n", count);
  }

  if (choice == 3) 
  {
	  	FILE *ifp = fopen("/home/bony/db/encrypt_check/orders.tbl", "r");
	  	FILE *ofp = fopen("/home/bony/db/encrypt_check/orders.ref", "wb");
		orders *orders_t;
		ordersOTP *ordersOTP_t;

		  orders_t = (orders *)malloc(count*sizeof(orders));
		  ordersOTP_t = (ordersOTP *)malloc(count*sizeof(ordersOTP));
		  for (i=0; i<count; i++)
		  {
			readOrders(&orders_t[i], ifp);
			ordersOTP_malloc(&ordersOTP_t[i], &orders_t[i]);
			toOrdersOTP(&orders_t[i], &ordersOTP_t[i]);
			printOrdersOTP(&ordersOTP_t[i], &orders_t[i], ofp);
		  }
		  fclose(ifp); 
		  fclose(ofp);	
		  free(orders_t);
		  free(ordersOTP_t);	
	
		  printf("Rewrite Binary of %d orders is done!\n", count);
  }
}
