
#ifdef __APPLE__
   #include "TargetConditionals.h"
   #if TARGET_OS_IPHONE && TARGET_IPHONE_SIMULATOR
      #define __CONTINUE__
   #elif TARGET_OS_IPHONE
      #define __CONTINUE__
   #else
      //#define TARGET_CONTUNUE
   #endif
#endif 


#ifdef HB_BUILD_IOS //__CONTINUE__

#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <fnmatch.h>

typedef enum {false,true} BOOL;


#if defined(__i386__)
DIR * opendir$INODE64$UNIX2003( char * dirName ) 
{
    return opendir( dirName );
}
#else 
DIR * opendir$INODE64( char * dirName )
{
    return opendir( dirName );
}
#endif 

struct dirent * readdir$INODE64( DIR * dir )
{
    return readdir( dir );
}

BOOL closedir$UNIX2003( DIR * dir )
{
    return closedir( dir );
}   

void fputs$UNIX2003(const char *restrict c, FILE *restrict f)
{
    fputs(c, f);
}

int fnmatch$UNIX2003( const char * pattern, const char * string, int flags )
{
    return fnmatch( pattern, string, flags );
}

size_t fwrite$UNIX2003( const void * buffer, size_t size, size_t count, FILE * stream )
{
    return fwrite( buffer, size, count, stream );
}   

size_t write$UNIX2003( const void * buffer, size_t size, size_t count, FILE * stream )
{
    return fwrite( buffer, size, count, stream );
}   

FILE * fopen$UNIX2003( const char * fname, const char * mode )
{
    return fopen( fname, mode );
}

void waitpid$UNIX2003( void )
{
   ;
} 

void sleep$UNIX2003( void ) //int ms )
{
   ;//sleep( ms );
}

void mktime$UNIX2003( void )//struct tm * a)
{
   ;// return mktime(a);
}

#if defined(__i386__)
ssize_t send$UNIX2003(int s, const void *msg, size_t len, int flags)
{
    return send( s, msg, len, flags);
}

ssize_t recv$UNIX2003(int s, void *msg, int len, int flags)
{
    return recv( s, msg, len, flags);
}
#endif 


#endif