
#import <Cocoa/Cocoa.h>
#import "GDCallback.h"

/**
 * @file GDBaseOperation.h
 * 
 * Header file for GDBaseNSTaskOperation.
 */

/**
 * The GDBaseOperation is a base NSOperation that sets up some
 * common properties for children operations.
 *
 * <b>WARNING</b>
 * NSOperation and NSOperationQueue behave differently between 10.5 and 10.6.
 * If you're creating concurency with those classes in an app that will run on
 * both 10.5 and 10.6, you definitely need to thoroughly test your code.
 */
@interface GDBaseOperation : NSOperation {
	
	/**
	 * Whether or not this operation is done.
	 */
	BOOL done;
	
	/**
	 * Whether or not this operation is canceled.
	 */
	BOOL canceled;
	
	/**
	 * An optional callback object you can use at any time.
	 */
	GDCallback * callback;
}

@property (strong,nonatomic) GDCallback * callback;

@end
