//copyright 2009 aaronsmith

#import "GDAccessibilityOperationResult.h"
#import "GDAccessibilityManager.h"

@implementation GDAccessibilityOperationResult

@synthesize resultCode;

- (id) init {
	self = [super init];
	if(self) {
		[self setResultCode:-1];
		[self setResult:NULL];
	}
	return self;
}

- (void) setResult:(CFTypeRef) res {
	if(res != NULL) CFRetain(res);
	result=res;
}

- (CFTypeRef) result {
	return result;
}

- (Boolean) wasSuccess {
	return ([self resultCode]==kAXErrorSuccess);
}

- (Boolean) wasSystemFailure {
	return ([self resultCode] == kAXErrorFailure);
}

- (Boolean) hadIllegalArgument {
	return ([self resultCode] == kAXErrorIllegalArgument);
}

- (Boolean) wasInvalidAXUIElementRef {
	return ([self resultCode] == kAXErrorInvalidUIElement);
}

- (Boolean) wasInvalidAXObserverRef {
	return ([self resultCode] == kAXErrorInvalidUIElementObserver);
}

- (Boolean) didMessagingFail {
	return ([self resultCode] == kAXErrorCannotComplete);
}

- (Boolean) wasUnsupportedAttribute {
	return ([self resultCode] == kAXErrorAttributeUnsupported);
}

- (Boolean) wasUnsupportedAction {
	return ([self resultCode] == kAXErrorActionUnsupported);
}

- (Boolean) wasUnsupportedNotification {
	return ([self resultCode] == kAXErrorNotificationUnsupported);
}

- (Boolean) wasNotImplemented {
	return ([self resultCode] == kAXErrorNotImplemented);
}

- (Boolean) wasNotificationAlreadyRegistered {
	return ([self resultCode] == kAXErrorNotificationAlreadyRegistered);
}

- (Boolean) notificationWasntRegistered {
	return ([self resultCode] == kAXErrorNotificationNotRegistered);
}

- (Boolean) apiIsDisabled {
	return ([self resultCode] == kAXErrorAPIDisabled);
}

- (Boolean) wasIncorrectValue {
	return ([self resultCode] == kAXErrorNoValue || [self resultCode] == kAMIncorrectValue);
}

- (Boolean) wasErrorSettingValue {
	return ([self resultCode] == kAMCouldNotSetValue);
}

- (Boolean) wasUnsupportedParameterizedAttributes {
	return ([self resultCode] == kAXErrorParameterizedAttributeUnsupported);
}

- (Boolean) wasIncorrectRole {
	return ([self resultCode] == kAMIncorrectRole);
}

- (Boolean) wasAttributeNotSettable {
	return ([self resultCode] == kAMAttributeNotSettable);
}

- (Boolean) isResultAXUIElementRef {
	if(!result) return FALSE;
	if(AXValueGetType((AXValueRef)result) == AXUIElementGetTypeID()) return TRUE;
	return FALSE;
}

- (Boolean) isResultCGPoint {
	if(!result) return FALSE;
	if(AXValueGetType((AXValueRef)result) == kAXValueCGPointType) return TRUE;
	return FALSE;
}

- (Boolean) isResultCGRect {
	if(!result) return FALSE;
	if(AXValueGetType((AXValueRef)result) == kAXValueCGRectType) return TRUE;
	return FALSE;
}

- (Boolean) isResultCFRange {
	if(!result) return FALSE;
	if(AXValueGetType((AXValueRef)result) == kAXValueCFRangeType) return TRUE;
	return FALSE;
}

- (Boolean) isResultCGSize {
	if(!result) return FALSE;
	if(AXValueGetType((AXValueRef)result) == kAXValueCGSizeType) return TRUE;
	return FALSE;
}

- (Boolean) isResultObserverRef {
	if(!result) return FALSE;
	if(AXValueGetType(result) == AXObserverGetTypeID()) return TRUE;
	return FALSE;
}

- (NSPoint) resultAsNSPoint {
	CGPoint pt;
	AXValueGetValue((AXValueRef)result,kAXValueCGPointType,&pt);
	NSPoint p = NSMakePoint(pt.x,pt.y);
	return p;
}

- (NSRect) resultAsNSRect {
	CGRect rc;
	AXValueGetValue((AXValueRef)result,kAXValueCGRectType,&rc);
	NSRect r = NSMakeRect(rc.origin.x,rc.origin.y,rc.size.width,rc.size.height);
	return r;
}

- (NSRange) resultAsNSRange {
	CFRange range;
	AXValueGetValue((AXValueRef)result,kAXValueCFRangeType,&range);
	NSRange r = NSMakeRange(range.location,range.length);
	return r;
}

- (NSSize) resultAsNSSize {
	CGSize sz;
	AXValueGetValue(result,kAXValueCGSizeType,&sz);
	NSSize sze = NSMakeSize(sz.width,sz.height);
	return sze;
}

- (NSString *) resultAsNSString {
	return (NSString *) result;
}

- (NSValue *) resultAsNSValue {
	NSValue * res = NULL;
	if([self isResultCFRange]) {
		NSRange range = [self resultAsNSRange];
		res = [NSValue valueWithRange:range];
	} else if([self isResultCGPoint]) {
		NSPoint point = [self resultAsNSPoint];
		res = [NSValue valueWithPoint:point];
	} else if([self isResultCGRect]) {
		NSRect rect = [self resultAsNSRect];
		res = [NSValue valueWithRect:rect];
	} else if([self isResultCGSize]) {
		NSSize size = [self resultAsNSSize];
		res = [NSValue valueWithSize:size];
	}
	return res;
}

- (void) dealloc {
	if(result != NULL) CFRelease(result);
	resultCode = 0;
	[super dealloc];
}

@end
