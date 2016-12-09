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

#import "Project.h"

@interface StartController: NSWindowController
{
@protected
    
    NSWindow  * _projectAttributesWindow;
    ProjectType _newProjectType;
    
@private
    
    id _StartController_Reserved[ 5 ];
}

@property( nonatomic, retain ) IBOutlet NSWindow * projectAttributesWindow;

- ( IBAction )newCProject: ( id )sender;
- ( IBAction )newCPPProject: ( id )sender;
- ( IBAction )newObjectiveCProject: ( id )sender;
- ( IBAction )newProjectCreate: ( id )sender;
- ( IBAction )newProjectCancel: ( id )sender;
- ( IBAction )open: ( id )sender;
- ( IBAction )openOther: ( id )sender;
- ( void )showNewProjectAttributesView;

@end
