/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        ...
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

/* $Id$ */

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <ctype.h>
#include "Memory.h"

#if defined( __APPLE__ )

    #include <execinfo.h>

    #define __MEM_HAVE_EXECINFO_H   1

#elif defined( __GLIBC__ ) && defined( HAVE_EXECINFO_H )

    #include <execinfo.h>

    #define __MEM_HAVE_EXECINFO_H   1

#endif

#undef malloc
#undef calloc
#undef realloc
#undef free

#ifndef __bool_true_false_are_defined
    #ifdef _Bool
        #define bool                        _Bool
    #else
        #define bool                        char
    #endif
    #define true                            1
    #define false                           0
    #define __bool_true_false_are_defined   1
#endif

#define __MEM_OBJECT_SIZE   1024

#define __MEM_FENCE_SIZE    32

#define __MEM_HR            "--------------------------------------------------------------------------------\n"

typedef struct __mem_object_struct
{
    size_t        size;
    unsigned long retain_count;
    const char  * file;
    const char  * func;
    int           line;
    void        * data;
    unsigned char fence[ __MEM_FENCE_SIZE ];
}
__mem_object;

static __mem_object ** __objects        = NULL;
static unsigned long   __objects_count  = 0;
static unsigned long   __objects_size   = 0;
static bool            __inited         = false;
static bool            __crash          = false;
static unsigned long   __objects_total  = 0;
static unsigned long   __mem_total      = 0;

void           __mem_init( void );
void           __mem_exit( void );
void           __mem_store_object( __mem_object * o );
void           __mem_delete_object( __mem_object * o );
__mem_object * __mem_get_object( void * ptr, unsigned long * idx );
void           __mem_verify_object( __mem_object * o );
void           __mem_fatal( __mem_object * o, const char * msg, ... );
void           __mem_debug( const char * msg, ... );
char         * __mem_fname( const char * path );
void           __mem_dump( __mem_object * o );

void __mem_init( void )
{
    __objects       = ( __mem_object ** )calloc( sizeof( __mem_object * ) * __MEM_OBJECT_SIZE, 1 );
    __objects_size  = __MEM_OBJECT_SIZE;
    __objects_count = 0;
    __inited        = true;
    
    if( __objects == NULL )
    {
        __mem_fatal( NULL, "Unable to allocate memory for the memory objects" );
    }
    
    atexit( __mem_exit );
    
    __mem_debug( "Initializing the memory debugger" );
}

