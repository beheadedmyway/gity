
#import <Cocoa/Cocoa.h>
#import "GDBaseObject.h"
#import "GDBaseOperation.h"

/**
 * @file GDOperationsController.h
 * 
 * Header file for GDOperationsController.
 */

/**
 * The GDOperationsController is a controller you should use
 * to expose methods to run GDBaseOperation instances. This helps break
 * apart logic by making sure your operations use libdispatch (GCD).
 *
 * Generally you want to expose a method (with optional parameters) that
 * just kick of an instance of an GDBaseOperation.
 * 
 * Set completion blocks on the operations which call a "complete" method on
 * this operation controller, which in turn trigger the callback.
 * 
 * Here's an example:
 * @code
 * // these are inside of your subclassed GDOperationsController:
 * - (void) runSomeOperationWithCallback:(GDCallback *) _callback {
 * 	[_callback retain];
 * 	GDBaseOperation * op = [[[GDBaseOperation alloc] init] autorelease];
 * 	NSOperationQueue * q = [[NSOperationQueue alloc] init];
 * 	[self addToCancelables:q];
 * 	[op setCompletionBlock:^{
 * 		[self removeFromCancelables:q];
 * 		[q release];
 * 		[self onMyOperationComplete:_callback];
 * 		[_callback autorelease];
 * 	}];
 * 	[q addOperation:op];
 * }
 * 
 * - (void) onMyOperationComplete:(GDCallback) _callback {
 * 	//...do something.
 * 	[_callback execute];
 * }
 * 
 * // somewhere else:
 * - (void) someMethod {
 * 	GDCallback * cb = [[[GDCallback alloc] initWithTarget:self andAction:@selector(onOperationComplete)] autorelease];
 * 	[cb setExecutesOnMainThread:true];
 * 	[[gd operations] runSomeOperationWithCallback:cb];
 * }
 * 
 * - (void) onOperationComplete {
 * 	NSLog(@"finished operation");
 * }
 * @endcode
 * 
 * You should also keep track of all running operations and queues and make sure they
 * can be canceled. For a catch all generic way you can use the addToCancelables:
 * and removeFromCancelables: methods. If you add more logic and canceling behavior
 * make sure to override the cancelAll method, write your own logic, then call
 * [super cancelAll].
 */
@interface GDOperationsController : GDBaseObject {
	
	/**
	 * Whether or not the operation controller is currently canceling
	 * all operations; a flag for thread safety.
	 */
	BOOL cancelingAll;
	
	/**
	 * An array used to store running operations or queues which can be canceled
	 * when cancelAll is called.
	 */
	NSMutableArray * cancelables;
}

/**
 * Cancel's all operations in the "cancelables" property.
 */
- (void) cancelAll;

/**
 * Add an object to the list of cancelables.
 *
 * @param _obj An NSOperation, or NSOperationQueue; or any subclasses like GDBaseOperation, etc.
 */
- (void) addToCancelables:(id) _obj;

/**
 * Remove an object from the list of cancelables.
 *
 * @param _obj An NSOperation, or NSOperationQueue; or any subclasses like GDBaseOperation, etc.
 */
- (void) removeFromCancelables:(id) _obj;

@end
