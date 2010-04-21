//copyright 2009 aaronsmith

#import "GDCallback.h"

@implementation GDCallback
@synthesize target;
@synthesize action;
@synthesize args;
@synthesize executesOnMainThread;

- (id) initWithTarget:(id) _target andAction:(SEL) _action {
	self=[super init];
	[self setTarget:_target];
	[self setAction:_action];
	[self setupInvoker];
	return self;
}

- (id) initWithTarget:(id) _target andAction:(SEL) _action andArgs:(NSArray *) _args {
	self=[super init];
	[self setTarget:_target];
	[self setAction:_action];
	if(_args) [self setArgs:_args];
	else [self setupInvoker];
	return self;
}

- (void) setupInvoker {
	GDRelease(signature);
	GDRelease(invoker);
	signature=[[[self target] methodSignatureForSelector:[self action]] retain];
	invoker=[[NSInvocation invocationWithMethodSignature:signature] retain];
	[invoker setTarget:[self target]];
	[invoker setSelector:[self action]];
}

- (void) setArgs:(NSArray *) _args {
	if(args neq _args) {
		GDRelease(invoker);
		GDRelease(signature);
		GDRelease(args);
	}
	if(_args is nil) {
		GDRelease(args);
		return;
	}
	id arg;
	int c=1;
	args=[_args retain];
	[self setupInvoker];
	for(arg in args)[invoker setArgument:&arg atIndex:++c];
}

- (void) execute {
	if(executesOnMainThread) [self executeOnMainThread];
	else [invoker invoke];
}

- (void) executeOnMainThread {
	[self performSelectorOnMainThread:@selector(execute) withObject:nil waitUntilDone:false];
}

- (void) getReturnValue:(void *) _resultAddress {
	[invoker getReturnValue:&_resultAddress];
}

- (void) dealloc {
	#ifdef GDKIT_PRINT_DEALLOCS
	printf("dealloc GDCallback\n");
	#endif
	GDRelease(invoker);
	GDRelease(signature);
	GDRelease(target);
	GDRelease(args);
	[super dealloc];
}

@end
