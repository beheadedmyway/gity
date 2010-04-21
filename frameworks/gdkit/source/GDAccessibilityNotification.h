//copyright 2009 aaronsmith

#import <Cocoa/Cocoa.h>

/**
 * @file GDAccessibilityNotification.h
 *
 * Header file for GDAccessibilityNotification.
 */

/**
 * The GDAccessibilityNotification is the object passed to your selecter or
 * notification handler from a GDAccessibilityObserver.
 *
 * You shouldn't use this directly.
 *
 * @see GDAccessibilityObserver
 */
@interface GDAccessibilityNotification : NSObject {
	
	NSString * notification;
	
	/**
	 * The AXUIElementRef that triggered the notification.
	 */
	AXUIElementRef element;
	
	/**
	 * User info dictionary.
	 */
	NSDictionary * userInfo;
}

/**
 * The notification name that was triggered.
 */
@property (copy) NSString * notification;

/**
 * Designated initializeer - inits with required parameters.
 *
 * @param element An AXUIElementRef
 * @param notification The accessibility notification to subscribe to.
 * @param userInfo An optional user info dictionary that get's passed back to your handler.
 */
- (id) initWithElement:(AXUIElementRef) element forNotification:(NSString *) notification withUserInfo:(NSDictionary *) userInfo;

/**
 * Set the element that triggered the notification.
 *
 * @param element An AXUIElementRef
 */
- (void) setElement:(AXUIElementRef) element;

/**
 * Get the element.
 */
- (AXUIElementRef) element;

/**
 * Set the user info dictionary.
 *
 * @param userInfow The user info dictionary.
 */
- (void) setUserInfo:(NSDictionary *) userInfow;

/**
 * Get the user info dict.
 */
- (NSDictionary *) userInfo;

@end
