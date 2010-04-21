
#import <Cocoa/Cocoa.h>
#import "macros.h"

/**
 * @file GDBaseObject.h
 * 
 * Header file for GDBaseObject.
 */

@class GDDocument;
@class GDApplicationController;

/**
 * The GDBaseObject is a base object in GDKit that contains methods and
 * properties you'll always be using.
 */
@interface GDBaseObject : NSObject {
	
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
 * Lazy init this object with a GDDocument or GDApplicationController. This just sets the "gd" property.
 *
 * @param _gd A GDDocument or GDApplicationController.
 */
- (void) lazyInitWithGD:(id) _gd;

/**
 * Init this object with a GDDocument or GDApplicationController. This can be used for true alloc/init combinations.
 *
 * @param _gd A GDDocument or GDApplicationController.
 */
- (id) initWithGD:(id) _gd;

@end
