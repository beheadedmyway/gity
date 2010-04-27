
#import <Cocoa/Cocoa.h>
#import "GDBaseObject.h"

/**
 * @file GDMainMenuController.h
 * 
 * Header file for GDMainMenuController.
 */

@class GDBaseObject;

/**
 * The GDMainMenuController is controller you can use to manage
 * the main menu in the application. When your application changes, or
 * intoduces some state that requires the menu to update, you should
 * trigger an "invalidate" call. This controller should then ask
 * views, controllers, etc in the app about their state, and update the
 * main menu as needed.
 */
@interface GDMainMenuController : GDBaseObject {
	
	/**
	 * A reference to the applications main menu.
	 */
	NSMenu * mainMenu;
}

/**
 * A hook to invalidate the main menu.
 *
 * @see GDDocument
 */
- (void) invalidate;

@end
