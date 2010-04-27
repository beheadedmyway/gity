
#import <Cocoa/Cocoa.h>
#import <GDKit/GDKit.h>

/**
 * @file GDWindowController.h
 * 
 * Header file for GDWindowController.
 */

/**
 * The GDWindowController is controller you should use to 
 * expose references to windows, and any operations related to
 * those windows.
 */
@interface GDWindowController : GDBaseObject {
	
	/**
	 * An NSWindow that is given main window status. This is
	 * not the same as main/key window - this simply means the
	 * window that is the main window from a possible collection
	 * of other windows.
	 */
	NSWindow * mainWindow;
}

/**
 * An NSWindow that is given main window status. This is
 * not the same as main/key window - this simply means the
 * window that is the main window from a possible collection
 * of other windows.
 */
@property (assign,nonatomic) IBOutlet NSWindow * mainWindow;

@end
