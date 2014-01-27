
#import <Cocoa/Cocoa.h>
#import "GDBaseObject.h"

/**
 * @file GDModel.h
 * 
 * Header file for GDModel.
 */

/**
 * The GDModel is an object you should use as the model,
 * or place to store data that needs to be read, and written. This
 * will simplify handling thread safety with data access that many
 * components in the application need to use - you can also just
 * copy data from here, and store in a sandboxed area or view which
 * may not be concerned about thread safety.
 */
@interface GDModel : GDBaseObject {
	
	/**
	 * A GDApplicationInfo.
	 */
	id appInfo;
}

/**
 * A GDApplicationInfo.
 */
@property (strong,nonatomic) id appInfo;

@end
