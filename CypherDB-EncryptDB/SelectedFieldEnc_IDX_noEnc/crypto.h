#include <stdio.h>

void *setKey(unsigned char *key);
void *setSeed(unsigned char *seed, int TBID);
void aes_128_init(AES_KEY * aes_enc, AES_KEY * aes_dec, unsigned char key[AES_BLOCK_SIZE]);
void * ctrEncryptINT(int input, int column, char *cipher, int len, unsigned char counter[AES_BLOCK_SIZE], const AES_KEY * aes);
void * ctrEncryptDouble(double input, int column, char *cipher, int len, unsigned char counter[AES_BLOCK_SIZE], const AES_KEY * aes);
void * ctrEncryptString(char* input, int column, char *cipher, int len, unsigned char counter[AES_BLOCK_SIZE], const AES_KEY * aes);
void * ctrDecryptINT(char *input, int column, char *plain, int len, unsigned char counter[AES_BLOCK_SIZE], const AES_KEY * aes);
void * ctrDecryptDouble(char *input, int column, char *plain, int len, unsigned char counter[AES_BLOCK_SIZE], const AES_KEY * aes);
void * ctrDecryptString(char* input, int column, char *plain, int len, unsigned char counter[AES_BLOCK_SIZE], const AES_KEY * aes);


