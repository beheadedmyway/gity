
#import <Cocoa/Cocoa.h>
#import "GDBaseObject.h"

/**
 * @file GDContextMenuController.h
 * 
 * Header file for GDContextMenuController.
 */

/**
 * The GDContextMenuController is a controller that manages
 * all context menus.
 */
@interface GDContextMenuController : GDBaseObject {
}

/**
 * A hook you can use to invalidate any context menus. You should
 * use this to query controllers, views, etc and update context menu
 * states based off of any of those states.
 */
- (void) invalidate;

@end
