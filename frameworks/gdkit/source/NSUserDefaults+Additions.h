//copyright 2009 aaronsmith

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

/**
 * @file NSUserDefaults+Additions.h
 *
 * Header file for NSUserDefaults cocoa additions.
 */

/**
 * @class NSUserDefaults
 *
 * Category additions to NSUserDefaults.
 */
@interface NSUserDefaults (GDAdditions)

/**
 * Deletes any entries identified the application's bundle id.
 */
+ (void) reset;

@end
