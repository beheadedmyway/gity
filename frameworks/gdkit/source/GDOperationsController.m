//copyright 2009 aaronsmith

#import "GDOperationsController.h"

@implementation GDOperationsController

- (id) init {
	self=[super init];
	cancelables=[[NSMutableArray alloc] init];
	return self;
}

- (void) cancelAll {
	if(cancelingAll) return;
	@synchronized(self) {
		cancelingAll=true;
		id obj;
		for(obj in cancelables) {
			if([obj isKindOfClass:[NSOperation class]])[obj cancel];
			else if([obj isKindOfClass:[NSOperationQueue class]])[obj cancelAllOperations];
		}
	}
	GDRelease(cancelables);
	cancelables=[[NSMutableArray alloc] init];
	cancelingAll=false;
}

- (void) addToCancelables:(id) obj {
	if(cancelables is nil) cancelables=[[NSMutableArray alloc] init];
	[cancelables addObject:obj];
}

- (void) removeFromCancelables:(id) _obj {
	if(cancelables is nil) return;
	[cancelables removeObject:_obj];
}

- (void) dealloc {	
	#ifdef GDKIT_PRINT_DEALLOCS
	printf("dealloc GDOperationsController\n");
	#endif
	GDRelease(cancelables);
	cancelingAll=false;
	[super dealloc];
}

@end
