#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "print.h"

void printHex(FILE *ifp, unsigned char* bytes, int length)
{
	int j;
	for (j=0; j<length; ++j) 
    	    fprintf(ifp, "%x%x", (bytes[j] >> 4) & 0xf, bytes[j] & 0xf);    
    	fprintf(ifp, "| \n");
}

void printInt(FILE *ifp, int value, char *separator)
{
	fprintf(ifp, "%d", value);
	fprintf(ifp, "%s", separator);
}

void printllong(FILE *ifp, long long int value, char *separator)
{
	fprintf(ifp, "%lld", value);
	fprintf(ifp, "%s", separator);
}

void printDouble(FILE *ifp, double value, char *separator)
{
	fprintf(ifp, "%.2f", value);
	fprintf(ifp, "%s",separator);
}

void printString(FILE *ifp, char* string, char *separator)
{
	fprintf(ifp, "%s", string);
	fprintf(ifp, "%s", separator);
}

void printBinary(FILE *ifp, char *output, int length)
{
	fwrite(output, sizeof(char), length, ifp);
}



