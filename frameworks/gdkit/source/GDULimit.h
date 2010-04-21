//copyright 2009 aaronsmith

#import <Cocoa/Cocoa.h>
#import "GDASLLog.h"

/**
 * @file GDULimit.h
 *
 * Header file for GDULimit.
 */

/**
 * The GDULimit contains helpers for environment resources through ulimit.
 */
@interface GDULimit : NSObject {
}

/**
 * Enables core dumps. This is the equivalent of running
 * 'ulimit -c unlimited'
 */
+ (void) enableCoreDumps;

@end
