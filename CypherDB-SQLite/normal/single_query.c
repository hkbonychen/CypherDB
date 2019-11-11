#include <stdio.h>
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
  sqlite3 *db;
  char *zErrMsg = 0;
  sqlite3_stmt *stmt, *stmt2;
  const char *pzTest;
  char *szSQL;
  int rc, i;
  
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
  sqlite3_close(db);
  return 0;

}

