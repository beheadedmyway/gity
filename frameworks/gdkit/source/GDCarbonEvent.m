//copyright 2009 aaronsmith

#import "GDCarbonEvent.h"
#import "GDCarbonEventManager.h"
#import "OSTypeFunctions.h"

static NSMutableDictionary * gdceLookup = nil;
static unsigned int eventIds = 0;

static OSStatus hotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void * userData) {
	EventHotKeyID hkRef;
	OSStatus res = GetEventParameter(anEvent,kEventParamDirectObject,typeEventHotKeyID,NULL,sizeof(hkRef),NULL,&hkRef);
	if(res) return res;
	GDCarbonEvent * e = (GDCarbonEvent *)[gdceLookup valueForKey:[NSString stringWithFormat:@"%i",hkRef.id]];
	[e invoke];
	return noErr;
}

@implementation GDCarbonEvent
@synthesize keyChar;
@synthesize userInfo;
@synthesize notificationName;
@synthesize notificationCenter;
@synthesize target;
@synthesize action;
@synthesize keyCode;
@synthesize modifierFlags;

- (id) initWithCoder:(NSCoder *) coder {
	if(self = [super init]) {
		if(self = [self init]) {
			[self setKeyCode:[coder decodeIntForKey:@"keyCode"]];
			[self setModifierFlags:[coder decodeIntForKey:@"modifierFlags"]];
			[self setEventKind:[coder decodeIntForKey:@"eventKind"]];
			[self setEventClass:(FourCharCode)[coder decodeIntForKey:@"eventClass"]];
			[self setKeyChar:[coder decodeObjectForKey:@"keyChar"]];
			[self setUserInfo:NULL];
		}
	}
	return self;
}

- (void) encodeWithCoder:(NSCoder *) coder {
	[coder encodeInt:keyCode forKey:@"keyCode"];
	[coder encodeInt:modifierFlags forKey:@"modifierFlags"];
	[coder encodeInt:eventSpec.eventClass forKey:@"eventClass"];
	[coder encodeInt:eventSpec.eventKind forKey:@"eventKind"];
	[coder encodeObject:keyChar forKey:@"keyChar"];
}

- (id) initWithEventClass:(FourCharCode) eventClass andEventKind:(NSUInteger) eventKind {
	if(self = [super init]) {
		if(self = [self init]) {
			[self setEventClass:eventClass];
			[self setEventKind:eventKind];
		}
	}
	return self;
}

- (void) setNotificationName:(NSString *) name andNotificationCenter:(NSNotificationCenter *) center {
	[self setNotificationName:name];
	[self setNotificationCenter:center];
}

- (void) setAction:(SEL) actin andTarget:(id) targt {
	[self setAction:actin];
	[self setTarget:targt];
}

- (void) setKeyCode:(NSUInteger) code andFlags:(NSUInteger) flags areFlagsCocoa:(Boolean) cocoaFlags {
	[self setKeyCode:code];
	if(cocoaFlags)[self setModifierFlags:[GDCarbonEventManager cocoaToCarbonModifierFlags:flags]];
	else [self setModifierFlags:flags];
}

- (id) init {
	if(self = [super init]) {
		if(!gdceLookup) gdceLookup = [[NSMutableDictionary alloc] init];
	}
	return self;
}

+ (void) disposeOfLookupManager {
	[gdceLookup release];
}

- (void) setHotKeySignature:(NSString *) signature {
	sigString = [signature retain];
	hotKeyId.signature = fourCharCodeToOSType(sigString);
}

- (int) hotKeyId {
	return hotKeyId.id;
}

- (void) setHotKeyId:(int) kid {
	hotKeyId.id = kid;
}

- (void) setEventClass:(FourCharCode) eventClass {
	eventSpec.eventClass = (OSType) eventClass;
}

- (void) setEventKind:(NSUInteger) eventKind {
	eventSpec.eventKind = eventKind;
}

- (void) setEventClass:(FourCharCode) eventClass andEventKind:(NSUInteger) eventKind {
	[self setEventClass:eventClass];
	[self setEventKind:eventKind];
}

- (NSUInteger) cocoaModifierKeys {
	return [GDCarbonEventManager carbonToCocoaModifierFlags:[self modifierFlags]];
}

- (void) install {
	if(isInstalled) return;
	if(handlerUPP == NULL) handlerUPP = NewEventHandlerUPP(hotKeyHandler);
	@synchronized(self) {
		if([self hotKeyId] < 1) {
			eventIds+=1;
			[self setHotKeyId:eventIds];
			[self setHotKeySignature:[NSString stringWithFormat:@"hk%i",eventIds]];
		}
	}
	if(eventSpec.eventClass==kEventClassKeyboard && eventSpec.eventKind == kEventHotKeyPressed) {
		//TODO: MEM (release if installing over already existing.
		//InstallEventHandler(GetApplicationEventTarget(),handlerUPP,1,&eventSpec,self,&eventRef);
		RegisterEventHotKey(keyCode,modifierFlags,hotKeyId,GetApplicationEventTarget(),0,&hotKeyRef);
		InstallApplicationEventHandler(&hotKeyHandler,1,&eventSpec,(void*)&self,&eventRef);
		[gdceLookup setObject:self forKey:[NSString stringWithFormat:@"%i",[self hotKeyId]]];
	}
	isInstalled = TRUE;
}

- (void) uninstall {
	if(!isInstalled) return;
	RemoveEventHandler(eventRef);
	if(eventSpec.eventClass==kEventClassKeyboard && eventSpec.eventKind == kEventHotKeyPressed) {
		UnregisterEventHotKey(hotKeyRef);
	}
	isInstalled = FALSE;
}

- (void) invoke {
	if(target != nil && action != nil) [target performSelector:action withObject:[self userInfo]];
	else if(notificationName != nil) [notificationCenter postNotificationName:notificationName object:self userInfo:userInfo];
}

- (NSString *) keyString {
	return [NSString stringWithFormat:@"%d",(keyCode+modifierFlags)];
}

- (void) dealloc { //TODO: There are some ways to dispose of other Event* types. see the Carbon event manager.
	if(isInstalled) [self uninstall];
	[sigString release];
	[self setNotificationName:NULL];
	[self setKeyCode:0];
	[self setModifierFlags:0];
	[super dealloc];
}

@end