void __mem_exit( void )
{
    unsigned long i;
    size_t        bytes;
    double        size;
    
    #ifndef DEBUG
    
    free( __objects );
    return;
    
    #endif
    
    if( __crash == true )
    {
        free( __objects );
        return;
    }
    
    __mem_debug( "Finalizing the memory debugger" );
    
    fprintf
    (
        stderr,
        __MEM_HR
        "Statistics:\n"
        __MEM_HR
        "\n"
        "    - Total allocated objects: %lu\n"
        "    - Total memory usage:      ",
        __objects_total
    );
    
    if( __mem_total < 1000 )
    {
        fprintf( stderr, "%lu bytes\n\n", ( unsigned long )__mem_total );
    }
    else if( __mem_total < 1000000 )
    {
        size = __mem_total / 1000;
        
        fprintf( stderr, "%.02f KB (%lu bytes)\n\n", size, ( unsigned long )__mem_total );
    }
    else if( __mem_total < 1000000000 )
    {
        size = ( __mem_total / 1000 ) / 1000;
        
        fprintf( stderr, "%.02f MB (%lu bytes)\n\n", size, ( unsigned long )__mem_total );
    }
    else
    {
        size = ( ( __mem_total / 1000 ) / 1000 ) / 1000;
        
        fprintf( stderr, "%.02f GB (%lu bytes)\n\n", size, ( unsigned long )__mem_total );
    }
    
    if( __objects_count > 0 )
    {
        fprintf
        (
            stderr,
            __MEM_HR
            "Memory error: unfreed memory records at application exit point\n"
            __MEM_HR
        );
        
        bytes = 0;
        
        for( i = 0; i < __objects_count; i++ )
        {
            bytes += __objects[ i ]->size;
        }
        
        fprintf
        (
            stderr,
            "\n"
            "    - Number of objects:   %lu\n"
            "    - Memory leaked:       ",
            __objects_count
        );
        
        if( bytes < 1000 )
        {
            fprintf( stderr, "%lu bytes\n\n", ( unsigned long )bytes );
        }
        else if( bytes < 1000000 )
        {
            size = bytes / 1000;
            
            fprintf( stderr, "%.02f KB (%lu bytes)\n\n", size, ( unsigned long )bytes );
        }
        else if( bytes < 1000000000 )
        {
            size = ( bytes / 1000 ) / 1000;
            
            fprintf( stderr, "%.02f MB (%lu bytes)\n\n", size, ( unsigned long )bytes );
        }
        else
        {
            size = ( ( bytes / 1000 ) / 1000 ) / 1000;
            
            fprintf( stderr, "%.02f GB (%lu bytes)\n\n", size, ( unsigned long )bytes );
        }
        
        fprintf
        (
            stderr,
            __MEM_HR
            "Active memory records:\n"
            __MEM_HR
        );
        
        for( i = 0; i < __objects_count; i++ )
        {
            fprintf
            (
                stderr,
                "\n"
                "Object #%lu:\n"
                "\n"
                "    - Pointer:         %p\n"
                "    - Size:            %lu\n"
                "    - Retain count:    %lu\n"
                "    - Alloc in file:   %s\n"
                "    - Alloc at line:   %i\n"
                "    - Alloc in func:   %s\n",
                i,
                __objects[ i ]->data,
                ( unsigned long )__objects[ i ]->size,
                __objects[ i ]->retain_count,
                __mem_fname( __objects[ i ]->file ),
                __objects[ i ]->line,
                __objects[ i ]->func
            );
        }
    }
    
    free( __objects );
}

void __mem_store_object( __mem_object * o )
{
    if( __objects_count == __objects_size )
    {
        __objects       = ( __mem_object ** )realloc( __objects, sizeof( __mem_object * ) * ( __objects_size + __MEM_OBJECT_SIZE ) );
        __objects_size += __MEM_OBJECT_SIZE;
        
        if( __objects == NULL )
        {
            __mem_fatal( NULL, "Unable to allocate memory for the memory objects" );
        }
    }
    
    __objects[ __objects_count++ ] = o;
}

void __mem_delete_object( __mem_object * o )
{
    unsigned long i;
    unsigned long j;
    
    for( i = 0; i < __objects_count; i++ )
    {
        if( __objects[ i ] == o )
        {
            break;
        }
    }
    
    for( j = i; j < __objects_count - 1; j++ )
    {
        __objects[ j ] = __objects[ j + 1 ];
    }
    
    __objects[ __objects_count-- ] = NULL;
}

__mem_object * __mem_get_object( void * ptr, unsigned long * idx )
{
    unsigned long  i;
    
    for( i = 0; i < __objects_count; i++ )
    {
        if( __objects[ i ]->data == ptr )
        {
            __mem_verify_object( __objects[ i ] );
            
            if( idx != NULL )
            {
                *( idx ) = i;
            }
            
            return __objects[ i ];
        }
    }
    
    return NULL;
}

void __mem_verify_object( __mem_object * o )
{
    char * f;
    
    f  = ( char * )o;
    f += sizeof( __mem_object ) + o->size;
    
    if
    (
           strncmp( ( char * )( o->fence ), "MEM_DATA", 8 ) != 0
        || strncmp( f, "MEM_DATA", 8 ) != 0
    )
    {
        __mem_fatal( o, "Buffer overflow detected on pointer: %p", o->data );
    }
}

