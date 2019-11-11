//==========================================================================
//
//      fatfs1.c
//
//      Test fileio system
//
//==========================================================================
// ####ECOSGPLCOPYRIGHTBEGIN####                                            
// -------------------------------------------                              
// This file is part of eCos, the Embedded Configurable Operating System.   
// Copyright (C) 1998, 1999, 2000, 2001, 2002, 2004 Free Software Foundation, Inc.
//
// eCos is free software; you can redistribute it and/or modify it under    
// the terms of the GNU General Public License as published by the Free     
// Software Foundation; either version 2 or (at your option) any later      
// version.                                                                 
//
// eCos is distributed in the hope that it will be useful, but WITHOUT      
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or    
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License    
// for more details.                                                        
//
// You should have received a copy of the GNU General Public License        
// along with eCos; if not, write to the Free Software Foundation, Inc.,    
// 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.            
//
// As a special exception, if other files instantiate templates or use      
// macros or inline functions from this file, or you compile this file      
// and link it with other works to produce a work based on this file,       
// this file does not by itself cause the resulting work to be covered by   
// the GNU General Public License. However the source code for this file    
// must still be made available in accordance with section (3) of the GNU   
// General Public License v2.                                               
//
// This exception does not invalidate any other reasons why a work based    
// on this file might be covered by the GNU General Public License.         
// -------------------------------------------                              
// ####ECOSGPLCOPYRIGHTEND####                                              
//==========================================================================
//#####DESCRIPTIONBEGIN####
//
// Author(s):           nickg
// Contributors:        nickg
// Date:                2000-05-25
// Purpose:             Test fileio system
// Description:         This test uses the testfs to check out the initialization
//                      and basic operation of the fileio system
//                      
//                      
//                      
//                      
//                      
//              
//
//####DESCRIPTIONEND####
//
//==========================================================================

#include <pkgconf/hal.h>
#include <pkgconf/io_fileio.h>
#include <pkgconf/fs_fat.h>

#include <cyg/infra/cyg_trac.h>        // tracing macros
#include <cyg/infra/cyg_ass.h>         // assertion macros

#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <errno.h>
#include <string.h>
#include <dirent.h>
#include <stdio.h>

#include <cyg/fileio/fileio.h>

#include <cyg/infra/testcase.h>
#include <cyg/infra/diag.h>            // HAL polled output
#include <cyg/fs/fatfs.h>



//==========================================================================

