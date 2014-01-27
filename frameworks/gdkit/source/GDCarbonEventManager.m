//copyright 2009 aaronsmith

#import "GDCarbonEventManager.h"

static GDCarbonEventManager * inst = nil;

@class EventKeyWrapper;
/**
 * The EventKeyWrapper is an object used internally to the
 * GDCarbonEventManager.
 */
@interface EventKeyWrapper : NSObject {
	NSUInteger keyInArray;
}
- (NSUInteger) key;
- (id) initWithKey:(NSUInteger) key;
@end

@implementation GDCarbonEventManager

+ (instancetype) sharedInstance {
    static dispatch_once_t pred;
    static id inst = nil;
    dispatch_once(&pred, ^{
        inst = [[self alloc] init];
    });
    return inst;
}

+ (NSUInteger) carbonToCocoaModifierFlags:(NSUInteger) carbonFlags {
	NSUInteger cocoaFlags = 0;
	if(carbonFlags & cmdKey) cocoaFlags |= NSCommandKeyMask;
	if(carbonFlags & optionKey) cocoaFlags |= NSAlternateKeyMask;
	if(carbonFlags & controlKey) cocoaFlags |= NSControlKeyMask;
	if(carbonFlags & shiftKey) cocoaFlags |= NSShiftKeyMask;
	if(carbonFlags & NSFunctionKeyMask) cocoaFlags += NSFunctionKeyMask;
	return cocoaFlags;
}

+ (NSUInteger) cocoaToCarbonModifierFlags:(NSUInteger) cocoaFlags {
	NSUInteger carbonFlags = 0;
	if(cocoaFlags & NSCommandKeyMask) carbonFlags |= cmdKey;
	if(cocoaFlags & NSAlternateKeyMask) carbonFlags |= optionKey;
	if(cocoaFlags & NSControlKeyMask) carbonFlags |= controlKey;
	if(cocoaFlags & NSShiftKeyMask) carbonFlags |= shiftKey;
	if(cocoaFlags & NSFunctionKeyMask) carbonFlags |= NSFunctionKeyMask;
	return carbonFlags;
}

