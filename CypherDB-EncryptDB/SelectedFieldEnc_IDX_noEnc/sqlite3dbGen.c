#include <stdio.h> 
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <openssl/aes.h>

#include "sqlite3.h"
#include "record.h"
#include "utils.h"
#include "dbload.h"
#include "print.h"
#include "crypto.h"
#include "sqlite3modify.h"
#include "tpch_sqlite.h"


void *deleteDBFile(char *directory)
{
    /* detele the input .db file if it exists */
    char dbFilePath[100];

    strcpy(dbFilePath, directory);
    strcat(dbFilePath, "/");
    strcat(dbFilePath, "template.tbl");
    //system("find /home/bony/test_folder/tpch/ -iname '*.db' -exec rm {} \;");
    if (fopen(dbFilePath, "rb"))
        remove(dbFilePath);
    strcpy(dbFilePath, directory);
    strcat(dbFilePath, "/");
    strcat(dbFilePath, "template.db");
    if (fopen(dbFilePath, "rb"))
        remove(dbFilePath);
}

int main(int argc, char **argv)
{
    FILE *ifp, *ofp, *memMap;
    unsigned char *memMapName;
    float scale;
  
    if (argc != 4)
    {
        fprintf(stderr, "Not enought arguments supplied, <program><directory><scale><outputFile>\n");
        return 0;
    }
    
    deleteDBFile(argv[1]);
    /* scale is currently unused in this version
       the number of item is defined as xxxxMAX in 
       each table header file xxx.h */
    scale = atof(argv[2]);
    ofp = fopen(argv[3], "wb");
    tpchSqliteModify(scale, argv[1], 8, ofp);
    fclose(ofp);
 
    return 1;
}
