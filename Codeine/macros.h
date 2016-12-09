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

#ifndef __MACROS_H__
#define __MACROS_H__

/*!
 * @define      NSSTR
 * @abstract    Gets a NSString object from a C string
 */
#define NSSTR( str )                        [ NSString stringWithCString: ( char * )str encoding: NSASCIIStringEncoding ]

/*!
 * @define      CSTR
 * @abstract    Gets an C string from a NSString object
 */
#define CSTR( str )                         ( char * )[ str cStringUsingEncoding: NSASCIIStringEncoding ]

/*!
 * @define      CSTR_UTF8
 * @abstract    Gets an UTF-8 C string from a NSString object
 */
#define CSTR_UTF8( str )                    ( char * )[ str cStringUsingEncoding: NSUTF8StringEncoding ]

/*!
 * @define      STRF
 * @abstract    Returns a string created by using a given format string as a template into which the remaining argument values are substituted
 */
#define STRF( ... )                         [ NSString stringWithFormat: __VA_ARGS__ ]

/*!
 * @define      L10N
 * @abstract    Gets a localized label from the 'Localizable.strings' file
 */
#define L10N( label )                       localizedString( @label, nil )

#ifdef NSLocalizedString
#undef NSLocalizedString
#endif

/*!
 * @define      NSLocalizedString
 * @abstract    Replacement of the built-in function NSLocalizedString.
 * @discussion  The replacement function will log a warning on the console
 *              if a label is not found in the strings file.
 * @param       label       The label to get
 * @param       comment     Not used
 */
#define NSLocalizedString( label, comment ) localizedString( label, comment )


/*!
 * @define      Log
 * @abstract    Logs an instance of an Objective-C class to the console
 */
#define Log( object )                           \
    NSLog( @"%@", object )

/*!
 * @define      LogPoint
 * @abstract    Logs a NSPoint structure to the console
 */
#define LogPoint( point )                       \
    NSLog                                       \
    (                                           \
        @"NSPoint:\n"                           \
        @"    X: %f\n"                          \
        @"    Y: %f",                           \
        point.x,                                \
        point.y                                 \
    )

/*!
 * @define      LogSize
 * @abstract    Logs a NSSize structure to the console
 */
#define LogSize( size )                         \
    NSLog                                       \
    (                                           \
        @"NSSize:\n"                            \
        @"    Width:  %f\n"                     \
        @"    Height: %f",                      \
        size.width,                             \
        size.height                             \
    )

/*!
 * @define      LogRect
 * @abstract    Logs a NSRect structure to the console
 */
#define LogRect( rect )                         \
    NSLog                                       \
    (                                           \
        @"NSRect:\n"                            \
        @"    X:      %f\n"                     \
        @"    Y:      %f\n"                     \
        @"    Width:  %f\n"                     \
        @"    Height: %f",                      \
        ( rect ).origin.x,                      \
        ( rect ).origin.y,                      \
        ( rect ).size.width,                    \
        ( rect ).size.height                    \
    )

/*!
 * @define      LogRange
 * @abstract    Logs a NSRange structure to the console
 */
#define LogRange( range )                       \
    NSLog                                       \
    (                                           \
        @"NSRange:\n"                           \
        @"    Location: %i\n"                   \
        @"    Length:   %i\n",                  \
        range.location,                         \
        range.length                            \
    )

/*!
 * @define      NOTIFICATION_CENTER
 * @abstract    The shared instance of the NSNotificationCenter class
 */
#define NOTIFICATION_CENTER     [ NSNotificationCenter defaultCenter ]

/*!
 * @define      FILE_MANAGER
 * @abstract    The shared instance of the NSFileManager class
 */
#define FILE_MANAGER            [ NSFileManager defaultManager ]

/*!
 * @define      APPLICATION
 * @abstract    The shared instance of the UIApplication class
 */
#define APPLICATION             [ NSApplication sharedApplication ]

/*!
 * @define      DEFAULTS
 * @abstract    The shared instance of the NSUserDefaults class
 */
#define DEFAULTS                [ NSUserDefaults standardUserDefaults ]

/*!
 * @define      BUNDLE
 * @abstract    The shared instance of the NSBundle class
 */
#define BUNDLE                  [ NSBundle mainBundle ]

/*!
 * @define      EXCHANGE
 * @abstract    Exchange two variables of the same type
 * @param       var1    The first variable
 * @param       var2    The second variable
 * @param       type    The type of the two variables
 */
#define EXCHANGE( var1, var2, type )    \
    {                                   \
        type tmp;                       \
                                        \
        tmp  = var1;                    \
        var1 = var2;                    \
        var2 = tmp;                     \
    }

/*!
 * @define      AUTORELEASE_POOL
 * @abstract    Issue code that will be wrapped by a new instance of the NSAutoreleasePool class
 * @param       code    The code to execute
 */
#define AUTORELEASE_POOL( code )        \
    {                                   \
        NSAutoreleasePool * ap;         \
                                        \
        ap = [ NSAutoreleasePool new ]; \
                                        \
        code                            \
                                        \
        [ ap release ];                 \
    }


/*!
 * @define      DEBUG_CODE
 * @abstract    Issue code that will be executed only in DEBUG mode
 * @param       code    The code to execute
 */
#if defined( DEBUG ) && DEBUG == 1
    
    #define DEBUG_CODE( code )  code
    
#else
    
    #define DEBUG_CODE( code )  
    
#endif

/*!
 * @define      THREADED
 * @abstract    Flag for the methods intended to run on a separate thread
 */
#define THREADED

/*!
 * @define      SingletonImplementation
 * @abstract    Creates the base implementation for a singleton class
 * @param       name    The name of the class
 */
#define SingletonImplementation( name )                                 \
                                                                        \
static name * __sharedInstance = nil;                                   \
                                                                        \
@implementation name                                                    \
                                                                        \
+ ( id )sharedInstance                                                  \
{                                                                       \
    @synchronized( self )                                               \
    {                                                                   \
        if( __sharedInstance == nil )                                   \
        {                                                               \
            __sharedInstance = [ [ super allocWithZone: NULL ] init ];  \
        }                                                               \
    }                                                                   \
                                                                        \
    return __sharedInstance;                                            \
}                                                                       \
                                                                        \
+ ( id )allocWithZone:( NSZone * )zone                                  \
{                                                                       \
    ( void )zone;                                                       \
                                                                        \
    @synchronized( self )                                               \
    {                                                                   \
        return [ [ self sharedInstance ] retain ];                      \
    }                                                                   \
}                                                                       \
                                                                        \
- ( id )copyWithZone:( NSZone * )zone                                   \
{                                                                       \
    ( void )zone;                                                       \
                                                                        \
    return self;                                                        \
}                                                                       \
                                                                        \
- ( id )retain                                                          \
{                                                                       \
    return self;                                                        \
}                                                                       \
                                                                        \
- ( NSUInteger )retainCount                                             \
{                                                                       \
    return UINT_MAX;                                                    \
}                                                                       \
                                                                        \
- ( oneway void )release                                                \
{}                                                                      \
                                                                        \
- ( id )autorelease                                                     \
{                                                                       \
    return self;                                                        \
}

#endif /* __MACROS_H__ */
