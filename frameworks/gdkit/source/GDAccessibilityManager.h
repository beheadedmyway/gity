//copyright 2009 aaronsmith

#import <Cocoa/Cocoa.h>
#import "GDAccessibilityOperationResult.h"

/**
 * @file GDAccessibilityManager.h
 * 
 * Header file for GDAccessibilityManager.
 */

/**
 * Additional error result codes for GDAccessibilityOperationResults.
 */
typedef enum {
	
	/**
	 * Result code for a GDAccessibilityOperationResult indicating
	 * that the AXUIElementRef isn't the right role for whichever
	 * operation is performed.
	 */
	kAMIncorrectRole = -25215,
	
	/**
	 * Result code for a GDAccessibilityOperationResult indicating
	 * that the AXUIElementRef's attribute isn't writable.
	 */
	kAMAttributeNotSettable = -25216,
	
	/**
	 * Result code for a GDAccessibilityOperationResult indicating
	 * that an incorrect value tried to be set on an AXUIElementRef's
	 * attribute.
	 */
	kAMIncorrectValue = -25217,
	
	/**
	 * Result code for a GDAccessibilityOperationResult indicating
	 * that the value set operation didn't complete.
	 */
	kAMCouldNotSetValue = -25218,

} GDAccessibilityManagerErrorConstant;

/**
 * @class GDAccessibilityManager
 *
 * The GDAccessibilityManager handles a working with the ApplicationServices/‍HIServices
 * API for you.
 *
 * The ApplicationServices API is quite large, this manager handles most of
 * the common operations.
 * 
 * @see See GDAccessibilityManager.h for typdefs.
 * @see http://developer.apple.com/mac/library/documentation/Accessibility/Reference/AccessibilityLowlevel/index.html
 * @see http://developer.apple.com/mac/library/documentation/Accessibility/Reference/AccessibilityLowlevel/accessibility-functions.html
 * @see http://developer.apple.com/mac/library/documentation/Accessibility/Reference/AccessibilityCarbonRef/Reference/reference.html
 * @see http://developer.apple.com/mac/library/documentation/Cocoa/Reference/ApplicationKit/Protocols/NSAccessibility_Protocol/Reference/Reference.html
 * @see http://developer.apple.com/mac/library/documentation/Cocoa/Conceptual/Accessibility/cocoaAXIntro/cocoaAXintro.html
 * @see http://developer.apple.com/mac/library/documentation/Accessibility/Conceptual/AccessibilityMacOSX/OSXAXIntro/OSXAXintro.html
 */
@interface GDAccessibilityManager : NSObject {
}

/**
 * Singleton instance.
 */
+ (instancetype) sharedInstance;

/**
 * Whether or not the accessibility API is on.
 */
- (Boolean) isAccessibilityEnabled;

/**
 * Returns whether or not an AXUIElementRef's attribute
 * is settable.
 *
 * @param element An AXUIElementRef.
 * @param attribute The accessibility attribute to test.
 */
- (Boolean) isAXUIElementRef:(AXUIElementRef) element attributeSettable:(NSString *) attribute;

/**
 * Checks whether an attribute is exposed on the AXUIElementRef.
 *
 * @param elementRef An AXUIElementRef.
 * @param attribute The accessibility attribute to test.
 */
- (Boolean) doesElementRef:(AXUIElementRef) elementRef exposeAttribute:(NSString *) attribute;

/**
 * Whether or not an AXUIElementRef acts as a particular role.
 *
 * @param element An AXUIElementRef.
 * @param role The accessibility role to test for.
 */
- (Boolean) doesElementRef:(AXUIElementRef) element actAsRole:(NSString *) role;

/**
 * Check if a CFTypeRef is a CGPoint.
 *
 * @param possibleCGPointRef An object that might be a CGPoint.
 */
- (Boolean) isCGPoint:(CFTypeRef) possibleCGPointRef;

/**
 * Check if a CFTypeRef is a CGRect.
 *
 * @param possibleCGRectRef An object that might be a CGRect.
 */
- (Boolean) isCGRect:(CFTypeRef) possibleCGRectRef;

/**
 * Check if a CFTypeRef is a CGSize.
 *
 * @param possibleCGSize An object that might be a CGSize.
 */
- (Boolean) isCGSize:(CFTypeRef) possibleCGSize;

/**
 * Check if a CFTypeRef is a CFRange.
 *
 * @param possibleCFRange An object that might be a CFRange.
 */
- (Boolean) isCFRange:(CFTypeRef) possibleCFRange;

/**
 * Check if a CFTypeRef is an NSString.
 *
 * @param possibleString An object that might be an NSString.
 */
- (Boolean) isNSString:(CFTypeRef) possibleString;

/**
 * Check if a CFTypeRef is an NSValue.
 *
 * @param possibleNSValue An object that might be an NSValue.
 */
- (Boolean) isNSValue:(CFTypeRef) possibleNSValue;

/**
 * Returns a pid_t for the given AXUIElementRef or -1.
 *
 * @param element An AXUIElementRef.
 */
- (pid_t) forAXUIElementRefGetPID:(AXUIElementRef) element;

