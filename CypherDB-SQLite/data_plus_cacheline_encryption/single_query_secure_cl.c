#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sqlite3.h"

#include <sys/time.h>
#include <sys/resource.h>

/* True if the timer is enabled */
static int enableTimer = 1;

/* Return the current wall-clock time */
static sqlite3_int64 timeOfDay(void){
  static sqlite3_vfs *clockVfs = 0;
  sqlite3_int64 t;
  if( clockVfs==0 ) clockVfs = sqlite3_vfs_find(0);
  
  double r;
  clockVfs->xCurrentTime(clockVfs, &r);
  t = (sqlite3_int64)(r*86400000.0);
  return t;
}

/* Saved resource information for the beginning of an operation */
static struct rusage sBegin;
static sqlite3_int64 iBegin;  /* Wall-clock time at start */

/*
** Begin timing an operation
*/
static void beginTimer(void){
  if( enableTimer ){
    getrusage(RUSAGE_SELF, &sBegin);
    iBegin = timeOfDay();
  }
}

/* Return the difference of two time_structs in seconds */
static double timeDiff(struct timeval *pStart, struct timeval *pEnd){
  return (pEnd->tv_usec - pStart->tv_usec)*0.000001 + 
         (double)(pEnd->tv_sec - pStart->tv_sec);
}

/*
** Print the timing results.
*/
static void endTimer(void){
  if( enableTimer ){
    sqlite3_int64 iEnd = timeOfDay();
    struct rusage sEnd;
    getrusage(RUSAGE_SELF, &sEnd);
    printf("\nRun Time: real %.3f user %f sys %f\n",
       (iEnd - iBegin)*0.001,
       timeDiff(&sBegin.ru_utime, &sEnd.ru_utime),
       timeDiff(&sBegin.ru_stime, &sEnd.ru_stime));
  }
}
#define BEGIN_TIMER beginTimer()
#define END_TIMER endTimer()
#define HAS_TIMER 1

static int callback(void *NotUsed, int argc, char **argv, char **azColName){
  int i;
  for(i=0; i<argc; i++){
    printf("%s|", argv[i] ? argv[i] : "NULL");
  }
//  printf("\n");
  return 0;
}

int main(int argc, char **argv){
  char *heap = malloc(1);
  char cmd[40];
  char buf[10];
  int ret;
  sqlite3 *db;
  char *zErrMsg = 0;
  sqlite3_stmt *stmt, *stmt2;
  const char *pzTest;
  char buffer[10];
  char *szSQL;
  int rc, i, stack_top, heap_top;
  int rowid, linenum;

  extern unsigned short int *tb_cntr[8];

  ret = getpid();
  printf("pid = %d \n", ret);
  sprintf(buf, "%d", ret);
  strcpy(cmd, "/bin/cat /proc/");
  strcat(cmd, buf);
  strcat(cmd, "/maps");
  printf("cmd = %s \n", cmd);

  system(cmd);

  stack_top = &i;
//stack_top = 0xc0000000;
  stack_top = stack_top >> 4;
  stack_top = stack_top << 4;

  heap_top = heap;
//heap_top = 0x00000000;
  heap_top = heap_top >> 4;
  heap_top = heap_top << 4;

 // printf( "heap:%p stack:%p\n", heap, &i);
  printf( "heap:%x stack:%x\n", heap_top, stack_top);
  free(heap);

  tb_cntr[0] = (unsigned short int *)malloc(tb1MAX * sizeof(unsigned short int));
  tb_cntr[1] = (unsigned short int *)malloc(tb2MAX * sizeof(unsigned short int));
  tb_cntr[2] = (unsigned short int *)malloc(tb3MAX * sizeof(unsigned short int));
  tb_cntr[3] = (unsigned short int *)malloc(tb4MAX * sizeof(unsigned short int));
  tb_cntr[4] = (unsigned short int *)malloc(tb5MAX * sizeof(unsigned short int));
  tb_cntr[5] = (unsigned short int *)malloc(tb6MAX * sizeof(unsigned short int));
  tb_cntr[6] = (unsigned short int *)malloc(tb7MAX * sizeof(unsigned short int));
  tb_cntr[7] = (unsigned short int *)malloc(tb8MAX * sizeof(unsigned short int));

  for (i=0; i< tb1MAX; i++)
	tb_cntr[0][i] = 0;
  for (i=0; i< tb2MAX; i++)
	tb_cntr[1][i] = 0;
  for (i=0; i< tb3MAX; i++)
	tb_cntr[2][i] = 0;
  for (i=0; i< tb4MAX; i++)
	tb_cntr[3][i] = 0;
  for (i=0; i< tb5MAX; i++)
	tb_cntr[4][i] = 0;
  for (i=0; i< tb6MAX; i++)
	tb_cntr[5][i] = 0;
  for (i=0; i< tb7MAX; i++)
	tb_cntr[6][i] = 0;
  for (i=0; i< tb8MAX; i++)
	tb_cntr[7][i] = 0;

  asm volatile ("l.start\t\t%0,%1,0": : "r" (stack_top), "r" (heap_top));
  
  if( argc!=3 ){
    fprintf(stderr, "Usage: %s DATABASE SQL-STATEMENT\n", argv[0]);
    return(1);
  }
  rc = sqlite3_open(argv[1], &db);
  if( rc ){
    fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
    sqlite3_close(db);
    return(1);
  }
    
//  rc = sqlite3_exec(db, "PRAGMA journal_mode=off;", callback, 0, &zErrMsg);
//  rc = sqlite3_exec(db, "PRAGMA synchronous=0;", callback, 0, &zErrMsg);
//  rc = sqlite3_exec(db, "PRAGMA page_size = 4096;", callback, 0, &zErrMsg);
//  rc = sqlite3_exec(db, "PRAGMA cache_size = 2000;", callback, 0, &zErrMsg);

  asm ("l.pc.start\t\t0xf" : :);
  BEGIN_TIMER;
  rc = sqlite3_exec(db, argv[2], callback, 0, &zErrMsg);
  END_TIMER;
  asm ("l.pc.end\t\t0xf" : :);


  if( rc!=SQLITE_OK ){
    fprintf(stderr, "SQL error: %s\n", zErrMsg);
    sqlite3_free(zErrMsg);
  }

  for (i=0;i<8;i++)
	free(tb_cntr[i]);

  asm("l.end\t\t0" : :);

  sqlite3_close(db);
  return 0;

}

