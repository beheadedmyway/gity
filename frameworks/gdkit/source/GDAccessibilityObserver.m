//copyright 2009 aaronsmith

#import "GDAccessibilityObserver.h"

static void fHandleObserverCallback(AXObserverRef observer, AXUIElementRef element, CFStringRef notification, void * userInfo) {
	GDAccessibilityObserver * aco = (__bridge GDAccessibilityObserver *) userInfo;
	[[aco invoker] invoke];
}

@implementation GDAccessibilityObserver

- (id) initWithNotification:(NSString *) notificatin forAXUIElementRef:(AXUIElementRef) elemnt callsAction:(SEL) action onTarget:(id) target withUserInfo:(NSDictionary *) userInpho {
	if(self = [super init]) {
		if(!target || !action || !userInpho || !elemnt || !notificatin) return nil;
		//int callres = 0;
		accessManager = [GDAccessibilityManager sharedInstance];
		actionSelector = action;
		actionTarget = target;
		userInfo = userInpho;
		notification = [notificatin copy];
		element = elemnt;
		notify = [[GDAccessibilityNotification alloc] initWithElement:element forNotification:notificatin withUserInfo:userInpho];
		selectorSignature = [[target class] instanceMethodSignatureForSelector:action];
		invoker = [NSInvocation invocationWithMethodSignature:selectorSignature];
		[invoker setSelector:action];
		[invoker setTarget:target];
		[invoker retainArguments];
		__unsafe_unretained id tempNotify = notify;
		[invoker setArgument:&tempNotify atIndex:2];
		app_pid = [accessManager forAXUIElementRefGetPID:elemnt];
		//if(app_pid < 0) return nil;
		//callres = //TODO: Fix the callres stuff
		AXObserverCreate(app_pid,(void*)&fHandleObserverCallback,&observer);
		//if(callres != kAXErrorSuccess) return nil;
		CFRunLoopAddSource([[NSRunLoop mainRunLoop] getCFRunLoop],AXObserverGetRunLoopSource(observer),(CFStringRef)NSDefaultRunLoopMode);
		AXObserverAddNotification(observer,element,(__bridge CFStringRef)notification,(__bridge void *)(self));
		CFRetain(element);
	}
	return self;
}

- (NSInvocation *) invoker {
	return invoker;
}

- (void) dealloc {
	AXObserverRemoveNotification(observer,element,(__bridge CFStringRef)notification);
	CFRelease(element);
	CFRelease(observer);
}

@end
