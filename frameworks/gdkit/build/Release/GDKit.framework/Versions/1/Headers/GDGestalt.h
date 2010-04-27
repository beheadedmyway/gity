
#import <Cocoa/Cocoa.h>

/**
 * @file GDGestalt.h
 * 
 * Header file for GDGestalt.
 */

/**
 * The GDGestalt is a helper class with static methods
 * to simplify gettings information from the Gestalt manager.
 */
@interface GDGestalt : NSObject {
}

/**
 * The OS X system version (9,10,etc).
 */
+ (SInt32) gestaltSystemVersion;

/**
 * The OS X minor system version (3,4,5,6,etc)
 */
+ (SInt32) gestaltMinorVersion;

@end
