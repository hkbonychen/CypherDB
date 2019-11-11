#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "dbload.h"
#define NBYTES 256

void readLine(char** dest, FILE *src)
{

	char temp[NBYTES];	
	int cnt = 0;
	char c;
	do{
	c = fgetc(src);
	if (c!='|') temp[cnt] = c;
		cnt++;
	}while(c != '|');
	temp[cnt-1] = '\0';	
	(*dest) = (char*) malloc(cnt*sizeof(char));

	cnt=0;
	do{
		(*dest)[cnt] = temp[cnt];
		cnt++;
	}while(temp[cnt]!='\0');

	(*dest)[cnt] = '\0';
}

void readInt(int *value, FILE *src)
{
	char* temp;
	
	readLine(&temp, src);
	*value = atoi(temp);
	free(temp);
}

void readllong(long long int *value, FILE *src)
{
	char* temp;
	
	readLine(&temp, src);
	*value = atoll(temp);
	free(temp);
}

void readDouble(double *value,FILE *src)
{
	char* temp;

	readLine(&temp, src);
	*value = atof(temp);
	free(temp);
}

void readString(char **string, FILE *src)
{
	char *temp;
	int i;

	readLine(&temp, src);
	(*string) = (char *)malloc((strlen(temp)+1)*sizeof(char));
	memcpy((*string), temp, (strlen(temp)+1));
	free(temp);
}
