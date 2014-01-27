//copyright 2009 aaronsmith

#import "GDViewController.h"

@implementation GDViewController

- (void) dealloc {
	#ifdef GDKIT_PRINT_DEALLOCS
	printf("dealloc GDViewController\n");
	#endif
	GDRelease(lastLoadedNibName);
}

- (void) loadViewsInNibNamed:(NSString *) _nibName {
	GDRelease(lastLoadedNibName);
	lastLoadedNibName=[_nibName copy];
	[NSBundle loadNibNamed:_nibName owner:self];
}

@end
