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

#import "Localization.h"

#ifdef NSLocalizedString
#undef NSLocalizedString
#endif

NSString * localizedString( NSString * key, NSString * comment )
{
    NSString * label;
    
    ( void )comment;
    
    label = [ BUNDLE localizedStringForKey: key value: nil table: nil ];
    
    #ifdef DEBUG
    
    if( label == nil || label == key )
    {
        NSLog( @"Warning: label for key '%@' is not present in the localized strings table!", key );
    }
    
    #endif
    
    return label;
}
