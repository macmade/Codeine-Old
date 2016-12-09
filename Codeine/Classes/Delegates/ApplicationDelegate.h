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

@class AboutController;
@class PreferencesController;
@class StartController;

@interface ApplicationDelegate: NSObject < NSApplicationDelegate >
{
@protected
    
    AboutController       * _aboutController;
    PreferencesController * _preferencesController;
    StartController       * _startController;
    
@private
    
    id _ApplicationDelegate_Reserved[ 5 ];
}

- ( IBAction)showAboutWindow: ( id )sender;
- ( IBAction)showPreferencesWindow: ( id )sender;
- ( IBAction)showStartWindow: ( id )sender;

@end
