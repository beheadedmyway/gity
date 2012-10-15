//copyright aaronsmith 2009

#import <AvailabilityMacros.h>
#import "GDActiveApplicationStack.h"

#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5

@implementation GDActiveApplicationStack
@synthesize limit;
@synthesize onlyBringActiveApplicationsForward;

- (id) init {
	if(NSAppKitVersionNumber < NSAppKitVersionNumber10_6) {
		[NSException raise:@"GDActiveApplicationStack requires 10.6" format:@""];
		return nil;
	}
	if(self = [super init]) {
		stack = [[NSMutableArray alloc] init];
		[self setLimit:10];
		[self initWorkspaceAndListeners];
	}
	return self;
}

+ (Boolean) isAvailable {
	if(NSAppKitVersionNumber < NSAppKitVersionNumber10_6) return FALSE;
	return TRUE;
}

- (NSDictionary *) top {
	if([stack count] < 1) return nil;
	NSUInteger index=[stack count]-1;
	return [stack objectAtIndex:index];
}

- (NSDictionary *) bottom {
	if([stack count] < 1) return nil;
	return [stack objectAtIndex:0];
}

- (void) popAndBringForward {
	if([stack count] < 1) return;
	[stack removeLastObject];
	if([stack count] < 1) return;
	[self bringTopForward];
}

- (void) bringTopForward {
	NSDictionary * top = [self top];
	[workspace bringApplicationToFront:top];
}

- (void) bringBottomForward {
	NSDictionary * app = [self bottom];
	[workspace bringApplicationToFront:app];
}

- (void) initWorkspaceAndListeners {
	workspace = [NSWorkspace sharedWorkspace];
	center = [workspace notificationCenter];
}

- (void) onApplicationActivate:(NSNotification *) notification {
	NSDictionary * app = [workspace activeApplication];
	if([stack count] == [self limit]) [stack removeObjectAtIndex:0];
	[stack addObject:app];
}

@end

#endif