- (id) init {
	if(self = [super init]) {
		eventsLookup = [[NSMutableDictionary alloc] init];
		eventGroups = [[NSMutableDictionary alloc] init];
		eventInstallQueueDict = [[NSMutableDictionary alloc] init];
		eventInstallQueueArray = [[NSMutableArray alloc] init];
		eventInstallQueueForGroups = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void) queueForInstall:(GDCarbonEvent *) event unique:(Boolean) unique {
	NSString * key = [event keyString];
	if(!unique) {
		[eventInstallQueueArray addObject:event];
		return;
	}
	@synchronized(self) {
        EventKeyWrapper *keyWrapper = [eventInstallQueueDict valueForKey:key];
		NSUInteger index = (NSUInteger)[keyWrapper key];
		if(index) [eventInstallQueueArray replaceObjectAtIndex:index withObject:event];
		else {
			NSUInteger last = [eventInstallQueueArray count];
			EventKeyWrapper * index = [[[EventKeyWrapper alloc] initWithKey:last] autorelease];
			[eventInstallQueueDict setObject:index forKey:key];
			[eventInstallQueueArray addObject:event];
		}
	}
}

- (void) queueForInstall:(GDCarbonEvent *) event intoGroup:(NSString *) groupName unique:(Boolean) unique {
	NSString * key = [event keyString];
	NSMutableDictionary * group = [eventInstallQueueForGroupDict valueForKey:groupName];
	if(group == nil) {
		group = [[[NSMutableDictionary alloc] init] autorelease];
		[eventInstallQueueForGroupDict setObject:group forKey:groupName];
		NSMutableDictionary * arrayLookups = [[[NSMutableDictionary alloc] init] autorelease];
		[eventInstallQueueForGroups setObject:arrayLookups forKey:groupName];
	}
	NSMutableArray * queueArray = [eventInstallQueueForGroups valueForKey:groupName];
	if(!unique) {
		[queueArray addObject:event];
		return;
	}
	@synchronized(self) {
        EventKeyWrapper *keyWrapper = [group valueForKey:key];
		NSUInteger index = (NSUInteger)[keyWrapper key];
		if(index) [queueArray replaceObjectAtIndex:index withObject:event];
		else {
			NSUInteger last = [queueArray count];
			EventKeyWrapper * index = [[[EventKeyWrapper alloc] initWithKey:last] autorelease];
			[group setObject:index forKey:key];
			[queueArray addObject:event];
		}
	}
	
}

- (void) registerGDCarbonEvent:(GDCarbonEvent *) event uninstallIfExists:(Boolean) uninstall {
	NSString * key = [event keyString];
	GDCarbonEvent * ev = [eventsLookup valueForKey:key];
	if(uninstall) [ev uninstall];
	[eventsLookup setObject:event forKey:key];
	[event retain];
}

- (void) registerAndInstallGDCarbonEvent:(GDCarbonEvent *) event uninstallIfExists:(Boolean) uninstall {
	[self registerGDCarbonEvent:event uninstallIfExists:uninstall];
	[event install];
}

- (void) registerGDCarbonEvent:(GDCarbonEvent *) event inGroup:(NSString *) groupName uninstallIfExists:(Boolean) uninstall {
	NSMutableDictionary * group = [eventGroups valueForKey:groupName];
	if(!group) {
		group = [[[NSMutableDictionary alloc] init] autorelease];
		[eventGroups setObject:group forKey:groupName];
	}
	NSString * key = [event keyString];
	[group setObject:event forKey:key];
}

- (void) registerAndInstallGDCarbonEvent:(GDCarbonEvent *) event inGroup:(NSString *) groupName uninstallIfExists:(Boolean) uninstall {
	NSMutableDictionary * group = [eventGroups valueForKey:groupName];
	NSString * key = [event keyString];
	if(!group) {
		group = [[[NSMutableDictionary alloc] init] autorelease];
		[eventGroups setObject:group forKey:groupName];
	} else {
		GDCarbonEvent * e = [group valueForKey:key];
		[e uninstall];
		[group removeObjectForKey:key];
	}
	[group setObject:event forKey:key];
	[event install];
}

- (void) unregisterGDCarbonEvent:(GDCarbonEvent *) event shouldUninstall:(Boolean) uninstall {
	NSString * key = [event keyString];
	if(uninstall) {
		GDCarbonEvent * e = [eventsLookup objectForKey:key];
		[e uninstall];
	}
	[eventsLookup removeObjectForKey:key];
}

- (void) releaseGroup:(NSString *) groupName {
	[eventGroups removeObjectForKey:groupName];
}

- (void) uninstallAndReleaseGroup:(NSString *) groupName {
	NSMutableDictionary * group = [eventGroups valueForKey:groupName];
	GDCarbonEvent * e;
	for(e in [group objectEnumerator]) [e uninstall];
	[eventGroups removeObjectForKey:groupName];
}

- (void) registerAndInstallQueuedEvents {
	GDCarbonEvent * e;
	for(e in [eventInstallQueueArray objectEnumerator]) {
		[self registerAndInstallGDCarbonEvent:e uninstallIfExists:TRUE];
	}
}

- (void) registerAndInstallQueuedEventsForGroup:(NSString *) groupName {
	NSMutableArray * group = [eventInstallQueueForGroups valueForKey:groupName];
	GDCarbonEvent * e;
	for(e in [group objectEnumerator]) [self registerAndInstallGDCarbonEvent:e inGroup:groupName uninstallIfExists:TRUE];
}

- (void) flushQueuedInstall {
	[eventInstallQueueDict release];
	[eventInstallQueueArray release];
	eventInstallQueueDict = [[NSMutableDictionary alloc] init];
	eventInstallQueueArray = [[NSMutableArray alloc] init];
}

- (void) flushQueuedInstallForGroup:(NSString *) groupName {
	[eventInstallQueueForGroupDict removeObjectForKey:groupName];
	[eventInstallQueueForGroups removeObjectForKey:groupName];
}

- (void) flushAllQueuedGroupInstalls {
	[eventInstallQueueForGroupDict release];
	[eventInstallQueueForGroups release];
	eventInstallQueueForGroupDict = [[NSMutableDictionary alloc] init];
	eventInstallQueueForGroups = [[NSMutableDictionary alloc] init];
}

- (void) releaseAll {
	[eventsLookup release];
	eventsLookup = [[NSMutableDictionary alloc] init];
}

- (void) uninstallAndReleaseAll {
	[self uninstallAll];
	[self releaseAll];
}

- (void) uninstallAll {
	GDCarbonEvent * e;
	for(e in [eventsLookup objectEnumerator]) [e uninstall];
}

- (void) installAll {
	GDCarbonEvent * e;
	for(e in [eventsLookup objectEnumerator]) [e install];
}

+ (id)allocWithZone:(NSZone *) zone {
    @synchronized(self) {
		if(inst == nil) {
			inst = [super allocWithZone:zone];
			return inst;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *) zone {
	return self;
}

@end

@implementation EventKeyWrapper
- (id) initWithKey:(NSUInteger) key {
	if(self = [super init]) {
		keyInArray = key;
	}
	return self;
}
- (NSUInteger) key {
	return keyInArray;
}
- (void) dealloc {
	keyInArray = 0;
	[super dealloc];
}
@end
