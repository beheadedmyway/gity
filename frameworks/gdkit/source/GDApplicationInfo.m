//copyright 2009 aaronsmith

#import "GDApplicationInfo.h"

@implementation GDApplicationInfo
@synthesize dictionary;

+ (GDApplicationInfo *) instanceFromDefaultPlist {
	GDApplicationInfo * info = [[GDApplicationInfo alloc] init];
	[info loadDefaultInfoPlist];
	return info;
}

+ (GDApplicationInfo *) instanceFromLoadingPlist:(NSString *) _plist {
	GDApplicationInfo * info = [[GDApplicationInfo alloc] init];
	[info loadPlist:_plist];
	return info;
}

- (id) init {
	self=[super init];
	dictionary=[[NSMutableDictionary alloc] init];
	return self;
}

- (void) loadDefaultInfoPlist {
	[dictionary addEntriesFromDictionary:[[NSBundle mainBundle] infoDictionary]];
}

- (void) loadPlist:(NSString *) _plist {
	NSDictionary * dict=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_plist ofType:@"plist"]];
	[dictionary addEntriesFromDictionary:dict];
}

- (void) dealloc {
	GDRelease(dictionary);
}

@end
