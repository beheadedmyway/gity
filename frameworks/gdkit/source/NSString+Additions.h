
#import <Cocoa/Cocoa.h>

/**
 * @file NSString+Additions.h
 *
 * Header file for NSString cocoa additions.
 */

/**
 * @class NSString
 *
 * Category additions to NSString.
 */
@interface NSString (GDAdditions)

/**
 * Returns a c UTF8 string.
 */
- (const char *) cstring;

/**
 * Wether or not the string is equal to @"".
 */
- (BOOL) isEmpty;

/**
 * Whether or not the string contains a space.
 */
- (BOOL) containsSpace;

/**
 * Whether or not this string is empty or contains a space.
 */
- (BOOL) isEmptyOrContainsSpace;

@end
