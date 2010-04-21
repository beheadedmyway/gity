//copyright 2009 aaronsmith

#import <Cocoa/Cocoa.h>
#import "GDAccessibilityManager.h"
#import "GDAccessibilityNotification.h"
#import "GDAccessibilityObserver.h"

/**
 * @file GDAccessibilityObserver.h
 *
 * Header file for GDAccessibilityObserver.
 */

/**
 * The GDAccessibilityObserver is an object oriented wrapper around
 * accessibility notifications.
 *
 * It wraps a few function calls that create an accessibility observer:
 * AXObserverCreate(), CFRunLoopAddSource(), AXObserverAddNotification() and
 * AXObserverGetRunLoopSource().
 * 
 * Use this for notifications that post from accessibility objects. Accessibility
 * notifications don't post from NSNotificationCenters, they post from the
 * NSAccessibilityPostNotification() function.
 *
 * Here's an extracted example of how you use it:
 * @code
 * @implementation MyObject : NSObject
 * - (id) initWithAppInfo:(NSDictionary *) appinfo {
 * 	GDAccessibilityObserver * activated; //should be an instance variable if it needs to hang around in memory.
 * 	GDAccessibilityManager * accessManager; //should be instance variable
 * 	if(self = [self init]) {
 * 		appInfo = [appinfo retain];
 * 		appPid = (pid_t)[[appInfo valueForKey:@"NSApplicationProcessIdentifier"] intValue];
 * 		GDAccessibilityOperationResult * appres = [accessManager applicationRefFromPid:appPid];
 * 		if([appres wasSuccess]) {
 * 			appRef = (AXUIElementRef)[appres result];
 * 			CFRetain((CFTypeRef)appRef);
 * 			activated = [[GDAccessibilityObserver alloc] initWithNotification:NSAccessibilityApplicationActivatedNotification forAXUIElementRef:appRef \
 * 						callsAction:@selector(applicationDidActivate:) onTarget:self withUserInfo:appInfo];
 * 		} else {
 * 			return nil;
 * 		}
 * 	}
 * 	return self;
 * }
 * @end
 * @endcode
 *
 * The important thing to remember is that it can subscribe to notifications
 * from any AXUIElementRef. Use the GDAccessibilityManager to get the right
 * reference you need.
 *
 * @see http://developer.apple.com/mac/library/documentation/Accessibility/Reference/AccessibilityLowlevel/AXUIElement_h/CompositePage.html#//apple_ref/c/func/AXObserverCreate
 * @see http://developer.apple.com/mac/library/documentation/Accessibility/Reference/AccessibilityLowlevel/AXUIElement_h/CompositePage.html#//apple_ref/c/func/AXObserverAddNotification
 * @see http://developer.apple.com/mac/library/documentation/Accessibility/Reference/AccessibilityLowlevel/AXUIElement_h/CompositePage.html#//apple_ref/c/func/AXObserverGetRunLoopSource
 * @see http://developer.apple.com/mac/library/documentation/Cocoa/Reference/ApplicationKit/Miscellaneous/AppKit_Functions/Reference/reference.html#//apple_ref/c/func/NSAccessibilityPostNotification
 * @see Also see carbon run loops and CFRunLoopAddSource().
 */
@interface GDAccessibilityObserver : NSObject {
	
	/**
	 * The application's pid.
	 */
	pid_t app_pid;
	
	/**
	 * The target for the notification callback.
	 */
	id actionTarget;
	
	/**
	 * The selector on the callback target.
	 */
	SEL actionSelector;
	
	/**
	 * An accessibility observer reference.
	 */
	AXObserverRef observer;
	
	/**
	 * The accessibility element reference.
	 */
	AXUIElementRef element;
	
	/**
	 * An invoker that calls the target/selector when the accessibility
	 * notification occurs.
	 */
	NSInvocation * invoker;
	
	/**
	 * Method signature for the callback selector.
	 */
	NSMethodSignature * selectorSignature;
	
	/**
	 * User info dictionary passed on notification.
	 */
	NSDictionary * userInfo;
	
	/**
	 * The notification name.
	 */
	NSString * notification;
	
	/**
	 * Singleton instance of the GDAccessibilityManager.
	 */
	GDAccessibilityManager * accessManager;
	
	/**
	 * An instance of an GDAccessibilityNotification.
	 */
	GDAccessibilityNotification * notify;
}

/**
 * Designated initializer - init with required parameters.
 *
 * @param notification The notification to subscribe to.
 * @param element The AXUIElementRef to listen for posted notifications from.
 * @param action A callback selector.
 * @param target A callback target object.
 * @param userInpho A user info dictionary.
 */
- (id) initWithNotification:(NSString *) notification forAXUIElementRef:(AXUIElementRef) element callsAction:(SEL) action onTarget:(id) target withUserInfo:(NSDictionary *) userInpho;

@end

@interface  GDAccessibilityObserver (Private)

//returns the invoker for this observer.
- (NSInvocation *) invoker;

@end
