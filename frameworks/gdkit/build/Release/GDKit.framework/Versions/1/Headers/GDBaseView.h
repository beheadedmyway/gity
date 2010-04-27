
#import <Cocoa/Cocoa.h>
#import "macros.h"

/**
 * @file GDBaseView.h
 * 
 * Header file for GDBaseView.
 */

@class GDDocument;
@class GDApplicationController;

/**
 * The GDBaseView is a base NSView that contains helper
 * methods for many view needs.
 */
@interface GDBaseView : NSView {
	
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
 * Show this view inside of another view. No frame adjustments are made.
 */
- (void) showInView:(NSView *) view;

/**
 * Sets this views frame to match the other views frame, then shows
 * this view in the other view.
 */
- (void) showMaximizedInView:(NSView *) view;

/**
 * A quick shortcut to show this view inside of another view, when you know
 * that some minor adjustments need to be made.
 *
 * This method looks like this:
 * @code
 * - (void) showInView:(NSView *) view withAdjustments:(NSRect) _adjust {
 *     NSRect newFrame=[view frame];
 *     newFrame.size.width+=_adjust.size.width;
 *     newFrame.size.width+=_adjust.size.height;
 *     newFrame.origin.x+=_adjust.origin.x;
 *     newFrame.origin.y+=_adjust.origin.y;
 *     [self setFrame:newFrame];
 *     [view addSubview:self];
 * }
 * @endcode
 *
 * So you can use this to your advantage:
 * @code
 * [myView showInView:otherView withAdjustments:NSMakeRect(10,-5,-10,10)];
 * @endcode
 */
- (void) showInView:(NSView *) view withAdjustments:(NSRect) _adjust;

@end
