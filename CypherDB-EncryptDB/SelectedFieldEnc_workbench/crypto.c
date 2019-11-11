#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/aes.h>

#include "crypto.h"
#include "utils.h"

void *setKey(unsigned char *key)
{
    int j;
    
    for (j=0; j<16; ++j)
        key[j] = 32 + j;
}

void *setSeed(unsigned char *seed, int TBID)
{
    int j;
    
    for (j=0; j<16; ++j)
        seed[j] = 0;
    
    seed[6] = BytesFromInt(TBID, 4)[0];
    seed[7] = BytesFromInt(TBID, 4)[1];
    seed[8] = BytesFromInt(TBID, 4)[2];
    seed[9] = BytesFromInt(TBID, 4)[3];
    seed[12] = BytesFromInt(1, 4)[0];
    seed[13] = BytesFromInt(1, 4)[1];
    seed[14] = BytesFromInt(1, 4)[2];
    seed[15] = BytesFromInt(1, 4)[3];
}

void aes_128_init(AES_KEY * aes_enc, AES_KEY * aes_dec, unsigned char key[AES_BLOCK_SIZE])
{
	if (AES_set_encrypt_key(key, 128, aes_enc) < 0) exit(-1);
	if (AES_set_decrypt_key(key, 128, aes_dec) < 0) exit(-1);
}

void * ctrEncryptINT(int input, int column, char *cipher, int len, unsigned char counter[AES_BLOCK_SIZE], const AES_KEY * aes)
{
	unsigned char ecount_buf[AES_BLOCK_SIZE];
	unsigned char *plain;
	int i;
	
	memcpy(ecount_buf, counter, AES_BLOCK_SIZE);
	plain = BytesFromInt(input,16);
#ifdef debug_int
	fprintf(stdout, "plain: ");
	printHex(stdout, plain, 16);
#endif
	incr_column_128(ecount_buf, column);
#ifdef debug_int
	fprintf(stdout, "seed: ");
	printHex(stdout, ecount_buf, 16);
#endif 
	AES_encrypt(ecount_buf, ecount_buf, aes);
#ifdef debug_int
	fprintf(stdout, "pad: ");
	printHex(stdout, ecount_buf, 16);
#endif
 
	for (i=0;i<len;i++)
		cipher[i] = plain[AES_BLOCK_SIZE-len+i] ^ ecount_buf[i];
#ifdef debug_int
	fprintf(stdout, "cipher: ");
	printHex(stdout, cipher, len);
	fprintf(stdout, "\n");
#endif
	free(plain);
}

void * ctrEncryptDouble(double input, int column, char *cipher, int len, unsigned char counter[AES_BLOCK_SIZE], const AES_KEY * aes)
{
	unsigned char ecount_buf[AES_BLOCK_SIZE];
	unsigned char *plain;
	int i;
	
	memcpy(ecount_buf, counter, AES_BLOCK_SIZE);
	plain = BytesFromDouble(input,16);
#ifdef debug_double
	fprintf(stdout, "plain: ");
	printHex(stdout, plain, 16);
#endif
	incr_column_128(ecount_buf, column);
#ifdef debug_double
	fprintf(stdout, "seed: ");
	printHex(stdout, ecount_buf, 16);
#endif 
	AES_encrypt(ecount_buf, ecount_buf, aes); 
#ifdef debug_double
	fprintf(stdout, "pad: ");
	printHex(stdout, ecount_buf, 16);
#endif
	for (i=0;i<len;i++)
		cipher[i] = plain[AES_BLOCK_SIZE-len+i] ^ ecount_buf[i];
#ifdef debug_double
	fprintf(stdout, "cipher: ");
	printHex(stdout, cipher, len);
	fprintf(stdout, "\n");
#endif
	free(plain);
}

