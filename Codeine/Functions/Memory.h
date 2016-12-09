/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      ...
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

/* $Id$ */

#ifndef __MEMORY_H__
#define __MEMORY_H__

#if defined( __cplusplus )
extern "C" {
#endif

#include <stdlib.h>

#ifndef __func__
    #if __STDC_VERSION__ < 199901L
        #ifdef __GNUC__
            #if __GNUC__ >= 2
                #define __func__ __FUNCTION__
            #else
                #define __func__ "<unknown>"
            #endif
        #else
            #define __func__ "<unknown>"
        #endif
    #endif
#endif

/*!
 * @function        ...
 * @abstract        ...
 * @description     ...
 */
void * mem_alloc( size_t s, const char * file, int line, const char * func );

/*!
 * @function        ...
 * @abstract        ...
 * @description     ...
 */
void * mem_realloc( void * ptr, size_t s );

/*!
 * @function        ...
 * @abstract        ...
 * @description     ...
 */
void mem_retain( void * ptr );

/*!
 * @function        ...
 * @abstract        ...
 * @description     ...
 */
void mem_release( void * ptr );

/*!
 * @function        ...
 * @abstract        ...
 * @description     ...
 */
char * mem_strdup( const char * str, const char * file, int line, const char * func );

#if defined( __cplusplus )
}
#endif

#endif /* __MEM_H__ */

#ifdef DEBUG

#ifndef malloc
    #define malloc( s )         mem_alloc( s, __FILE__, __LINE__, __func__ )
#endif

#ifndef calloc
    #define calloc( s, n )      mem_alloc( s * n, __FILE__, __LINE__, __func__ )
#endif

#ifndef realloc
    #define realloc( ptr, s )   mem_realloc( ptr, s )
#endif

#ifndef free
    #define free( ptr )         mem_release( ptr )
#endif

#ifndef strdup
    #define strdup( str )       mem_strdup( str, __FILE__, __LINE__, __func__ )
#endif

#endif /* __MEMORY_H__ */