void __mem_fatal( __mem_object * o, const char * msg, ... )
{
    va_list ap;
    
    #ifdef __MEM_HAVE_EXECINFO_H
    void ** trace;
    char ** symbols;
    int     num;
    int     i;
    #endif
    
    __crash = true;
    
    fprintf
    (
        stderr,
            __MEM_HR
        "Memory error:\n"
            __MEM_HR
        "\n"
        "    - Message:         "
    );
    
    va_start( ap, msg );
    vfprintf( stderr, msg, ap );
    va_end( ap );
    fprintf( stderr, "\n" );
    
    if( o != NULL )
    {
        fprintf
        (
            stderr,
            "\n"
                __MEM_HR
            "Memory record:\n"
                __MEM_HR
            "\n"
            "    - Pointer:         %p\n"
            "    - Size:            %lu\n"
            "    - Retain count:    %lu\n"
            "    - Alloc in file:   %s\n"
            "    - Alloc at line:   %i\n"
            "    - Alloc in func:   %s\n"
            "    \n",
            o->data,
            ( unsigned long )o->size,
            o->retain_count,
            __mem_fname( o->file ),
            o->line,
            o->func
        );
        
        __mem_dump( o );
    }
    
    #ifdef __MEM_HAVE_EXECINFO_H
    
    trace = ( void ** )malloc( 100 * sizeof( void * ) );
    
    if( trace != NULL )
    {
        num     = backtrace( trace, 100 );
        symbols = backtrace_symbols( trace, num );
        
        if( symbols != NULL )
        {
            fprintf
            (
                stderr,
                "\n"
                __MEM_HR
                "Backtrace:\n"
                __MEM_HR
                "\n"
            );
            
            for( i = 0; i < num; i++ )
            {
                fprintf( stderr, "    - %s\n", symbols[ i ] );
            }
            
            free( symbols );
        }
        
        free( trace );
    }
    
    #endif
    
    exit( EXIT_FAILURE );
}

void __mem_debug( const char * msg, ... )
{
    va_list ap;
    
    #ifndef DEBUG
    
    return;
    
    #endif
    
    va_start( ap, msg );
    fprintf( stderr, "DEBUG > " );
    vfprintf( stderr, msg, ap );
    va_end( ap );
    fprintf( stderr, "\n" );
}

char * __mem_fname( const char * path )
{
    char * file;
    
    file = strrchr( path, '/' );
    
    if( file == NULL )
    {
        return ( char * )path;
    }
    
    return file + 1;
}

void __mem_dump( __mem_object * o )
{
    long unsigned int i;
    long unsigned int j;
    unsigned char     c;
    unsigned char   * ptr;
    size_t            size;
    
    ptr  = ( unsigned char * )o;
    size = o->size + sizeof( __mem_object ) + ( __MEM_FENCE_SIZE * sizeof( char ) );
    
    for( i = 0; i < size; i += 25 )
    {
        fprintf( stderr, "    %010lu: ", i );
        
        for( j = i; j < i + 25; j++ )
        {
            if( j < size )
            {
                fprintf( stderr, "%02X ", ( unsigned char )ptr[ j ] );
            }
            else
            {
                fprintf( stderr, "   " );
            }
        }
        
        fprintf( stderr, "| " );
        
        for( j = i; j < i + 25; j++ )
        {
            if( j < size )
            {
                c = ( unsigned char )ptr[ j ];
                
                if( ( c & 0x80 ) == 0 && isprint( ( int )c ) && c != 0x20 )
                {
                    fprintf( stderr, "%c", c );
                    
                }
                else
                {
                    fprintf( stderr, "." );
                }
            }
        }
        
        fprintf( stderr, "\n" );
    }
}

