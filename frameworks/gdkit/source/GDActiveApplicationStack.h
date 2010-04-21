//copyright aaronsmith 2009

#import <Cocoa/Cocoa.h>
#import "NSWorkspace+Additions.h"

/**
 * @file GDActiveApplicationStack.h
 * 
 * Header file for GDActiveApplicationStack.
 */

#ifdef GDKIT_WARN_1060_ONLY
#	ifndef MAC_OS_X_VERSION_10_6
#		warning GDActiveApplicationStack requires 10.6
#	endif
#endif

#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5

/**
 * The GDActiveApplicationStack keeps a stack
 * of application info dictionaries.
 *
 * When application focus changes, an entry is added into the stack.
 */
@interface GDActiveApplicationStack : NSObject {
	short limit;
	BOOL onlyBringActiveApplicationsForward;
	
	/**
	 * The stack used to keep track of active applications.
	 */
	NSMutableArray * stack;
	
	/**
	 * NSWorkspace reference.
	 */
	NSWorkspace * workspace;
	
	/**
	 * The notification center from the workspace.
	 */
	NSNotificationCenter * center;
}

/**
 * The application stack limit.
 */
@property (assign) short limit;

/**
 * Only bring applications that are active forward. If a call
 * is made to bringTopForward, but the application that was saved
 * in the stack isn't active, it will pop(), and try again.
 *
 * If this isn't on, a call to bringTopForward will cause the
 * application to launch if it's not open.
 */
@property (assign) BOOL onlyBringActiveApplicationsForward;

/**
 * Check whether or not you can use this class.
 *
 * This is available because the only SDK this class will work
 * with is 10.6.
 */
+ (Boolean) isAvailable;

/**
 * Default init method.
 * 
 * If you don't want to risk an exception being thrown, first check
 * the +isAvailable method.
 *
 * @throws NSException If the obj-c runtime is running on 10.5 (Leopard) or less.
 */
- (id) init;

/**
 * Returns the top item in the stack.
 */
- (NSDictionary *) top;

/**
 * Returns the bottom item in the stack.
 */
- (NSDictionary *) bottom;

/**
 * Pops an application off the stack, then brings the
 * the bottom application forward.
 */
- (void) popAndBringForward;

/**
 * Brings the top application forward.
 */
- (void) bringTopForward;

/**
 * Brings the bottom application forward.
 */
- (void) bringBottomForward;

@end

@interface GDActiveApplicationStack (Private)

/**
 * Initializes the workspace and listeners.
 */
- (void) initWorkspaceAndListeners;

/**
 * When the workspace changes active applications.
 */
- (void) onApplicationActivate;

@end

#endif