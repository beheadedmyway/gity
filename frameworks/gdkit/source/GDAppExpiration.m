//copyright aaronsmith 2009

#import "GDAppExpiration.h"

@implementation GDAppExpiration
@synthesize launchCount;
@synthesize runsForDays;
@synthesize maxLaunches;

- (id) init {
	if(self = [super init]) {
		[self setMaxLaunches:GDAppExpiresAfterLaunches];
	}
	return self;
}

+ (Boolean) isBetaExpired {
#ifdef GDAppBetaExpiresAfter
	NSString * compileDateString = [NSString stringWithUTF8String:__DATE__];
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
	[dateFormatter setDateFormat:@"MMM dd yyyy"];
	NSDate * compileDate = [dateFormatter dateFromString:compileDateString];
	[dateFormatter release];
	NSDate * expireDate = [compileDate addTimeInterval:(60*60*24*GDAppBetaExpiresAfter)];
	if([expireDate earlierDate:[NSDate date]] == expireDate) return TRUE;
	return FALSE;
#else
	return FALSE;
#endif
}

- (Boolean) hasExceededMaxLaunches {
	/*if([self launchCount] == NULL) {
		//set launch count to 1 and save it
	}
	if([self maxLaunches] == NULL) [self setMaxLaunches:GDAppExpiresAfterLaunches];
	return ([self launchCount] > [self maxLaunches]);*/
	return TRUE;
}

- (Boolean) hasClientExpired {
	return TRUE;
}

- (void) applicationLaunched {
	[self setLaunchCount:[self launchCount]+1];
}

@end