void * ctrEncryptString(char* input, int column, char *cipher, int len, unsigned char counter[AES_BLOCK_SIZE], const AES_KEY * aes)
{
	int loopcnt, i, cursor;
	unsigned char ecount_buf[AES_BLOCK_SIZE];
	
	memcpy(ecount_buf, counter, AES_BLOCK_SIZE);
#ifdef debug_string
	fprintf(stdout, "plain: ");
	printHex(stdout, input, len);
#endif
	incr_column_128(ecount_buf, column);
#ifdef debug_string
	fprintf(stdout, "seed: ");
	printHex(stdout, ecount_buf, 16);
#endif 
	loopcnt = len/16;
	if (len%16 != 0)
		loopcnt++;
	cursor = 0;
	do
	{
		AES_encrypt(ecount_buf, ecount_buf, aes); 
#ifdef debug_string
		fprintf(stdout, "pad: ");
		printHex(stdout, ecount_buf, 16);
#endif
		if (loopcnt > 1)
			for (i=0; i<AES_BLOCK_SIZE; ++i)	
				cipher[cursor+i] = input[cursor+i] ^ ecount_buf[i];
		else if (loopcnt == 1)
			for (i=0; i<(len-cursor); ++i)	
				cipher[cursor+i] = input[cursor+i] ^ ecount_buf[i];
		loopcnt--;
		cursor += AES_BLOCK_SIZE;
#ifdef debug_string
		fprintf(stdout, "cipher: ");
		printHex(stdout, cipher, len);
		fprintf(stdout, "\n");
#endif
	} while (loopcnt > 0);
}

void * ctrDecryptINT(char *input, int column, char *plain, int len, unsigned char counter[AES_BLOCK_SIZE], const AES_KEY * aes)
{
	unsigned char ecount_buf[AES_BLOCK_SIZE];
	int i;
	
	memcpy(ecount_buf, counter, AES_BLOCK_SIZE);
#ifdef debug_int
	fprintf(stdout, "cipher: ");
	printHex(stdout, input, len);
#endif
	incr_column_128(ecount_buf, column);
#ifdef debug_int
	fprintf(stdout, "seed: ");
	printHex(stdout, ecount_buf, 16);
#endif
	AES_encrypt(ecount_buf, ecount_buf, aes); 
#ifdef debug_int
	fprintf(stdout, "pad: ");
	printHex(stdout, ecount_buf, 16);
#endif
	for (i=0;i<len;i++)
		plain[i] = input[i] ^ ecount_buf[i];
#ifdef debug_int
	fprintf(stdout, "plain: ");
	printHex(stdout, plain, len);
	fprintf(stdout, "\n");
#endif
}

void * ctrDecryptDouble(char *input, int column, char *plain, int len, unsigned char counter[AES_BLOCK_SIZE], const AES_KEY * aes)
{
	unsigned char ecount_buf[AES_BLOCK_SIZE];
	int i;
	
	memcpy(ecount_buf, counter, AES_BLOCK_SIZE);
#ifdef debug_double
	fprintf(stdout, "cipher: ");
	printHex(stdout, input, len);
#endif
	incr_column_128(ecount_buf, column);
#ifdef debug_double
	fprintf(stdout, "seed: ");
	printHex(stdout, ecount_buf, 16);
#endif
	AES_encrypt(ecount_buf, ecount_buf, aes); 
#ifdef debug_double
	fprintf(stdout, "pad: ");
	printHex(stdout, ecount_buf, 16);
#endif
	for (i=0;i<len;i++)
		plain[i] = input[i] ^ ecount_buf[i];
#ifdef debug_double
	fprintf(stdout, "plain: ");
	printHex(stdout, plain, len);
	fprintf(stdout, "\n");
#endif
}

void * ctrDecryptString(char* input, int column, char *plain, int len, unsigned char counter[AES_BLOCK_SIZE], const AES_KEY * aes)
{
	int loopcnt, i, cursor;
	unsigned char ecount_buf[AES_BLOCK_SIZE];
	
	memcpy(ecount_buf, counter, AES_BLOCK_SIZE);
#ifdef debug_string
	fprintf(stdout, "cipher: ");
	printHex(stdout, input, len);
#endif
	incr_column_128(ecount_buf, column);
#ifdef debug_string
	fprintf(stdout, "seed: ");
	printHex(stdout, ecount_buf, 16);
#endif
	loopcnt = len/16;
	if (len%16 != 0)
		loopcnt++;
	cursor = 0;
	do
	{
		AES_encrypt(ecount_buf, ecount_buf, aes); 
#ifdef debug_string
		fprintf(stdout, "pad: ");
		printHex(stdout, ecount_buf, 16);
#endif
		if (loopcnt > 1)
			for (i=0; i<AES_BLOCK_SIZE; ++i)	
				plain[cursor+i] = input[cursor+i] ^ ecount_buf[i];
		else if (loopcnt == 1)
			for (i=0; i<len-cursor; ++i)	
				plain[cursor+i] = input[cursor+i] ^ ecount_buf[i];
		loopcnt--;
		cursor += AES_BLOCK_SIZE;
#ifdef debug_string
		fprintf(stdout, "plain: ");
		printHex(stdout, plain, len);
		fprintf(stdout, "\n");
#endif
	} while (loopcnt > 0);
}

