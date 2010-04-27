
#import <Cocoa/Cocoa.h>

/**
 * @file NSView+Additions.h
 *
 * Header file for NSView cocoa additions.
 */

/**
 * @class NSView
 *
 * Category additions to NSView.
 */
@interface NSView (GDAdditions)

/**
 * Whether or not to fix the left edge.
 */
- (void) fixLeftEdge:(BOOL) fixed;

/**
 * Whether or not to fix the right edge.
 */
- (void) fixRightEdge:(BOOL) fixed;

/**
 * Whether or not to fix the top edge.
 */
- (void) fixTopEdge:(BOOL) fixed;

/**
 * Whether or not to fix the bottom edge.
 */
- (void) fixBottomEdge:(BOOL) fixed;

/**
 * Whether or not to fix the width.
 */
- (void) fixWidth:(BOOL) fixed;

/**
 * Whether or not to fix the height.
 */
- (void) fixHeight:(BOOL) fixed;

@end
