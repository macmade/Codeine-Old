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

@interface AboutController: NSWindowController
{
@protected
    
    NSTextField * _versionField;
    
@private
    
    id _AboutController_Reserved[ 5 ];
}

@property( nonatomic, retain ) IBOutlet NSTextField * versionField;

@end
