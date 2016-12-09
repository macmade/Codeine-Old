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

#import "Project.h"

@implementation Project

+ ( Project * )projectWithPath: ( NSString * )path
{
    ( void )path;
    
    return nil;
}

+ ( Project * )createProjectOfType: ( ProjectType )type withPath: ( NSString * )path
{
    ( void )path;
    ( void )type;
    
    return nil;
}

- ( id )initWithPath: ( NSString * )path
{
    ( void )path;
    
    return nil;
}

- ( void )addSourceFile: ( NSString * )name
{
    ( void )name;
}

- ( void )addHeaderFile: ( NSString * )name
{
    ( void )name;
}

- ( void )addLibrarySourceFile: ( NSString * )name
{
    ( void )name;
}

- ( void )addLibraryHeaderFile: ( NSString * )name
{
    ( void )name;
}

- ( void )updateSourceFile: ( NSString * )name withContent: ( NSString * )content
{
    ( void )name;
    ( void )content;
}

- ( void )updateHeaderFile: ( NSString * )name withContent: ( NSString * )content
{
    ( void )name;
    ( void )content;
}

- ( void )updateLibrarySourceFile: ( NSString * )name withContent: ( NSString * )content
{
    ( void )name;
    ( void )content;
}

- ( void )updateLibraryHeaderFile: ( NSString * )name withContent: ( NSString * )content
{
    ( void )name;
    ( void )content;
}

- ( NSString * )contentsOfSourceFile: ( NSString * )name
{
    ( void )name;
    
    return nil;
}

- ( NSString * )contentsOfHeaderFile: ( NSString * )name
{
    ( void )name;
    
    return nil;
}

- ( NSString * )contentsOfLibrarySourceFile: ( NSString * )name
{
    ( void )name;
    
    return nil;
}

- ( NSString * )contentsOfLibraryHeaderFile: ( NSString * )name
{
    ( void )name;
    
    return nil;
}

- ( NSArray * )sourceFiles
{
    @synchronized( self )
    {
        return [ NSArray arrayWithArray: _sourceFiles ];
    }
}

- ( NSArray * )headerFiles
{
    @synchronized( self )
    {
        return [ NSArray arrayWithArray: _headerFiles ];
    }
}

- ( NSArray * )librarySourceFiles
{
    @synchronized( self )
    {
        return [ NSArray arrayWithArray: _librarySourceFiles ];
    }
}

- ( NSArray * )libraryHeaderFiles
{
    @synchronized( self )
    {
        return [ NSArray arrayWithArray: _libraryHeaderFiles ];
    }
}

@end