#define SHOW_RESULT( _fn, _res ) \
diag_printf("<FAIL>: " #_fn "() returned %d %s\n", _res, _res<0?strerror(errno):"");

//==========================================================================

#define IOSIZE  100

#define LONGNAME1       "long_file_name_that_should_take_up_more_than_one_directory_entry_1"
#define LONGNAME2       "long_file_name_that_should_take_up_more_than_one_directory_entry_2"


//==========================================================================

#ifndef CYGPKG_LIBC_STRING

char *strcat( char *s1, const char *s2 )
{
    char *s = s1;
    while( *s1 ) s1++;
    while( (*s1++ = *s2++) != 0);
    return s;
}

#endif

//==========================================================================

static void listdir( char *name, int statp, int numexpected, int *numgot )
{
    int err;
    DIR *dirp;
    int num=0;
    
    diag_printf("<INFO>: reading directory %s\n",name);
    
    dirp = opendir( name );
    if( dirp == NULL ) SHOW_RESULT( opendir, -1 );

    for(;;)
    {
        struct dirent *entry = readdir( dirp );
        
        if( entry == NULL )
            break;
        num++;
        diag_printf("<INFO>: entry %14s",entry->d_name);
#ifdef CYGPKG_FS_FAT_RET_DIRENT_DTYPE
        diag_printf(" d_type %2x", entry->d_type);
#endif
        if( statp )
        {
            char fullname[PATH_MAX];
            struct stat sbuf;

            if( name[0] )
            {
                strcpy(fullname, name );
                if( !(name[0] == '/' && name[1] == 0 ) )
                    strcat(fullname, "/" );
            }
            else fullname[0] = 0;
            
            strcat(fullname, entry->d_name );
            
            err = stat( fullname, &sbuf );
            if( err < 0 )
            {
                if( errno == ENOSYS )
                    diag_printf(" <no status available>");
                else SHOW_RESULT( stat, err );
            }
            else
            {
                diag_printf(" [mode %08x ino %08x nlink %d size %ld]",
                            sbuf.st_mode,sbuf.st_ino,sbuf.st_nlink,(long)sbuf.st_size);
            }
#ifdef CYGPKG_FS_FAT_RET_DIRENT_DTYPE
            if ((entry->d_type & S_IFMT) != (sbuf.st_mode & S_IFMT))
              CYG_TEST_FAIL("File mode's don't match between dirent and stat");
#endif
        }

        diag_printf("\n");
    }

    err = closedir( dirp );
    if( err < 0 ) SHOW_RESULT( stat, err );
    if (numexpected >= 0 && num != numexpected)
        CYG_TEST_FAIL("Wrong number of dir entries\n");
    if ( numgot != NULL )
        *numgot = num;
}

//==========================================================================

static void createfile( char *name, size_t size )
{
    char buf[IOSIZE];
    int fd;
    ssize_t wrote;
    int i;
    int err;

    diag_printf("<INFO>: create file %s size %zd \n",name,size);

    err = access( name, F_OK );
    if( err < 0 && errno != EACCES ) SHOW_RESULT( access, err );
    
    for( i = 0; i < IOSIZE; i++ ) buf[i] = i%256;
 
    fd = open( name, O_WRONLY|O_CREAT );
    if( fd < 0 ) SHOW_RESULT( open, fd );

    while( size > 0 )
    {
        ssize_t len = size;
        if ( len > IOSIZE ) len = IOSIZE;
        
        wrote = write( fd, buf, len );
        if( wrote != len ) SHOW_RESULT( write, (int)wrote );        

        size -= wrote;
    }

    err = close( fd );
    if( err < 0 ) SHOW_RESULT( close, err );
}

//==========================================================================

static void maxfile( char *name )
{
    char buf[IOSIZE];
    int fd;
    ssize_t wrote;
    int i;
    int err;
    size_t size = 0;
    size_t prevsize = 0;
    
    diag_printf("<INFO>: create maximal file %s\n",name);
    diag_printf("<INFO>: This may take a few minutes\n");

    err = access( name, F_OK );
    if( err < 0 && errno != EACCES ) SHOW_RESULT( access, err );
    
    for( i = 0; i < IOSIZE; i++ ) buf[i] = i%256;
 
    fd = open( name, O_WRONLY|O_CREAT );
    if( fd < 0 ) SHOW_RESULT( open, fd );

    do
    {
        wrote = write( fd, buf, IOSIZE );
        //if( wrote < 0 ) SHOW_RESULT( write, wrote );        

        if( wrote >= 0 )
            size += wrote;

        if( (size-prevsize) > 100000 )
        {
            diag_printf("<INFO>: size = %zd \n", size);
            prevsize = size;
        }
        
    } while( wrote == IOSIZE );

    diag_printf("<INFO>: file size == %zd\n",size);

    err = close( fd );
    if( err < 0 ) SHOW_RESULT( close, err );
}

//==========================================================================

static void checkfile( char *name )
{
    char buf[IOSIZE];
    int fd;
    ssize_t done;
    int i;
    int err;
    off_t pos = 0;

    diag_printf("<INFO>: check file %s\n",name);
    
    err = access( name, F_OK );
    if( err != 0 ) SHOW_RESULT( access, err );

    fd = open( name, O_RDONLY );
    if( fd < 0 ) SHOW_RESULT( open, fd );

    for(;;)
    {
        done = read( fd, buf, IOSIZE );
        if( done < 0 ) SHOW_RESULT( read, (int)done );

        if( done == 0 ) break;

        for( i = 0; i < done; i++ )
            if( buf[i] != i%256 )
            {
                diag_printf("buf[%ld+%d](%02x) != %02x\n",pos,i,buf[i],i%256);
                CYG_TEST_FAIL("Data read not equal to data written\n");
            }
        
        pos += done;
    }

    err = close( fd );
    if( err < 0 ) SHOW_RESULT( close, err );
}

#ifdef CYGCFG_FS_FAT_USE_ATTRIBUTES
//==========================================================================

static void checkattrib(const char *name, 
                        const cyg_fs_attrib_t test_attrib )
{
    int err;
    cyg_fs_attrib_t file_attrib;

    diag_printf("<INFO>: check attrib %s\n",name);

    err = cyg_fs_get_attrib(name, &file_attrib);
    if( err != 0 ) SHOW_RESULT( stat, err );

    if ( (file_attrib & S_FATFS_ATTRIB) != test_attrib )
        diag_printf("<FAIL>: attrib %s incorrect\n\tExpected %x Was %x\n",
                    name,test_attrib,(file_attrib & S_FATFS_ATTRIB));
}
#endif // CYGCFG_FS_FAT_USE_ATTRIBUTES

//==========================================================================

static void copyfile( char *name2, char *name1 )
{

    int err;
    char buf[IOSIZE];
    int fd1, fd2;
    ssize_t done, wrote;

    diag_printf("<INFO>: copy file %s -> %s\n",name2,name1);

    err = access( name1, F_OK );
    if( err < 0 && errno != EACCES ) SHOW_RESULT( access, err );

    err = access( name2, F_OK );
    if( err != 0 ) SHOW_RESULT( access, err );
    
    fd1 = open( name1, O_WRONLY|O_CREAT );
    if( fd1 < 0 ) SHOW_RESULT( open, fd1 );

    fd2 = open( name2, O_RDONLY );
    if( fd2 < 0 ) SHOW_RESULT( open, fd2 );
    
    for(;;)
    {
        done = read( fd2, buf, IOSIZE );
        if( done < 0 ) SHOW_RESULT( read, (int)done );

        if( done == 0 ) break;

        wrote = write( fd1, buf, done );
        if( wrote != done ) SHOW_RESULT( write, (int) wrote );

        if( wrote != done ) break;
    }

    err = close( fd1 );
    if( err < 0 ) SHOW_RESULT( close, err );

    err = close( fd2 );
    if( err < 0 ) SHOW_RESULT( close, err );
    
}

//==========================================================================

static void comparefiles( char *name2, char *name1 )
{
    int err;
    char buf1[IOSIZE];
    char buf2[IOSIZE];
    int fd1, fd2;
    ssize_t done1, done2;
    int i;

    diag_printf("<INFO>: compare files %s == %s\n",name2,name1);

    err = access( name1, F_OK );
    if( err != 0 ) SHOW_RESULT( access, err );

    err = access( name1, F_OK );
    if( err != 0 ) SHOW_RESULT( access, err );
    
    fd1 = open( name1, O_RDONLY );
    if( fd1 < 0 ) SHOW_RESULT( open, fd1 );

    fd2 = open( name2, O_RDONLY );
    if( fd2 < 0 ) SHOW_RESULT( open, fd2 );
    
    for(;;)
    {
        done1 = read( fd1, buf1, IOSIZE );
        if( done1 < 0 ) SHOW_RESULT( read, (int)done1 );

        done2 = read( fd2, buf2, IOSIZE );
        if( done2 < 0 ) SHOW_RESULT( read, (int)done2 );

        if( done1 != done2 )
            diag_printf("Files different sizes\n");
        
        if( done1 == 0 ) break;

        for( i = 0; i < done1; i++ )
            if( buf1[i] != buf2[i] )
            {
                diag_printf("buf1[%d](%02x) != buf1[%d](%02x)\n",i,buf1[i],i,buf2[i]);
                CYG_TEST_FAIL("Data in files not equal\n");
            }
			else
			{
				diag_printf("buf1[%d](%02x) == buf2[%d](%02x)\n",i,buf1[i],i,buf2[i]);
			}
    }

    err = close( fd1 );
    if( err < 0 ) SHOW_RESULT( close, err );

    err = close( fd2 );
    if( err < 0 ) SHOW_RESULT( close, err );
    
}

//==========================================================================

void checkcwd( const char *cwd )
{
    static char cwdbuf[PATH_MAX];
    char *ret;

    ret = getcwd( cwdbuf, sizeof(cwdbuf));
    if( ret == NULL ) SHOW_RESULT( getcwd, (int)ret );    

    if( strcmp( cwdbuf, cwd ) != 0 )
    {
        diag_printf( "cwdbuf %s cwd %s\n",cwdbuf, cwd );
        CYG_TEST_FAIL( "Current directory mismatch");
    }
}

//==========================================================================
// main

int main( int argc, char **argv )
{
    int err;
    int existingdirents=-1;
	int fd = 0;
	char buff[20] = {0};
	char buff1[20] = {0};
	int loop = 0;
	FILE *fp = NULL;
	
    CYG_TEST_INIT();

	err = mount("/dev/mmcdisk0/","/","fatfs"); 
    if( err < 0 )
	{
		SHOW_RESULT( mount, err ); 	
	}
	else
	{
		diag_printf("mount ok!\n");
	}

	
    err = chdir( "/" );
    if( err < 0 )
	{
		SHOW_RESULT( chdir, err );
	}
	else
	{
		diag_printf("chdir ok!\n");	
	}


    checkcwd( "/" );
	
	
    listdir( "/", true, -1, &existingdirents );

    createfile( "/mkg_rill", 10 );
    checkfile( "mkg_rill" );
    copyfile( "mkg_rill", "mkg_rill_bak");
    checkfile( "mkg_rill_bak" );
    comparefiles( "mkg_rill_bak", "/mkg_rill" );
 
 #if 0   
	diag_printf("<INFO>: mkdir bar\n");
    err = mkdir( "/bar", 0 );
    if( err < 0 ) SHOW_RESULT( mkdir, err );

    listdir( "/" , true, existingdirents+3, NULL );

    copyfile( "fee", "/bar/fum" );
    checkfile( "bar/fum" );
    comparefiles( "/fee", "bar/fum" );

    diag_printf("<INFO>: cd bar\n");
    err = chdir( "bar" );
    if( err < 0 ) SHOW_RESULT( chdir, err );

    checkcwd( "/bar" );
    
    diag_printf("<INFO>: rename /foo bundy\n");    
    err = rename( "/foo", "bundy" );
    if( err < 0 ) SHOW_RESULT( rename, err );
    
    listdir( "/", true, existingdirents+2, NULL );
    listdir( "" , true, 4, NULL );

    checkfile( "/bar/bundy" );
    comparefiles("/fee", "bundy" );

    diag_printf("<INFO>: unlink fee\n");    
    err = unlink( "/fee" );
    if( err < 0 ) SHOW_RESULT( unlink, err );

    diag_printf("<INFO>: unlink fum\n");        
    err = unlink( "fum" );
    if( err < 0 ) SHOW_RESULT( unlink, err );

    diag_printf("<INFO>: unlink /bar/bundy\n");        
    err = unlink( "/bar/bundy" );
    if( err < 0 ) SHOW_RESULT( unlink, err );

    diag_printf("<INFO>: cd /\n");        
    err = chdir( "/" );
    if( err < 0 ) SHOW_RESULT( chdir, err );

    checkcwd( "/" );
    
    diag_printf("<INFO>: rmdir /bar\n");        
    err = rmdir( "/bar" );
    if( err < 0 ) SHOW_RESULT( rmdir, err );
    
    listdir( "/", false, existingdirents, NULL );
#endif
    

    
    err = umount( "/" );
    if( err < 0 ) SHOW_RESULT( umount, err );
    
    CYG_TEST_PASS_FINISH("fatfs1");
}

// -------------------------------------------------------------------------
// EOF fatfs1.c
