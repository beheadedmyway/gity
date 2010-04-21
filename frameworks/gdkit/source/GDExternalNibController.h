
#import <Cocoa/Cocoa.h>
#import "macros.h"
#import "GDBaseObject.h"
#import "GDCallback.h"

/**
 * @file GDExternalNibController.h
 * 
 * Header file for GDExternalNibController.
 */

@class GDDocument;
@class GDWindowController;

/**
 * The GDExternalNibController is a controller used to manage
 * an external nib. It has shortcuts for showing the nib, or showing
 * it as a sheet, and can auto dispose of the nib resources when
 * it's closed.
 */
#if MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_5
@interface GDExternalNibController : GDBaseObject <NSWindowDelegate> {
#else
@interface GDExternalNibController : GDBaseObject {
#endif
	
	/**
	 * Whether or not the managed nib was shown as a sheet.
	 */
	BOOL isSheet;
	
	/**
	 * Whether or not nib resources are available.
	 */
	BOOL available;
	
	/**
	 * Whether or not to dispose of nibs when a window closes.
	 */
	BOOL disposesNibsOnWindowClose;
	
	/**
	 * Whether or not to dispose of nibs when the escape key is pressed.
	 */
	BOOL disposesNibsOnEscapeKey;
	
	/**
	 * A flag used to manage when a switch from sheet to window is made.
	 */
	BOOL switchingToWindow;
	
	/**
	 * A flag used to manage when a switch from window to sheet is made.
	 */
	BOOL switchingToSheet;
	
	/**
	 * The nib name to load.
	 */
	NSString * nibName;
	
	/**
	 * A callback object to use for anything - generally when you "finish"
	 * some type of input nib; you'd trigger this callback, and the object
	 * that got the callback would handle what was chosen from the nib.
	 */
	GDCallback * callback;
	
	/**
	 * A GDWindowController.
	 */
	IBOutlet GDWindowController * windows;
}

/**
 * The nib name to load.
 */
@property (copy,nonatomic) NSString * nibName;

/**
 * A GDWindowController.
 */
@property (assign,nonatomic) IBOutlet GDWindowController * windows;

/**
 * Whether or not to dispose of nibs when a window closes.
 */
@property (assign,nonatomic) BOOL disposesNibsOnWindowClose;

/**
 * Whether or not to dispose of nibs when the escape key is pressed.
 */
@property (assign,nonatomic) BOOL disposesNibsOnEscapeKey;

/**
 * A callback object to use for anything - generally when you "finish"
 * some type of input nib; you'd trigger this callback, and the object
 * that got the callback would handle what was chosen from the nib.
 */
@property (retain,nonatomic) GDCallback * callback;

/**
 * Disposes nibs.
 */
- (void) close:(id) sender;

/**
 * A hook you can use to close any windows other than [windows mainWindow].
 */
- (void) closeWindows;

/**
 * Dispose of the nibs that were loaded for this controller.
 */
- (void) disposeNibs;

/**
 * Lazy init this object with a GDDocument, or a GDApplicationController and the nib name to manage.
 *
 * @param _gd A GDDocument or GDApplicationController.
 * @param _nibName The nib name to manage.
 */
- (void) lazyInitWithGD:(id) _gd andNibName:(NSString *) _nibName;

/**
 * Lazy init this object with a GDDocument, or a GDApplicationController the nib name to manage and a callback.
 *
 * @param _gd A GDDocument or GDApplicationController.
 * @param _nibName The nib name to manage.
 * @param _callback A GDCallback.
 */
- (void) lazyInitWithGD:(id) _gd andNibName:(NSString *) _nibName andCallback:(GDCallback *) _callback;

/**
 * Loads the nib this controller is managing.
 */
- (void) loadNibs;

/**
 * Loads the nib this controller is managing. This is a hook
 * you can use to do something after the nibs have loaded, to "prepare"
 * them; but generally you probably won't need this.
 */
- (void) prepare;

/**
 * [internal]
 */
- (void) resetSwitchFlags;

/**
 * Shortcut to set disposesNibsOnEscapeKey and disposesNibsOnWindowClose.
 */
- (void) setDisposesNibsOnEscapeKey:(BOOL) _disposeOnEscape andDisposesNibsOnWindowClose:(BOOL) _disposeOnWinClose;

/**
 * Shortcut to set the nib name and callback.
 */
- (void) setNibName:(NSString *) _nibName andCallback:(GDCallback *) _callback;

/**
 * Loads nibs and sends [[windows mainWindow] makeKeyAndOrderFront:nil].
 */
- (void) show;

/**
 * Loads nibs and sends [[NSApplication sharedApplication] beginSheet:[windows mainWindow] modalForWindow:_window modalDelegate:self didEndSelector:@selector(sheetEnded) contextInfo:nil].
 */
- (void) showAsSheetForWindow:(NSWindow *) _window;

/**
 * When then sheet has ended.
 */
- (void) sheetEnded;

/**
 * Init this object with a GDDocument, or a GDApplicationController and a nib name. This is for a true alloc/init combination.
 *
 * @param _gd A GDDocument or GDApplicationController.
 * @param _nibName The managed nib name.
 */
- (id) initWithGD:(id) _gd andNibName:(NSString *) _nibName;

/**
 * Init this object with a GDDocument, nib name, and callback. This is for a true alloc/init combination.
 *
 * @param _gd A GDDocument or GDApplicationController.
 * @param _nibName The managed nib name.
 * @param _callback A GDCallback.
 */
- (id) initWithGD:(id) _gd andNibName:(NSString *) _nibName andCallback:(GDCallback *) _callback;


@end
