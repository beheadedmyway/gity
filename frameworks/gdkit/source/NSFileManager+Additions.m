//copyright 2009 aaronsmith

#import "NSFileManager+Additions.h"

@implementation NSFileManager (GDAdditions)

- (NSString *) applicationSupportFolder {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    return path;
}

- (NSString *) thisApplicationsSupportFolder {
	NSString * appname = [[NSBundle mainBundle] bundleIdentifier];
	NSString * path = [[self applicationSupportFolder] stringByAppendingPathComponent:appname];
	if(![self fileExistsAtPath:path]) {
		if(![self createDirectoryAtPath:path withIntermediateDirectories:TRUE attributes:nil error:nil]) path=nil;
		//<= 10.4 if(![self createDirectoryAtPath:path attributes:nil]) path = nil;
	}
	return path;
}

- (NSString *) thisApplicationsSupportFolderByAppName {
	NSString * appname = [[NSProcessInfo processInfo] processName];
	NSString * path = [[self applicationSupportFolder] stringByAppendingPathComponent:appname];
	if(![self fileExistsAtPath:path]) {
		if(![self createDirectoryAtPath:path withIntermediateDirectories:TRUE attributes:nil error:nil]) path=nil;
		//<= 10.4 if(![self createDirectoryAtPath:path attributes:nil]) path = nil;
	}
	return path;
}

@end
