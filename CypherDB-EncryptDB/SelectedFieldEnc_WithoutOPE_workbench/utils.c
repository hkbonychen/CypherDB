#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/aes.h>

#include "record.h"
#include "utils.h"

#define byte unsigned char

void *doubleToByte(void *dstpp, void *srcpp, unsigned int len)
{
  unsigned long int dstp = (long int) dstpp;
  unsigned long int srcp = (long int) srcpp;

  do									     
    {									     
      size_t __nbytes = (len);					      
      while (__nbytes > 0)						      
	{								      
	  byte __x = ((byte *) srcp)[0];				      
	  srcp += 1;							      
	  __nbytes -= 1;						      
	  ((byte *) (dstp+16-1))[0] = __x;					
	  dstp -= 1;							     
	}								      
    } while (0);
}

void *byteToDouble(void *dstpp, void *srcpp, unsigned int len)
{
  unsigned long int dstp = (long int) dstpp;
  unsigned long int srcp = (long int) srcpp;

  do									      
    {									      
      size_t __nbytes = (len);					      
      while (__nbytes > 0)						      
	{								      
	  byte __x = ((byte *) srcp)[15];				      
	  srcp -= 1;							      
	  __nbytes -= 1;						      
	  ((byte *) (dstp))[0] = __x;					      
	  dstp += 1;							      
	}								      
    } while (0);
}

unsigned char *
BytesFromInt(unsigned int value, unsigned int noBytes)
{
    unsigned char * result;
    int i;
    result = (char *)calloc(noBytes, sizeof(unsigned char));

    for (i = 0; i < noBytes; i++) {
        result[noBytes-i-1] = ((unsigned char) value) % 256;
        value = value / 256;
    }

    return result;
}

unsigned char *
BytesFromFloat(float value, unsigned int noBytes)
{
    //char result[1];
    int i;
    unsigned char * result;
    result = (unsigned char *)calloc(noBytes, sizeof(unsigned char));
      
	*(float *)(&(result[noBytes-4])) = value;
	*(int *)(&(result[noBytes-8])) = 0;
	*(int *)(&(result[noBytes-12])) = 0;
	*(int *)(&(result[noBytes-16])) = 0;

    return (unsigned char *)result;
}

unsigned char *
BytesFromDouble(double value, unsigned int noBytes)
{
    //char result[1];
    int i;
    unsigned char * result;
    result = (unsigned char *)calloc(noBytes, sizeof(unsigned char));
    doubleToByte(result, &value, noBytes);
    return (unsigned char *)result;
}

unsigned int
IntFromBytes(const unsigned char * bytes, unsigned int noBytes)
{
    unsigned int value = 0;
    int i;

    for (i = 0; i < noBytes; i++) {
        unsigned int bval = (unsigned int)bytes[i];
        value = value * 256 + bval;
    }

    return value;
}


double
DoubleFromBytes(const unsigned char * result, unsigned int noBytes)
{
    //char result[1];
    int i;
    double value;
   
    byteToDouble(&value, result, 8);
    return value;
}

unsigned int
stringlen(unsigned char * string)
{
    int len;
    // set the encryption length
    len = 0;
    if ((strlen(string) + 1) % AES_BLOCK_SIZE == 0) {
        len = strlen(string) + 1;
    } else {
        len = ((strlen(string) + 1) / AES_BLOCK_SIZE + 1) * AES_BLOCK_SIZE;
    }
    return len;
}

int
hexlength(unsigned char * string)
{
	int cnt = 0;

 	checkloop:
	while (string[cnt] != '\0')
	{	
    	    	//printf("%x%x", (string[cnt] >> 4) & 0xf, string[cnt] & 0xf);    
		cnt++;	
	} 
	if ((string[cnt+1] == '\0') && (string[cnt+2] == '\0'))
		return cnt;
	else 
	{
		cnt++;
		goto checkloop;
	}
	
}

void incr_row_128(unsigned char bitstream[AES_BLOCK_SIZE], int value)
{
	unsigned int counter;
	unsigned char *temp;
	unsigned char temp2[4];
	int j;


	temp = (unsigned char *)malloc(4);
	temp2[0] = bitstream[15];
	temp2[1] = bitstream[14];
	temp2[2] = bitstream[13];
	temp2[3] = bitstream[12];

	counter = *(int *)(&(temp2[0]));
	counter+=value;
	for (j=0; j<4; ++j) temp[j] = BytesFromInt(counter, 4)[j]; 
	
 	for (j=0; j<4; ++j) 
		bitstream[12+j] = temp[j];
	free(temp);
/*
	for (j=0; j<16; ++j) 
    	    fprintf(stdout, "%x%x", (bitstream[j] >> 4) & 0xf, bitstream[j] & 0xf);    
    	fprintf(stdout, "\n"); 
*/
}

void incr_column_128(unsigned char bitstream[AES_BLOCK_SIZE], int value)
{
	unsigned int counter;
	unsigned char *temp;
	unsigned char temp2[4];
	int j;

	temp = (unsigned char *)malloc(4);
	temp2[0] = bitstream[11];
	temp2[1] = bitstream[10];
	temp2[2] = bitstream[9];
	temp2[3] = bitstream[8];	

	counter = *(int *)(&(temp2[0]));
	counter+=value;
	for (j=0; j<4; ++j) temp[j] = BytesFromInt(counter, 4)[j];

 	for (j=0; j<4; ++j) 
		bitstream[8+j] = temp[j];
	free(temp);
/*
	for (j=0; j<16; ++j) 
    	    fprintf(stdout, "%x%x", (bitstream[j] >> 4) & 0xf, bitstream[j] & 0xf);    
    	fprintf(stdout, "\n"); 
*/
}

unsigned char * zeroPadding(unsigned char* string, int in_len, int out_len)
{
	unsigned char * container;
	int j;
	
	container = (unsigned char *)calloc(out_len, sizeof(unsigned char));
	for (j=0; j < in_len; j++)
		container[out_len-j-1] = string[in_len-j-1];
	return container;
}

unsigned char * leftShifting(unsigned char* string, int in_len, int out_len)
{
	unsigned char * container;
	int j;
	
	container = (unsigned char *)calloc(out_len, sizeof(unsigned char));
	for (j=0; j < out_len; j++)
		container[out_len-j-1] = string[in_len-j-1];
	return container;
}

