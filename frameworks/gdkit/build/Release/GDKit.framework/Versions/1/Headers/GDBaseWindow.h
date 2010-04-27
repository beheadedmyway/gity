
#import <Cocoa/Cocoa.h>
#import "macros.h"
#import "GDResponderHelper.h"

/**
 * @file GDBaseWindow.h
 * 
 * Header file for GDBaseWindow.
 */

@class GDDocument;
@class GDApplicationController;

/**
 * The GDBaseWindow is a base NSWindow that contains common things
 * for gdkit.
 */
@interface GDBaseWindow : NSWindow {
	/**
	 * A GDApplicationController or a GDDocument.
	 */
	IBOutlet id gd;
	
	/**
	 * A GDExternalNibController.
	 */
	IBOutlet id externalNibController;
}

/**
 * A GDApplicationController or a GDDocument.
 */
@property (assign,nonatomic) IBOutlet id gd;

/**
 * A GDExternalNibController.
 */
@property (assign,nonatomic) IBOutlet id externalNibController;

/**
 * A hook you can use to set references to properties on
 * a "gd" instance.
 */
- (void) setGDRefs;

/**
 * A hook you can override to do some lazy initialization. This
 * is called last after any lazyInitWith(...) method is called.
 */
- (void) lazyInit;

/**
 * Lazy init this object with a GDDocument, or GDApplicationController. This just sets the "gd" property.
 *
 * @param _gd A GDDocument or GDApplicationController.
 */
- (void) lazyInitWithGD:(id) _gd;

/**
 * Used to see if either "[self delegate] or "self" respond to special
 * selectors (like onEscapeKey:). Those methods are called when the right
 * key is pressed.
 * 
 * Currently this method checks for these:
 *
 * <ul>
 * <li>order: [self delegate],self | selector: onEscapeKey:</li>
 * </ul>
 */
- (void) keyDown:(NSEvent *) theEvent;

@end
