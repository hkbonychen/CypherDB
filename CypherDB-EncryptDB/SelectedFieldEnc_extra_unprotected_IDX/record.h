
typedef enum columnDataType {
	integer,
    	longInt,
	doubleFloat,
	zero,
	one,
	unUsed,
	BLOB,
	string,
	Nil
} columnDataType;

typedef struct _recordPageFrame{
    unsigned int *recordRowID;
    unsigned int *recordStartingAddr;
    unsigned int *recordEndAddr;
}recordPageFrame;
