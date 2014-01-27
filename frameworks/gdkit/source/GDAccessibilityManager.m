//copyright 2009 aaronsmith

#import "GDAccessibilityManager.h"

static GDAccessibilityManager * inst;

@implementation GDAccessibilityManager

+ (instancetype) sharedInstance {
    static dispatch_once_t pred;
    static id inst = nil;
    dispatch_once(&pred, ^{
        inst = [[self alloc] init];
    });
    return inst;
}

- (Boolean) isAccessibilityEnabled {
	return AXAPIEnabled();
}

//internal
- (GDAccessibilityOperationResult *) getAPIDisabledOperationResult {
	GDAccessibilityOperationResult * res = [[GDAccessibilityOperationResult alloc] init];
	[res setResultCode:kAXErrorAPIDisabled];
	return res;
}

//internal
- (GDAccessibilityOperationResult *) getCannotCreateValueOperationResult {
	GDAccessibilityOperationResult * res = [[GDAccessibilityOperationResult alloc] init];
	[res setResultCode:kAMCouldNotSetValue];
	return res;
}


- (GDAccessibilityOperationResult *) sysWide {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	GDAccessibilityOperationResult *res = [[GDAccessibilityOperationResult alloc] init];
	AXUIElementRef ref = AXUIElementCreateSystemWide();
	[res setResultCode:kAXErrorSuccess];
	if([res wasSuccess]) {
		[res setResult:(CFTypeRef)ref];
		CFRelease((CFTypeRef)ref);
	}
	return res;
}

- (GDAccessibilityOperationResult *) focusedApplicationRef {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	GDAccessibilityOperationResult *result = [[GDAccessibilityOperationResult alloc] init];
	CFTypeRef res = NULL;
	AXUIElementRef sys = AXUIElementCreateSystemWide();
	int rescode = AXUIElementCopyAttributeValue(sys,kAXFocusedApplicationAttribute,(CFTypeRef *)&res);
	CFRelease(sys);
	[result setResultCode:rescode];
	if([result wasSuccess]) {
		[result setResult:res];
		CFRelease(res);
	}
	return result;
}

- (GDAccessibilityOperationResult *) applicationRefFromPid:(pid_t) pid {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	GDAccessibilityOperationResult * result = [[GDAccessibilityOperationResult alloc] init];
	CFTypeRef res = AXUIElementCreateApplication(pid);
	[result setResultCode:kAXErrorSuccess];
	if([result wasSuccess]) {
		[result setResult:res];
		CFRelease(res);
	}
	return result;
}

- (pid_t) forAXUIElementRefGetPID:(AXUIElementRef) element {
	pid_t p;
	int res = AXUIElementGetPid(element,&p);
	if(res == kAXErrorInvalidUIElement || res == kAXErrorIllegalArgument) return -1;
	return (pid_t)p;
}

- (GDAccessibilityOperationResult *) focusedWindowForApplication:(AXUIElementRef) applicationRef {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	GDAccessibilityOperationResult *result = [[GDAccessibilityOperationResult alloc] init];
	CFTypeRef res = NULL;
	if(![self doesElementRef:applicationRef actAsRole:NSAccessibilityApplicationRole]) {
		[result setResultCode:kAMIncorrectRole];
	} else {
		int rescode = AXUIElementCopyAttributeValue(applicationRef,(__bridge CFStringRef)NSAccessibilityFocusedWindowAttribute,(CFTypeRef *)&res);
		[result setResultCode:rescode];
	}
	if([result wasSuccess]) {
		[result setResult:res];
        if (res)
            CFRelease(res);
	}
	return result;
}

- (Boolean) doesElementRef:(AXUIElementRef) element actAsRole:(NSString *) role {
	GDAccessibilityOperationResult * res = [self forAXUIElementRefGetRoleAttribute:element];
	if(![res wasSuccess]) return FALSE;
	return ([(NSString *)[res result] isEqualTo:role]);
}

- (GDAccessibilityOperationResult *) focusedWindowForFocusedApplication {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	GDAccessibilityOperationResult * result;
	GDAccessibilityOperationResult * app = [self focusedApplicationRef];
	if([app wasSuccess]) {
		result = [self focusedWindowForApplication:[app result]];
	} else {
		result = [[GDAccessibilityOperationResult alloc] init];
		[result setResultCode:[app resultCode]];
	}
	return result;
}

- (GDAccessibilityOperationResult *) forAXUIElementRefGetRoleAttribute:(AXUIElementRef) element {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	return [self forAXUIElementRef:element getAttributeValue:NSAccessibilityRoleAttribute];
}

