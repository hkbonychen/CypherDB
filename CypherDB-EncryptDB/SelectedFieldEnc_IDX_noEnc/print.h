#include <stdio.h>

void printHex(FILE *ifp, unsigned char* bytes, int length);
void printInt(FILE *ifp, int value, char *separator);
void printllong(FILE *ifp, long long int value, char *separator);
void printDouble(FILE *ifp, double value, char *separator);
void printString(FILE *ifp, char* string, char *separator);
void printBinary(FILE *ifp, char *output, int length);
