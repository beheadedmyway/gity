
#import <Cocoa/Cocoa.h>
#import "macros.h"
#import "GDResponderHelper.h"

/**
 * @file GDBaseResponder.h
 * 
 * Header file for GDBaseResponder.
 */

@class GDDocument;
@class GDApplicationController;

/**
 * The GDBaseResponder is a base NSResponder that implements base
 * key down functionality for the most commonly used operations.
 */
@interface GDBaseResponder : NSResponder {
	
	/**
	 * A GDApplicationController or a GDDocument.
	 */
	id gd;
}

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
 * Lazy init this object with a GDDocument or GDApplicationController. This just sets the "gd" property.
 *
 * @param _gd A GDDocument or GDApplicationController.
 */
- (void) lazyInitWithGD:(id) _gd;

/**
 * Used to catch some very common key down sequences and call methods
 * on self when they occur.
 */
- (void) keyDown:(NSEvent *) theEvent;

/**
 * When the escape key has been pressed.
 */
- (void) onEscapeKey:(id) sender;

@end
