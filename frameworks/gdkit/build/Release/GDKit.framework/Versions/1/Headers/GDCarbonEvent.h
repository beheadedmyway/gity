//copyright 2009 aaronsmith

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

/**
 * @file GDCarbonEvent.h
 *
 * Header file for GDCarbonEvent.
 */

//forward declaration
@class GDCarbonEventManager;

/**
 * The GDCarbonEvent is an object wrapper for using
 * carbon events.
 *
 * This also wraps up creating carbon global hot key events.
 *
 * @see http://dbachrach.com/blog/2005/11/28/program-global-hotkeys-in-cocoa-easily/
 * @see http://cocoasamurai.blogspot.com/2009/03/global-keyboard-shortcuts-with-carbon.html
 */
@interface GDCarbonEvent : NSObject <NSCoding> {
	
	int keyCode;
	int modifierFlags;
	id target;
	SEL action;
	NSString * notificationName;
	NSString * keyChar;
	NSDictionary * userInfo;
	NSNotificationCenter * notificationCenter;
	
	/**
	 * Whether or not the event is installed with the carbon event manager.
	 */
	Boolean isInstalled;
	
	/**
	 * The event signature string.
	 */
	NSString * sigString;
	
	/**
	 * An event handler reference.
	 */
	EventHandlerRef eventRef;
	
	/**
	 * A function pointer to the internal callback (Universal Precedure Pointer).
	 */
	EventHandlerUPP handlerUPP;
	
	/**
	 * Describes the class and kind of event.
	 */
	EventTypeSpec eventSpec;
	
	/**
	 * A reference to a global hot key event.
	 */
	EventHotKeyRef hotKeyRef;
	
	/**
	 * A global hot key event id.
	 */
	EventHotKeyID hotKeyId;
	
}

/**
 * An NSString for the key char - like 'W', 'F', etc.
 */
@property (copy) NSString * keyChar;

/**
 * The notification name, if this carbon event is posting
 * to a notification center.
 */
@property (copy) NSString * notificationName;

/**
 * The nofication center to post to.
 */
@property (assign) NSNotificationCenter * notificationCenter;

/**
 * Selector to callback, if this event is NOT posting
 * to a notification center.
 */
@property (assign) SEL action;

/**
 * The target for the selector
 */
@property (retain) id target;

/**
 * ASCII Key code for carbon event HotKey
 */
@property (assign) int keyCode;

/**
 * Modifier keys for a carbon hot key event (cmdKey, optionKey, shiftKey, 
 * optionKey, controlKey, kFunctionKeyCharCode)
 */
@property (assign) int modifierFlags;

/**
 * User info dict that get's passed back to the callback,
 * or passed as userInfo in the notification.
 */
@property (retain) NSDictionary * userInfo;

/**
 * Initialize this GDCarbonEvent with a coder. 
 * It only sets up the keyCode, and modifierFlags
 * from the coder. You need to continue initializing
 * the object to setup action/target and other
 * parameters.
 *
 * @param coder An NSCoder.
 */
- (id) initWithCoder:(NSCoder *) coder;

/**
 * Writes the keyCode, and modifierFlags to the coder.
 * It doesn't write anything else in the coder.
 *
 * @param coder An NSCoder.
 */
- (void) encodeWithCoder:(NSCoder *) coder;

/**
 * Disposes of an internal static lookup dictionary that's used
 * for all GDCarbonEvents
 *
 * You only need to use this if you use a GDCarbonEvent,
 * then stop using it and need to be sure all memory associated
 * with a GDCarbonEvent is freed.
 */
+ (void) disposeOfLookupManager;

/**
 * Set the hotkey signature for a carbon hot key event.
 *
 * @param signature An NSString to use for the signature - this should be at max
 * 4 characters - it's converted into a FourCharCode.
 */
- (void) setHotKeySignature:(NSString *) signature;

/**
 * Set the hotkey id for a carbon hot key event.
 *
 * @param kid The hotkey id.
 */
- (void) setHotKeyId:(int) kid;

/**
 * The hotkey id.
 */
- (int) hotKeyId;

/**
 * Sets the event class for a carbon event.
 *
 * @param eventClass An event class.
 */
- (void) setEventClass:(FourCharCode) eventClass;

/**
 * Set's the event kind for a carbon event.
 *
 * @param eventKind An event kind.
 */
- (void) setEventKind:(NSUInteger) eventKind;

/**
 * Set the event class and event kind for a carbon event.
 *
 * @param eventClass An event class.
 * @param eventKind An event kind.
 */
- (void) setEventClass:(FourCharCode) eventClass andEventKind:(NSUInteger) eventKind;

/**
 * Returns the modifier keys converted into a cocoa modifier int.
 */
- (NSUInteger) cocoaModifierKeys;

/**
 * Installs the event.
 */
- (void) install;

/**
 * Uninstalls the event.
 */
- (void) uninstall;

/**
 * Performs the callback action desired, either target/action or notification.
 *
 * Target/selector takes precedence if both target/sel and notifications are set.
 */
- (void) invoke;

/**
 * Initialize with event class, and event kind.
 *
 * @param eventClass An event class.
 * @param eventKind An event kind.
 */
- (id) initWithEventClass:(FourCharCode) eventClass andEventKind:(NSUInteger) eventKind;

/**
 * Set the notification name, and notification center if you want
 * this event to post notifications.
 *
 * @param name The notification name to post.
 * @param center The NSNotificationCenter to post to.
 */
- (void) setNotificationName:(NSString *) name andNotificationCenter:(NSNotificationCenter *) center;

/**
 * Set the action and target for this event if you want the
 * callback to call a selector.
 *
 * @param action The action to call.
 * @param target The target that contains the selector.
 */
- (void) setAction:(SEL) action andTarget:(id) target;

/**
 * Set keycode, and modifier flags, optionally tell it that the flags
 * were cocoa and need to be converted to carbon modifier flags.
 *
 * @param code The key char code.
 * @param flags Any modifier flags (0 if none).
 * @param cocoaFlags Whether or not the flags came from the cocoa representation
 * or modifier flags, if so they will be converted to carbon
 */
- (void) setKeyCode:(NSUInteger) code andFlags:(NSUInteger) flags areFlagsCocoa:(Boolean) cocoaFlags;

/**
 * This returns a string that represents the value of the keyCode,
 * and modifier keys all added together: keyCode+modifiers.
 */
- (NSString *) keyString;

@end
