//
//  NSUserDefaults+Hack.m
//  gitty
//
//  Created by brandon on 1/4/11.
//  Copyright 2011 redf.net. All rights reserved.
//

#import "NSUserDefaults+Hack.h"


@implementation NSUserDefaults(Hack)

/*- (BOOL)synchronize
{
	BOOL result = CFPreferencesAppSynchronize((CFStringRef)[[NSBundle mainBundle] bundleIdentifier]);
	if (!result)
	{
		// there's probably a temp file lingering around... try again.
		result = CFPreferencesAppSynchronize((CFStringRef)[[NSBundle mainBundle] bundleIdentifier]);
		
		// regardless of the result, lets clean up any temp files hanging around..
		NSString *prefsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences"];
		NSDirectoryEnumerator *dirEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:prefsDir];
		NSString *match = [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:@".plist."];
		NSString *file = nil;
		while ((file = [dirEnumerator nextObject]))
		{
			if ([file rangeOfString:match].location != NSNotFound)
			{
				NSString *fileToRemove = [prefsDir stringByAppendingPathComponent:file];
				[[NSFileManager defaultManager] removeItemAtPath:fileToRemove error:nil];
			}
		}
	}
	
	return result;
}*/

@end
