#include <stdio.h>

unsigned int SerialType(int value);
void BytesFromInt(unsigned char **result, unsigned int value, unsigned int noBytes);
unsigned char * BytesFromIntCount(int value, unsigned int count);
unsigned char * BytesFromFloat(float value, unsigned int noBytes);
unsigned char * BytesFromDouble(double value, unsigned int noBytes);
unsigned int IntFromBytes(const unsigned char * bytes, unsigned int noBytes);
double DoubleFromBytes(const unsigned char * bytes, unsigned int noBytes);
unsigned int stringlen(unsigned char * string);
int hexlength(unsigned char * string);
void incr_row_128(unsigned char bitstream[AES_BLOCK_SIZE], int value);
void incr_column_128(unsigned char bitstream[AES_BLOCK_SIZE], int value);
