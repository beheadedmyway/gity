
#import <Cocoa/Cocoa.h>
#import "GDBaseObject.h"

/**
 * @file GDViewController.h
 * 
 * Header file for GDViewController.
 */

/**
 * The GDViewController is a controller you should use
 * to expose references to views, and methods to control those views
 * in any way.
 */
@interface GDViewController : GDBaseObject {
	
	/**
	 * The last loaded nib's name. This can be
	 * useful if you need to do different logic
	 * on awakeFromNib.
	 */
	NSString * lastLoadedNibName;
}

/**
 * Loads a nib that contains some views this controller can use.
 * 
 * @param _nibName The nib name to load.
 */
- (void) loadViewsInNibNamed:(NSString *) _nibName;

@end
