//copyright 2009 aaronsmith

#import "GDBaseOperation.h"

@implementation GDBaseOperation
@synthesize callback;

- (BOOL) isFinished {
	return done;
}

- (BOOL) isCancelled {
	return canceled;
}

- (void) main {
	done=true;
}

- (void) cancel	{
	canceled=true;
	[super cancel];
}

- (void) dealloc {
	GDRelease(callback);
	done=false;
	canceled=false;
}

@end
