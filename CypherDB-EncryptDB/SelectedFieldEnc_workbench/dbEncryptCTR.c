#include <stdio.h> 
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <openssl/aes.h>

#include "record.h"
#include "utils.h"
#include "lineitem.h"
#include "crypto.h"

int main(int argc, char **argv)
{
	AES_KEY aesex;
	AES_KEY aesdx;
	unsigned char key[AES_BLOCK_SIZE];
	unsigned char seed[AES_BLOCK_SIZE];
	int j;

	if (argc != 3)
	{
		fprintf(stderr, "no enought input arguments, <program><count><table> \n");
		return 0;
	}
	for (j=0; j<16; ++j)
  		key[j] = 32 + j;

	for (j=0; j<16; ++j)
  		seed[j] = 0;
	seed[4] = BytesFromInt(2, 4)[0];
  	seed[5] = BytesFromInt(2, 4)[1];
 	seed[6] = BytesFromInt(2, 4)[2];
  	seed[7] = BytesFromInt(2, 4)[3];
	seed[12] = BytesFromInt(268442784, 4)[0];
	seed[13] = BytesFromInt(268442784, 4)[1];
	seed[14] = BytesFromInt(268442784, 4)[2];
	seed[15] = BytesFromInt(268442784, 4)[3];

	aes_128_init(&aesex, &aesdx, key);
	
	if (!strcmp(argv[2], "lineitem"))
		lineitem_main(atoi(argv[1]), &aesex, seed);
	if (!strcmp(argv[2], "orders"))
		orders_main(atoi(argv[1]), &aesex, seed);
	return 1;
}