- (GDAccessibilityOperationResult *) forAXUIElementRefGetRoleDescriptionAttribute:(AXUIElementRef) element {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	return [self forAXUIElementRef:element getAttributeValue:NSAccessibilityRoleDescriptionAttribute];
}

- (GDAccessibilityOperationResult *) forAXUIElementRefGetTitleAttribute:(AXUIElementRef) element {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	return [self forAXUIElementRef:element getAttributeValue:NSAccessibilityTitleAttribute];
}

- (GDAccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef)element getAttributeValue:(NSString *) attribute {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	GDAccessibilityOperationResult * res = [[GDAccessibilityOperationResult alloc] init];
	CFTypeRef *value = NULL;
	int resc = AXUIElementCopyAttributeValue((AXUIElementRef)element,(__bridge CFStringRef)attribute,(CFTypeRef*)&value);
	[res setResultCode:resc];
	if([res wasSuccess]) {
		[res setResult:value];
		CFRelease(value);
	}
	return res;
}

- (GDAccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element getAttributeValueCount:(NSString *) attribute {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	GDAccessibilityOperationResult * res = [[GDAccessibilityOperationResult alloc] init];
	CFIndex * count;
	int resc = AXUIElementGetAttributeValueCount((AXUIElementRef)element,(__bridge CFStringRef)attribute,(CFIndex*)&count);
	[res setResultCode:resc];
	if([res wasSuccess]) [res setResult:(CFTypeRef)count];
	return res;
}

- (GDAccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element setAttribute:(NSString *) attribute toNSPoint:(NSPoint) point {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	GDAccessibilityOperationResult * res = [[GDAccessibilityOperationResult alloc] init];
	AXValueRef valueRef = AXValueCreate(kAXValueCGPointType,(const void *)&point);
	if(!valueRef) return [self getCannotCreateValueOperationResult];
	int resc = AXUIElementSetAttributeValue(element,(__bridge CFStringRef)attribute,(CFTypeRef)valueRef);
	CFRelease(valueRef);
	[res setResultCode:resc];
	return res;
}

- (GDAccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element setAttribute:(NSString *) attribute toNSRect:(NSRect) rect {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	GDAccessibilityOperationResult * res = [[GDAccessibilityOperationResult alloc] init];
	AXValueRef valueRef = AXValueCreate(kAXValueCGRectType,(const void *)&rect);
	if(!valueRef) return [self getCannotCreateValueOperationResult];
	int resc = AXUIElementSetAttributeValue(element,(__bridge CFStringRef)attribute,(CFTypeRef)valueRef);
	CFRelease(valueRef);
	[res setResultCode:resc];
	return res;
}

- (GDAccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element setAttribute:(NSString *) attribute toNSRange:(NSRange) range {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	GDAccessibilityOperationResult * res = [[GDAccessibilityOperationResult alloc] init];
	AXValueRef valueRef = AXValueCreate(kAXValueCFRangeType,(const void *)&range);
	if(!valueRef) return [self getCannotCreateValueOperationResult];
	int resc = AXUIElementSetAttributeValue(element,(__bridge CFStringRef)attribute,(CFTypeRef)valueRef);
	CFRelease(valueRef);
	[res setResultCode:resc];
	return res;
}

- (GDAccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element setAttribute:(NSString *) attribute toNSSize:(NSSize) size {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	GDAccessibilityOperationResult * res = [[GDAccessibilityOperationResult alloc] init];
	AXValueRef valueRef = AXValueCreate(kAXValueCGSizeType,(const void *)&size);
	if(!valueRef) return [self getCannotCreateValueOperationResult];
	int resc = AXUIElementSetAttributeValue(element,(__bridge CFStringRef)attribute,(CFTypeRef)valueRef);
	CFRelease(valueRef);
	[res setResultCode:resc];
	return res;
}

- (GDAccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element setAttribute:(NSString *) attribute toNSString:(NSString *) string {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	GDAccessibilityOperationResult * res = [[GDAccessibilityOperationResult alloc] init];
	int resc = AXUIElementSetAttributeValue(element,(__bridge CFStringRef)attribute,(__bridge CFTypeRef)string);
	[res setResultCode:resc];
	return res;
}

- (GDAccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element setAttribute:(NSString *) attribute toNSValue:(NSValue *) nsvalue {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	if(strcmp((const char *)[nsvalue objCType],(const char *)@encode(NSPoint)) == 0) {
		return [self forAXUIElementRef:element setAttribute:attribute toNSPoint:[nsvalue pointValue]];
	} else if(strcmp((const char *)[nsvalue objCType],(const char *)@encode(NSRect)) == 0) {
		return [self forAXUIElementRef:element setAttribute:attribute toNSRect:[nsvalue rectValue]];
	} else if(strcmp((const char *)[nsvalue objCType],(const char *)@encode(NSRange)) == 0) {
		return [self forAXUIElementRef:element setAttribute:attribute toNSRange:[nsvalue rangeValue]];
	} else if(strcmp((const char *)[nsvalue objCType],(const char *)@encode(NSSize)) == 0) {
		return [self forAXUIElementRef:element setAttribute:attribute toNSSize:[nsvalue sizeValue]];
	}
	GDAccessibilityOperationResult * failedRes = [[GDAccessibilityOperationResult alloc] init];
	[failedRes setResultCode:kAMIncorrectValue];
	return failedRes;
}

- (Boolean) isAXUIElementRef:(AXUIElementRef) element attributeSettable:(NSString *) attribute {
	if(![self isAccessibilityEnabled]) return FALSE;
	Boolean val = FALSE;
	if(AXUIElementIsAttributeSettable(element,(__bridge CFStringRef)attribute,&val) != kAXErrorSuccess) {
		return FALSE;
	}
	return val;
}

- (Boolean) doesElementRef:(AXUIElementRef) elementRef exposeAttribute:(NSString *) attribute {
	if(![self isAccessibilityEnabled]) return FALSE;
	CFArrayRef attributes = NULL;
	Boolean does = false;
	if(AXUIElementCopyAttributeNames(elementRef,&attributes) == kAXErrorSuccess) {
		does = [(__bridge NSArray *)attributes containsObject:attribute];
		CFRelease(attributes);
	}
	return does;
}

- (GDAccessibilityOperationResult *) forAXUIElementRefGetAttributeNames:(AXUIElementRef) element {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	CFArrayRef result;
	int resc = AXUIElementCopyAttributeNames(element,&result);
	GDAccessibilityOperationResult *res = [[GDAccessibilityOperationResult alloc] init];
	[res setResultCode:resc];
	if([res wasSuccess]) {
		[res setResult:result];
		CFRelease(result);
	}
	return res;
}

- (GDAccessibilityOperationResult *) forAXUIElementRefGetActionNames:(AXUIElementRef) element {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	CFArrayRef result;
	int resc = AXUIElementCopyActionNames(element,&result);
	GDAccessibilityOperationResult *res = [[GDAccessibilityOperationResult alloc] init];
	[res setResultCode:resc];
	if([res wasSuccess]) {
		[res setResult:result];
		CFRelease(result);
	}
	return res;
}

- (GDAccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element getActionDescription:(NSString *) action {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	CFStringRef desc;
	int resc = AXUIElementCopyActionDescription(element,(__bridge CFStringRef)action,&desc);
	GDAccessibilityOperationResult *res = [[GDAccessibilityOperationResult alloc] init];
	[res setResultCode:resc];
	if([res wasSuccess]) {
		[res setResult:desc];
		CFRelease(desc);
	}
	return res;
}

- (GDAccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element performAction:(NSString *) action {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	int resc = AXUIElementPerformAction(element,(__bridge CFStringRef)action);
	GDAccessibilityOperationResult * res = [[GDAccessibilityOperationResult alloc] init];
	[res setResultCode:resc];
	return res;
}

- (Boolean) isCGPoint:(CFTypeRef) possibleCGPointRef {
	return (AXValueGetType((AXValueRef)possibleCGPointRef) == kAXValueCGPointType);
}

- (Boolean) isCGRect:(CFTypeRef) possibleCGRectRef {
	return (AXValueGetType((AXValueRef)possibleCGRectRef) == kAXValueCGRectType);
}

- (Boolean) isCGSize:(CFTypeRef) possibleCGSize {
	return (AXValueGetType((AXValueRef)possibleCGSize) == kAXValueCGSizeType);
}

- (Boolean) isCFRange:(CFTypeRef) possibleCFRange {
	return (AXValueGetType((AXValueRef)possibleCFRange) == kAXValueCFRangeType);
}

- (Boolean) isNSString:(CFTypeRef) possibleString {
	return ([(__bridge id)possibleString isKindOfClass:[NSString class]]);
}

- (Boolean) isNSValue:(CFTypeRef) possibleNSValue {
	return ([(__bridge id)possibleNSValue isKindOfClass:[NSValue class]]);
}

+ (id)allocWithZone:(NSZone *) zone {
    @synchronized(self) {
		if (inst == nil) {
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
