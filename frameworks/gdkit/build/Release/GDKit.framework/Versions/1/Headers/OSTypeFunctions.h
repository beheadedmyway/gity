#import <Cocoa/Cocoa.h>

/**
 * @file OSTypeFunctions.h
 *
 * Helper functions for OSType conversions.
 */

/**
 * Convert an NSString of four characters into
 * an OSType.
 */
OSType fourCharCodeToOSType(NSString * inCode);

/**
 * Convert an OSType into an NSString of four chars.
 */
NSString * osTypeToFourCharCode(OSType inType);