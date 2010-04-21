// Copyright Aaron Smith 2009
// 
// This file is part of Gity.
// 
// Gity is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// Gity is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with Gity. If not, see <http://www.gnu.org/licenses/>.

#import "GTCallback.h"

@implementation GTCallback
@synthesize target;
@synthesize action;
@synthesize args;

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
	if(signature) [signature release];
	if(invoker) [invoker release];
	invoker=nil;
	signature=nil;
	signature=[[self target] methodSignatureForSelector:[self action]];
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
	if(_args is nil) return;
	id arg;
	int c=1;
	args=[_args retain];
	[self setupInvoker];
	for(arg in args)[invoker setArgument:&arg atIndex:++c];
}

- (void) execute {
	[invoker invoke];
}

- (void) executeOnMainThread {
	[self performSelectorOnMainThread:@selector(execute) withObject:nil waitUntilDone:false];
}

- (void) getReturnValue:(void *) _resultAddress {
	[invoker getReturnValue:&_resultAddress];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTCallback\n");
	#endif
	GDRelease(invoker);
	GDRelease(signature);
	GDRelease(target);
	action=nil;
	[self setArgs:nil];
	[super dealloc];
}

@end
