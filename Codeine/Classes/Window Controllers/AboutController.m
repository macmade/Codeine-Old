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

#import "AboutController.h"

@implementation AboutController

@synthesize versionField = _versionField;

- ( id )init
{
    if( [ super initWithWindowNibName: @"AboutWindow" ] )
    {}
    
    return self;
}

- ( void )dealloc
{
    [ _versionField release ];
    
    [ super dealloc ];
}

- ( void )windowDidLoad
{
    [ _versionField setStringValue: [ BUNDLE objectForInfoDictionaryKey: @"CFBundleShortVersionString" ] ];
    [ super windowDidLoad ];
}

@end
