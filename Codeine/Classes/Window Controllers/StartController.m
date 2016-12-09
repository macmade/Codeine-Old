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

#import "StartController.h"

@implementation StartController

@synthesize projectAttributesWindow = _projectAttributesWindow;

- ( id )init
{
    if( [ super initWithWindowNibName: @"StartWindow" ] )
    {}
    
    return self;
}

- ( void )dealloc
{
    [ _projectAttributesWindow release ];
    
    [ super dealloc ];
}

- ( IBAction )newCProject: ( id )sender
{
    ( void )sender;
    
    _newProjectType = ProjectTypeC;
    
    [ self showNewProjectAttributesView ];
}

- ( IBAction )newCPPProject: ( id )sender
{
    ( void )sender;
    
    _newProjectType = ProjectTypeCPP;
    
    [ self showNewProjectAttributesView ];
}

- ( IBAction )newObjectiveCProject: ( id )sender
{
    ( void )sender;
    
    _newProjectType = ProjectTypeObjC;
    
    [ self showNewProjectAttributesView ];
}

- ( IBAction )newProjectCreate: ( id )sender
{
    ( void )sender;
}

- ( IBAction )newProjectCancel: ( id )sender
{
    ( void )sender;
}

- ( IBAction )open: ( id )sender
{
    ( void )sender;
}

- ( IBAction )openOther: ( id )sender
{
    ( void )sender;
}

- ( void )showNewProjectAttributesView
{
    [ APPLICATION beginSheet: _projectAttributesWindow modalForWindow: self.window modalDelegate: nil didEndSelector: NULL contextInfo: NULL ];
}

@end
