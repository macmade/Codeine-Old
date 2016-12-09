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

/*!
 * @protocol        SingletonProtocol
 * @abstract        Protocol for singleton classes
 */
@protocol SingletonProtocol < NSObject >

@required

/*!
 * @method          sharedInstance
 * @abstract        Gets the shared (unique) instance of the class
 */
+ ( id )sharedInstance;

@end
