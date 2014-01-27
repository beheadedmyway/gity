//copyright 2009 aaronsmith

#import "GDModel.h"

@implementation GDModel
@synthesize appInfo;

- (void) dealloc {
	#ifdef GDKIT_PRINT_DEALLOCS
	printf("dealloc GDModel\n");
	#endif
}

@end
