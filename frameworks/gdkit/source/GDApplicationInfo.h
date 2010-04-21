
#import <Cocoa/Cocoa.h>
#import "macros.h"

/**
 * @file GDApplicationInfo.h
 * 
 * Header file for GDApplicationInfo.
 */

/**
 * The GDApplicationInfo is a an object used to store application information
 * in a dictionary like manner.
 *
 * It uses an NSMutableDictionary internally through composition.
 *
 * You can use this to extend, or write extensions to GDKit, and if any of
 * those extensions require some type of configiration, it can
 * be specified through this dictionary manually in code, or by loading in
 * a plist.
 *
 * @see GDModel
 */
@interface GDApplicationInfo : NSObject	{
	
	/**
	 * The dictionary exposed through composition.
	 */
	NSMutableDictionary * dictionary;
}

@property (retain,nonatomic) NSMutableDictionary * dictionary;

/**
 * Returns an autoreleased instance, and has already loaded the
 * main bundle's info dictionary.
 */
+ (GDApplicationInfo *) instanceFromDefaultPlist;

/**
 * Returns an autoreleased instance that was loaded from a plist.
 */
+ (GDApplicationInfo *) instanceFromLoadingPlist:(NSString *) _plist;

/**
 * Loads the main bundle's info dictionary and adds in those key/vals
 * to this dictionary.
 */
- (void) loadDefaultInfoPlist;

/**
 * Loads in a plist and merges it's key/vals into this dictionary.
 */
- (void) loadPlist:(NSString *) _plist;

@end
