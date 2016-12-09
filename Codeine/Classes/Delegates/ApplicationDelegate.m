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

#import "ApplicationDelegate.h"
#import "AboutController.h"
#import "PreferencesController.h"
#import "StartController.h"

@implementation ApplicationDelegate

- ( void )applicationDidFinishLaunching: ( NSNotification * )notification
{
    ( void )notification;
    
    [ self showStartWindow: nil ];
}

- ( void )applicationWillTerminate: ( NSNotification * )notification
{
    ( void )notification;
    
    [ _aboutController       release ];
    [ _preferencesController release ];
    [ _startController       release ];
}

- ( IBAction)showAboutWindow: ( id )sender
{
    if( _aboutController == nil )
    {
        _aboutController = [ AboutController new ];
    }
    
    [ _aboutController.window center ];
    [ _aboutController.window makeKeyAndOrderFront: sender ];
    [ _aboutController showWindow: sender ];
    [ APPLICATION activateIgnoringOtherApps: YES ];
}

- ( IBAction)showPreferencesWindow: ( id )sender
{
    if( _preferencesController == nil )
    {
        _preferencesController = [ PreferencesController new ];
    }
    
    [ _preferencesController.window center ];
    [ _preferencesController.window makeKeyAndOrderFront: sender ];
    [ _preferencesController showWindow: sender ];
    [ APPLICATION activateIgnoringOtherApps: YES ];
}

- ( IBAction)showStartWindow: ( id )sender
{
    if( _startController == nil )
    {
        _startController = [ StartController new ];
    }
    
    [ _startController.window center ];
    [ _startController.window makeKeyAndOrderFront: sender ];
    [ _startController showWindow: sender ];
    [ APPLICATION activateIgnoringOtherApps: YES ];
}

@end