void * mem_alloc( size_t s, const char * file, int line, const char * func )
{
    __mem_object * o;
    char         * ptr;
    
    if( s == 0 )
    {
        __mem_fatal
        (
            NULL,
            "Allocation with 0 byte size - %s:%i - %s",
            __mem_fname( file ),
            line,
            func
        );
    }
    
    if( __inited == false )
    {
        __mem_init();
    }
    
    o = ( __mem_object * )calloc( sizeof( __mem_object ) + ( __MEM_FENCE_SIZE * sizeof( char ) ) + s, 1 );
    
    if( o == NULL )
    {
        __mem_debug( "Allocation failed!" );
        return NULL;
    }
    
    __mem_total     += s;
    __objects_total += 1;
    
    ptr             = ( char * )o;
    ptr            += sizeof( __mem_object );
    o->data         = ptr;
    o->size         = s;
    o->retain_count = 1;
    o->file         = file;
    o->line         = line;
    o->func         = func;
    
    o->fence[ 0 ] = 'M';
    o->fence[ 1 ] = 'E';
    o->fence[ 2 ] = 'M';
    o->fence[ 3 ] = '_';
    o->fence[ 4 ] = 'D';
    o->fence[ 5 ] = 'A';
    o->fence[ 6 ] = 'T';
    o->fence[ 7 ] = 'A';
    o->fence[ 8 ] = 0;
    
    ptr[ s + 0 ] = 'M';
    ptr[ s + 1 ] = 'E';
    ptr[ s + 2 ] = 'M';
    ptr[ s + 3 ] = '_';
    ptr[ s + 4 ] = 'D';
    ptr[ s + 5 ] = 'A';
    ptr[ s + 6 ] = 'T';
    ptr[ s + 7 ] = 'A';
    ptr[ s + 8 ] = 0;
    
    __mem_store_object( o );
    
    return ptr;
}

void * mem_realloc( void * ptr, size_t s )
{
    unsigned long  i;
    __mem_object * o1;
    __mem_object * o2;
    char         * c;
    
    if( __inited == false )
    {
        __mem_init();
    }
    
    i  = 0;
    o1 = __mem_get_object( ptr, &i );
    
    if( o1 == NULL && ptr != NULL )
    {
        __mem_fatal( NULL, "Pointer beeing re-allocated was not allocated: %p", ptr );
    }
    
    if( s == 0 )
    {
        __mem_fatal( o1, "Reallocation with 0 byte size" );
    }
    
    o2 = ( __mem_object * )realloc( o1, sizeof( __mem_object ) + ( __MEM_FENCE_SIZE * sizeof( char ) ) + s );
    
    if( o2 == NULL )
    {
        __mem_delete_object( o1 );
        __mem_debug( "Reallocation failed for %p", ptr );
        return NULL;
    }
    
    __objects[ i ] = o2;
    
    if( s > o2->size )
    {
        __mem_total += ( s - o2->size );
    }
    
    c        = ( char * )o2;
    c       += sizeof( __mem_object );
    o2->data = c;
    o2->size = s;
    
    c[ s + 0 ] = 'M';
    c[ s + 1 ] = 'E';
    c[ s + 2 ] = 'M';
    c[ s + 3 ] = '_';
    c[ s + 4 ] = 'D';
    c[ s + 5 ] = 'A';
    c[ s + 6 ] = 'T';
    c[ s + 7 ] = 'A';
    c[ s + 8 ] = 0;
    
    return c;
}

void mem_retain( void * ptr )
{
    __mem_object * o;
    
    if( __inited == false )
    {
        __mem_init();
    }
    
    if( ptr == NULL )
    {
        return;
    }
    
    o = __mem_get_object( ptr, NULL );
    
    if( o == NULL )
    {
        __mem_fatal( NULL, "Pointer beeing retained was not allocated: %p", ptr );
        
        return;
    }
    
    o->retain_count++;
}

void mem_release( void * ptr )
{
    __mem_object * o;
    
    if( __inited == false )
    {
        __mem_init();
    }
    
    if( ptr == NULL )
    {
        return;
    }
    
    o = __mem_get_object( ptr, NULL );
    
    if( o == NULL )
    {
        __mem_fatal( NULL, "Pointer beeing released was not allocated: %p", ptr );
        
        return;
    }
    
    o->retain_count--;
    
    if( o->retain_count == 0 )
    {
        __mem_delete_object( o );
        free( o );
    }
}

char * mem_strdup( const char * str, const char * file, int line, const char * func )
{
    char * s;
    
    s = ( char * )mem_alloc( sizeof( char ) * ( strlen( str ) + 1 ), file, line, func );
    
    strcpy( s, str );
    
    return s;
}
