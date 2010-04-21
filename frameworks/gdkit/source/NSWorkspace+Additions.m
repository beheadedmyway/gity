//copyright 2009 aaronsmith

#import "NSWorkspace+Additions.h"

@implementation NSWorkspace (GDAdditions)

- (void) bringApplicationToFront:(NSDictionary *) appInfo {
	if(appInfo == nil) return;
	NSString * appath = [appInfo valueForKey:@"NSApplicationPath"];
	if(appath == nil) return;
	[self launchApplication:appath];
}

- (void) bringCurrentApplicationToFront {
	[self launchApplication:[[NSBundle mainBundle] bundlePath]];
}

- (void) bringApplicationToFrontFromPath:(NSString *) appPath {
	if(!appPath) return;
	[self launchApplication:appPath];
}

- (void) openSystemPreference:(NSString *) preferencesFileName {
	NSFileManager * fm = [NSFileManager defaultManager];
	if([fm fileExistsAtPath:[@"/System/Library/PreferencePanes/" stringByAppendingString:preferencesFileName]]) {
		[[NSWorkspace sharedWorkspace] openFile:[@"/System/Library/PreferencePanes/" stringByAppendingString:preferencesFileName]];
	} else if([fm fileExistsAtPath:[@"~/Library/PreferencePanes/" stringByAppendingString:preferencesFileName]]) {
		[[NSWorkspace sharedWorkspace] openFile:[@"~/Library/PreferencePanes/" stringByAppendingString:preferencesFileName]];
	}
}

- (void) uninstallStartupLaunchdItem:(NSString *) plistName {
	NSFileManager * fm = [NSFileManager defaultManager];
	NSString * file = [[@"~/Library/LaunchAgents" stringByExpandingTildeInPath] stringByAppendingString:[@"/" stringByAppendingString:plistName]];
	[fm removeItemAtPath:file error:NULL];
}

- (void) installStartupLaunchdItem:(NSString *) plistName {
	NSFileManager * fm = [NSFileManager defaultManager];
	NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
	NSNumber * perms = [NSNumber numberWithUnsignedLong:448]; //700 octal = 448 decimal
	[attrs setObject:perms forKey:NSFilePosixPermissions];
	[fm createDirectoryAtPath:[@"~/Library/LaunchAgents/" stringByExpandingTildeInPath] withIntermediateDirectories:TRUE attributes:attrs error:nil];
	//<= 10.4 [fm createDirectoryAtPath:[@"~/Library/LaunchAgents/" stringByExpandingTildeInPath] attributes:attrs];
	NSBundle * bndl = [NSBundle mainBundle];
	NSString * noext = [plistName stringByDeletingPathExtension];
	NSString * path = [bndl pathForResource:noext ofType:@"plist"];
	NSString * dest = [[@"~/Library/LaunchAgents" stringByExpandingTildeInPath] stringByAppendingString:[@"/" stringByAppendingString:plistName]];
	[fm copyItemAtPath:path toPath:dest error:NULL];
}

@end
