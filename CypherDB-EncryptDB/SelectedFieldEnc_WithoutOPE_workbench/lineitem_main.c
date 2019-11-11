#include <stdio.h> 
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <openssl/aes.h>

#include "record.h"
#include "utils.h"
#include "lineitem.h"
#include "crypto.h"

void * lineitem_main(int count, AES_KEY *aes, unsigned char seed[AES_BLOCK_SIZE])
{
	
	int choice, i,j;

	printf("OTP Encryption and Decryption function:\n");
	printf("[1] OTP Encryption of lineitem\n");
	printf("[2] OTP Decryption of lineitem\n");
	printf("[3] Rewrite lineitem\n");
	printf("Please select your choice: ");

	i = scanf("%d",&choice);
  
  if (choice == 1) 
  {
	  	FILE *ifp = fopen("/home/bony/db/encrypt_check/lineitem.tbl", "r");
	  	FILE *ofp = fopen("/home/bony/db/encrypt_check/lineitem.ctr", "wb");
  	  	lineitem *item;	  
		lineitemOTP *itemOTP;

		  item = (lineitem *)malloc(count*sizeof(lineitem));
		  itemOTP = (lineitemOTP *)malloc(count*sizeof(lineitemOTP));
		  for (i=0; i<count; i++)
		  {
		     	readItem(&item[i], ifp);
			itemOTP_malloc(&itemOTP[i], &item[i]);
			encryptItem(&item[i], &itemOTP[i], aes, seed);
			incr_row_128(seed, 1);
			printItemOTP(&itemOTP[i], &item[i], ofp);
		  }
		  fclose(ifp); 
		  fclose(ofp);	
		  free(item);	
		  free(itemOTP);
		  printf("Encryption of %d items is done!\n", count);
  }

  if (choice == 2) 
  {
		FILE *sizefp = fopen("/home/bony/db/encrypt_check/lineitem.tbl", "rb");
	  	FILE *ifp = fopen("/home/bony/db/encrypt_check/lineitem.ctr", "rb");
	  	FILE *ofp = fopen("/home/bony/db/encrypt_check/lineitem.dec", "wb");
  	  	lineitemOTP *itemDec;	  
		lineitem *sizeRef;
		lineitemOTP *itemOTP;

		  itemDec = (lineitemOTP *)malloc(count*sizeof(lineitemOTP));
		  sizeRef = (lineitem *)malloc(count*sizeof(lineitem));
		  itemOTP = (lineitemOTP *)malloc(count*sizeof(lineitemOTP));
		  for (i=0; i<count; i++)
		  {
			readItem(&sizeRef[i], sizefp);
			itemOTP_malloc(&itemOTP[i], &sizeRef[i]);
			itemOTP_malloc(&itemDec[i], &sizeRef[i]);
		     	readItemOTP(&itemOTP[i], &sizeRef[i], ifp);
			decryptItem(&itemOTP[i], &itemDec[i], &sizeRef[i], aes, seed);
			incr_row_128(seed, 1);
			printItemOTP(&itemDec[i], &sizeRef[i], ofp);
		  }
		  fclose(ifp); 
		  fclose(ofp);	
		  fclose(sizefp);
		  free(itemDec);	
		  free(sizeRef);	
		  free(itemOTP);	
		  printf("Decryption of %d items is done!\n", count);
  }

  if (choice == 3) 
  {
	  	FILE *ifp = fopen("/home/bony/db/encrypt_check/lineitem.tbl", "r");
	  	FILE *ofp = fopen("/home/bony/db/encrypt_check/lineitem.ref", "wb");
		lineitem *item;
		lineitemOTP *itemPlain;

		  item = (lineitem *)malloc(count*sizeof(lineitem));
		  itemPlain = (lineitemOTP *)malloc(count*sizeof(lineitemOTP));
		  for (i=0; i<count; i++)
		  {
			readItem(&item[i], ifp);
			itemOTP_malloc(&itemPlain[i], &item[i]);
			toItemOTP(&item[i], &itemPlain[i]);
			printItemOTP(&itemPlain[i], &item[i], ofp);
		  }
		  fclose(ifp); 
		  fclose(ofp);	
		  free(item);
		  free(itemPlain);	
	
		  printf("Rewrite Binary of %d items is done!\n", count);
  }
}
