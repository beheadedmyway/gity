//copyright 2009 aaronsmith

#import "GDWindowController.h"

@implementation GDWindowController
@synthesize mainWindow;

- (void) dealloc {
	#ifdef GDKIT_PRINT_DEALLOCS
	printf("dealloc GDWindowController\n");
	#endif
	GDRelease(mainWindow);
	[super dealloc];
}

@end
