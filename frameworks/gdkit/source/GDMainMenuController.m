//copyright 2009 aaronsmith

#import "GDMainMenuController.h"
#import "GDBaseObject.h"

@implementation GDMainMenuController

- (id) init {
	self=[super init];
	NSApplication * app=[NSApplication sharedApplication];
	mainMenu=[app mainMenu];
	return self;
}

- (void) invalidate {
	#ifdef GDKIT_METHOD_CALLS
	NSLog(@"invalidate");
	#endif
}

- (void) dealloc {
	#ifdef GDKIT_PRINT_DEALLOCS
	printf("dealloc GDMainMenuController\n");
	#endif
}

@end
