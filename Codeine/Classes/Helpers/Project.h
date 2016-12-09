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

typedef enum
{
    ProjectTypeC    = 0x00,
    ProjectTypeCPP  = 0x01,
    ProjectTypeObjC = 0x02
}
ProjectType;

@interface Project: NSObject
{
@protected
    
    NSMutableArray * _sourceFiles;
    NSMutableArray * _headerFiles;
    NSMutableArray * _librarySourceFiles;
    NSMutableArray * _libraryHeaderFiles;
    
@private
    
    id _Project_Reserved[ 5 ];
}

@property( readonly ) NSArray * sourceFiles;
@property( readonly ) NSArray * headerFiles;
@property( readonly ) NSArray * librarySourceFiles;
@property( readonly ) NSArray * libraryHeaderFiles;

+ ( Project * )projectWithPath: ( NSString * )path;
+ ( Project * )createProjectOfType: ( ProjectType )type withPath: ( NSString * )path;
- ( id )initWithPath: ( NSString * )path;

- ( void )addSourceFile: ( NSString * )name;
- ( void )addHeaderFile: ( NSString * )name;
- ( void )addLibrarySourceFile: ( NSString * )name;
- ( void )addLibraryHeaderFile: ( NSString * )name;

- ( void )updateSourceFile: ( NSString * )name withContent: ( NSString * )content;
- ( void )updateHeaderFile: ( NSString * )name withContent: ( NSString * )content;
- ( void )updateLibrarySourceFile: ( NSString * )name withContent: ( NSString * )content;
- ( void )updateLibraryHeaderFile: ( NSString * )name withContent: ( NSString * )content;

- ( NSString * )contentsOfSourceFile: ( NSString * )name;
- ( NSString * )contentsOfHeaderFile: ( NSString * )name;
- ( NSString * )contentsOfLibrarySourceFile: ( NSString * )name;
- ( NSString * )contentsOfLibraryHeaderFile: ( NSString * )name;

@end
