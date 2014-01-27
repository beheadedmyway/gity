
#import <Cocoa/Cocoa.h>
#import <GDKit/GDKit.h>
#import "macros.h"

/**
 * @file GDDocument.h
 * 
 * Header file for GDDocument.
 */

/**
 * The GDDocument is the controller for a document-based
 * cocoa application, this is the equivalent of GDApplicationController
 * (but for document architecture).
 *
 * <b>This class is also the NSWindowDelegate</b>
 * 
 * @see GDApplicationController For the non-document based cocoa application controller.
 * @see You should look at the example in gdkit/examples/CocoaApp_Document/
 */
#if MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_5
@interface GDDocument : NSDocument <NSWindowDelegate> {
#else
@interface GDDocument : NSDocument {
#endif
	
	/**
	 * Whether or not this document has been active yet (loaded from nib).
	 * This is used to stop mainMenu invalidation happening on first nib load.
	 */
	BOOL documentHasBeenActive;
	
	/**
	 * Whether or not this application has awoken from a nib.
	 */
	BOOL awokeFromNib;
	
	/**
	 * A GDModel.
	 */
	id model;
	
	/**
	 * A GDMainMenuController.
	 */
	id mainMenu;
	
	/**
	 * A GDModalController.
	 */
	id modals;
	
	/**
	 * A GDOperationsController
	 */
	id operations;
	
	/**
	 * A GDSoundController.
	 */
	id sounds;
	
	/**
	 * A GDViewController.
	 */
	IBOutlet id views;
	
	/**
	 * A GDWindowController
	 */
	IBOutlet id wins;
	
	/**
	 * A GDDrawerController.
	 */
	IBOutlet id drawers;
	
	/**
	 * A GDContextMenuController.
	 */
	IBOutlet id contexts;
}

@property (readonly,nonatomic) id model;
@property (readonly,nonatomic) id operations;
@property (readonly,nonatomic) id mainMenu;
@property (readonly,nonatomic) id modals;
@property (readonly,nonatomic) id sounds;

/**
 * A GDViewController.
 */
@property (strong,nonatomic) IBOutlet id views;

/**
 * A GDWindowController.
 */
@property (strong,nonatomic) IBOutlet id wins;

/**
 * A GDDrawerController.
 */
@property (strong,nonatomic) IBOutlet id drawers;

/**
 * A GDContextMenuController.
 */
@property (strong,nonatomic) IBOutlet id contexts;
	
/**
 * Designated <b>lazy</b> initializer to provide values for
 * all needed properties. <b>nil's are ok</b>.
 *
 * All parameters are sent <b>[obj performSelector:\@selector(lazyInitWithGD:) withObject:self]</b>
 *
 * <b>All parameters are retained, so please send in autoreleased instances.</b>
 *
 * If you send in any objects that are already properties (from IBOutlets) they
 * are not retained, but they are sent the designated lazy initializer.
 *
 * @param _model A GDModel or subclassed instance.
 * @param _modals A GDModalController or subclassed instance.
 * @param _operations A GDOperationsController or subclassed instance.
 * @param _windows A GDWindowController or subclassed instance.
 * @param _drawers A GDDrawerController or subclassed instance.
 * @param _views A GDViewController or subclassed instance.
 * @param _sounds A GDSoundController or subclassed instance.
 * @param _contexts A GDContextMenuController or subclassed instance.
 * 
 * @see GDBaseObject
 */
- (void) lazyInitWithModel:(id) _model mainMenu:(id) _mainMenu modals:(id) _modals operations:(id) _operations windows:(id) _windows drawers:(id) _drawers views:(id) _views sounds:(id) _sounds contexts:(id) _contexts;
	
/**
 * A hook you should use to initialize your document's "gd" properties, and call
 * [self lazyInitWithModel:mainMenu:modals:operations:windows:drawers:views:sounds:]
 *
 * You should call [super lazyInitWithModel(...)] as the last call.
 *
 * This method calls the other initializers:
 *
 * @code
 * [self initModel];
 * [self initControllers];
 * [self initWindows];
 * [self initViews];
 * [self startDocument];
 * @endcode
 */
- (void) initDocument;

/**
 * A hook to initialize a GDModel. This is a good place to initialize
 * A GDApplicationInfo instance and save it on the model.
 */
- (void) initModel;

/**
 * A hook to initializes any other controllers (maybe external nib controllers)
 * your using - make sure they also get lazyInited as well.
 */
- (void) initControllers;

/**
 * A hook to initialize any windows.
 */
- (void) initWindows;

/**
 * A hook to initialize any views - this is specifically for initializing views
 * that don't have "gd" references from nib creation time. IE: calling
 * lazyInitWithGD:
 *
 * @see GDBaseObject
 */
- (void) initViews;

/**
 * A hook to start your document - this is called after all initialization
 * logic hooks.
 */
- (void) startDocument;

/**
 * This triggers the [self initDocument];
 */
- (void) windowControllerDidLoadNib:(NSWindowController *) aController;

/**
 * When a window becomes main. This triggers a [mainMenu invalidate] call.
 */
- (void) windowDidBecomeMain:(NSNotification *) notification;

@end
