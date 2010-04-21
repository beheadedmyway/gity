//copyright 2009 aaronsmith

#import "NSUserDefaults+Additions.h"

@implementation NSUserDefaults (GDAdditions)

+ (void) reset {
	[[self standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
	[[self standardUserDefaults] synchronize];
}

@end
