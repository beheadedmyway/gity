
#import <Cocoa/Cocoa.h>
#import "GDBaseWindow.h"

/**
 * @file GDBaseSheetWindow.h
 * 
 * Header file for GDBaseSheetWindow.
 */

@class GDApplicationController;
@class GDDocument;

/**
 * The GDBaseSheetWindow is a GDBaseWindow that you should use for
 * windows that will be used as sheets - this class implements some default
 * responder behavior which all sheets should have.
 */
@interface GDBaseSheetWindow : GDBaseWindow	{
}

/**
 * Closes this sheet window.
 */
- (void) onEscapeKey:(id) sender;

@end
