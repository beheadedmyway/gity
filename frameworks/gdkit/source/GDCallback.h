
#import <Cocoa/Cocoa.h>
#import "macros.h"
#import "GDBaseObject.h"

/**
 * @file GDCallback.h
 * 
 * Header file for GDCallback.
 */

/**
 * The GDCallback wraps an NSInvocation and NSMethodSignature to
 * simplify creating callbacks using those two classes.
 */
@interface GDCallback : NSObject {
	
	/**
	 * The callback target.
	 */
	id target;
	
	/**
	 * The selector.
	 */
	SEL action;
	
	/**
	 * Whether or not this callback executes on the main thread.
	 */
	BOOL executesOnMainThread;
	
	/**
	 * Arguments to send to the target/selector.
	 */
	NSArray * args;
	
	/**
	 * An NSInvocation.
	 */
	NSInvocation * invoker;
	
	/**
	 * An NSMethodSignature.
	 */
	NSMethodSignature * signature;
}

/**
 * The arguments for the target/selector.
 */
@property (retain,nonatomic) NSArray * args;

/**
 * The callback target.
 */
@property (retain,nonatomic) id target;

/**
 * Whether or not this callback executes on the main thread.
 */
@property (assign,nonatomic) BOOL executesOnMainThread;

/**
 * The selector.
 */
@property (assign,nonatomic) SEL action;

/**
 * Execute's this callback.
 */
- (void) execute;

/**
 * Execute's this callback on the main thread.
 */
- (void) executeOnMainThread;

/**
 * Get's the return value from the internal NSInvocation object.
 *
 * @param _resultAddress A pointer to the storage where you want the results
 * delivered to.
 */
- (void) getReturnValue:(void *) _resultAddress;

/**
 * Initialize this with a target and action.
 *
 * @param _target The target to call on.
 * @param _action The selector to send.
 */
- (id) initWithTarget:(id) _target andAction:(SEL) _action;

/**
 * Initialize this with a target, action and arguments.
 * 
 * @param _target The target to call on.
 * @param _action The selector to send.
 * @param _args The arguments to send to the callback.
 */
- (id) initWithTarget:(id) _target andAction:(SEL) _action andArgs:(NSArray *) _args;

/**
 * [internal]
 */
- (void) setupInvoker;

@end
