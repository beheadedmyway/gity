
#import <Cocoa/Cocoa.h>
#import "macros.h"

/**
 * @file GDResponderHelper.h
 * 
 * Header file for GDResponderHelper.
 */

/**
 * The GDResponderHelper is a helper that contains common methods you
 * can use in responders - this is nice so after write some generic code in
 * a responder it may or may not be useful to add into this class.
 */
@interface GDResponderHelper : NSObject {
}

/**
 * If the event is a key event, and the keyCode is the escape key,
 * send the target the specified action (only if it responds to it).
 */
+ (void) ifIsEscapeKey:(NSEvent *) event sendAction:(SEL) _action toTarget:(id) _target;

@end