/**
 * Get the system wide accessibility object.
 */
- (GDAccessibilityOperationResult *) sysWide;

/**
 * Get the current focused application.
 */
- (GDAccessibilityOperationResult *) focusedApplicationRef;

/**
 * Get the focused window for the currently focused application.
 */
- (GDAccessibilityOperationResult *) focusedWindowForFocusedApplication;

/**
 * Get the focused window for an application.
 *
 * @param applicationRef An AXUIElementRef who's role is NSAccessibilityApplicationRole.
 */
- (GDAccessibilityOperationResult *) focusedWindowForApplication:(AXUIElementRef) applicationRef;

/**
 * Get an application AXUIElementRef from a process id.
 *
 * @param pid The pid_t for the application.
 */
- (GDAccessibilityOperationResult *) applicationRefFromPid:(pid_t) pid;

/**
 * Gets the role attribute for an element ref.
 *
 * @param element An AXUIElementRef.
 */
- (GDAccessibilityOperationResult *) forAXUIElementRefGetRoleAttribute:(AXUIElementRef) element;

/**
 * Gets the role description for an element ref.
 *
 * @param element An AXUIElementRef.
 */
- (GDAccessibilityOperationResult *) forAXUIElementRefGetRoleDescriptionAttribute:(AXUIElementRef) element;

/**
 * Get the title for an element ref.
 *
 * @param element An AXUIElementRef.
 */
- (GDAccessibilityOperationResult *) forAXUIElementRefGetTitleAttribute:(AXUIElementRef) element;

/**
 * Gets the value of an attribute for an element ref.
 *
 * @param element An AXUIElementRef.
 * @param attribute The accessibility attribute.
 */
- (GDAccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element getAttributeValue:(NSString *) attribute;

/**
 * Gets the attribute value count of an attribute's value for an element ref.
 *
 * @param element An AXUIElementRef.
 * @param attribute The accessiblity attribute.
 */
- (GDAccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element getAttributeValueCount:(NSString *) attribute;

/**
 * Sets the value of an attribute for an AXUIElementRef - it does
 * not accept NSStrings.
 *
 * @param element An AXUIElementRef.
 * @param attribute The accessibility attribute.
 * @param nsvalue The value to set the attribute value to.
 */
- (GDAccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element setAttribute:(NSString *) attribute toNSValue:(NSValue *) nsvalue;

/**
 * Set an attribute's value to an NSPoint.
 *
 * @param element An AXUIElementRef.
 * @param attribute The accessibility attribute.
 * @param point An NSPoint to set the attribute value to.
 */
- (GDAccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element setAttribute:(NSString *) attribute toNSPoint:(NSPoint) point;

/**
 * Set an attribute's value to an NSRect.
 *
 * @param element An AXUIElementRef.
 * @param attribute The accessibility attribute.
 * @param rect An NSRect to set the attribute value to.
 */
- (GDAccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element setAttribute:(NSString *) attribute toNSRect:(NSRect) rect;

/**
 * Set an attribute's value to an NSRange.
 *
 * @param element An AXUIElementRef.
 * @param attribute The accessibility attribute.
 * @param range An NSRange to set the attribute value to.
 */
- (GDAccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element setAttribute:(NSString *) attribute toNSRange:(NSRange) range;

/**
 * Set an attribute's value to an NSSize.
 *
 * @param element An AXUIElementRef.
 * @param attribute The accessibility attribute.
 * @param size An NSSize to set the attribute value to.
 */
- (GDAccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element setAttribute:(NSString *) attribute toNSSize:(NSSize) size;

/**
 * Set an attribute's value to an NSString.
 *
 * @param element An AXUIElementRef.
 * @param attribute The accessibility attribute.
 * @param string An NSString to set the attribute value to.
 */
- (GDAccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element setAttribute:(NSString *) attribute toNSString:(NSString *) string;

/**
 * Gets attribute names for an AXUIElementRef.
 *
 * @param element An AXUIElementRef.
 */
- (GDAccessibilityOperationResult *) forAXUIElementRefGetAttributeNames:(AXUIElementRef) element;

/**
 * Gets action names for an AXUIElementRef.
 *
 * @param element An AXUIElementRef.
 */
- (GDAccessibilityOperationResult *) forAXUIElementRefGetActionNames:(AXUIElementRef) element;

/**
 * Gets an action description on an AXUIElementRef.
 *
 * @param element An AXUIElementRef.
 * @param action The action name for the description.
 */
- (GDAccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element getActionDescription:(NSString *) action;

/**
 * Performs an action on an AXUIElementRef.
 *
 * @param element An AXUIElementRef.
 * @param action The action to perform.
 */
- (GDAccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element performAction:(NSString *) action;

@end

/**
 * @internal
 */
@interface GDAccessibilityManager (Private)

/**
 * @internal
 */
- (GDAccessibilityOperationResult *) getAPIDisabledOperationResult;

/**
 * @internal
 */
- (GDAccessibilityOperationResult *) getCannotCreateValueOperationResult;

@end
