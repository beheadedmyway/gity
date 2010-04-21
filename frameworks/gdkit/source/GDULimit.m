//copyright 2009 aaronsmith

#import "GDULimit.h"

@implementation GDULimit

+ (void) enableCoreDumps {
	struct rlimit r1;
	r1.rlim_cur = RLIM_INFINITY;
	r1.rlim_max = RLIM_INFINITY;
	setrlimit(RLIMIT_CORE,&r1);
}

@end
