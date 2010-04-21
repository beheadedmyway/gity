
#import <Cocoa/Cocoa.h>

/**
 * @file GDDocumentController.h
 * 
 * Header file for GDDocumentController.
 */

/**
 * The GDDocumentController is an NSDocumentController for document
 * based cocoa applications.
 *
 * <b>This class is also the NSApplicationDelegate</b>
 *
 * @see You should look at the example in gdkit/examples/CocoaApp_Document/
 */
#if MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_5
@interface GDDocumentController : NSDocumentController <NSApplicationDelegate> {
#else
@interface GDDocumentController : NSDocumentController {
#endif

}

@end
