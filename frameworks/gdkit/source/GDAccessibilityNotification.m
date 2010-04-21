//copyright 2009 aaronsmith

#import "GDAccessibilityNotification.h"

@implementation GDAccessibilityNotification

@synthesize notification;

- (id) initWithElement:(AXUIElementRef)elemnt forNotification:(NSString *)notificatn withUserInfo:(NSDictionary *) userInfow {
	self = [super init];
	if(self) {
		[self setElement:elemnt];
		[self setUserInfo:userInfow];
		[self setNotification:notificatn];
	}
	return self;
}

- (void) setElement:(AXUIElementRef) elemnt {
	if(element != elemnt) {
		if(element != NULL) CFRelease(element);
		element = elemnt;
		CFRetain(element);
	}
}

- (AXUIElementRef) element {
	return element;
}

- (void) setUserInfo:(NSDictionary *) userInfow {
	if(userInfo != userInfow) {
		[userInfo release];
		userInfo = [userInfow retain];
	}
}

- (NSDictionary *) userInfo {
	return userInfo;
}

- (void) dealloc {
	CFRelease(element);
	[notification release];
	[userInfo release];
	[super dealloc];
}

@end
