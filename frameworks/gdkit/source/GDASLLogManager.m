//copyright 2009 aaronsmith

#import "GDASLLogManager.h"

static GDASLLogManager * inst = nil;

@implementation GDASLLogManager

@synthesize enabled;

+ (GDASLLogManager *) sharedInstance {
    @synchronized(self) {
		if(!inst) {
			inst = [[self alloc] init];
		}
    }
    return inst;
}

- (id) init {
	self=[super init];
	logs=[[NSMutableDictionary alloc] init];
	[self setEnabled:TRUE];
	return self;
}

- (void) setLog:(GDASLLog *) log forKey:(NSString *) key {
	@synchronized(self) {
		if(!logs) logs = [[NSMutableDictionary alloc] init];
		[logs setObject:log	forKey:key];
	}
}

- (GDASLLog *) getLogForKey:(NSString *) key {
	GDASLLog * l;
	@synchronized(self) {
		l = (GDASLLog *)[logs objectForKey:key];
	}
	return l;
}

+ (id)allocWithZone:(NSZone *) zone {
    @synchronized(self) {
		if(inst==nil) {
			inst=[super allocWithZone:zone];
			return inst;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *) zone {
	return self;
}

- (id) retain {
	return self;
}

- (NSUInteger) retainCount {
	return UINT_MAX;
}

- (id) autorelease {
	return self;
}

- (oneway void) release{
}

@end
