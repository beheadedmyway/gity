//copyright 2009 aaronsmith

#import <Cocoa/Cocoa.h>
#import "GDCarbonEvent.h"

/**
 * @file GDCarbonEventManager.h
 *
 * Header file for GDCarbonEventManager.
 */

/**
 * The GDCarbonEventManager manages multiple
 * GDCarbonEvents.
 *
 * This is useful for handling multiple GDCarbonEvents
 * that potentially listen for the same event, but are
 * unique how the callbacks react.
 *
 * As an example, suppose you have two GDCarbonEvents that
 * are hotkey events for the key shortcut cmd+shft+F. Both
 * can't be installed at the same time, so you can use this
 * manager to do the installation for you, which gives you
 * some options about how to install them.
 */
@interface GDCarbonEventManager : NSObject {
	
	/**
	 * A lookup for non-group GDCarbonEvents.
	 */
	NSMutableDictionary * eventsLookup;
	
	/**
	 * A lookup for event groups.
	 */
	NSMutableDictionary * eventGroups;
	
	/**
	 * A lookup for non group queued installs.
	 */
	NSMutableDictionary * eventInstallQueueDict;
	
	/**
	 * The queue for non group queued installs.
	 */
	NSMutableArray * eventInstallQueueArray;
	
	/**
	 * A lookup for group queued installs.
	 */
	NSMutableDictionary * eventInstallQueueForGroupDict;
	
	/**
	 * A lookup of group queue arrays for installation.
	 */
	NSMutableDictionary * eventInstallQueueForGroups;
}

/**
 * Singleton instance.
 */
+ (instancetype) sharedInstance;

/**
 * Class method to convert carbon to cocoa
 * key modifiers.
 */
+ (NSUInteger) carbonToCocoaModifierFlags:(NSUInteger) carbonFlags;

/**
 * Class method to convert cocoa to carbon
 * key modifiers.
 */
+ (NSUInteger) cocoaToCarbonModifierFlags:(NSUInteger) cocoaFlags;

/**
 * Queues a GDCarbonEvent to install.
 *
 * @param event The GDCarbonEvent to enqueue.
 * @param unique Whether or not the event has to be unique.
 */
- (void) queueForInstall:(GDCarbonEvent *) event unique:(Boolean) unique;

/**
 * Queues a GDCarbonEvent to install in a group.
 */
- (void) queueForInstall:(GDCarbonEvent *) event intoGroup:(NSString *) groupName unique:(Boolean) unique;

/**
 * Register a GDCarbonEvent with the manager. This does not
 * install the event.
 *
 * @param event The GDCarbonEvent to register.
 * @param uninstall Whether or not to uninstall the same event if it already
 * exists in the manager.
 */
- (void) registerGDCarbonEvent:(GDCarbonEvent *) event uninstallIfExists:(Boolean) uninstall;

/**
 * Register a GDCarbonEvent with the manager and install the event.
 *
 * @param event The GDCarbonEvent to register.
 * @param uninstall Whether or not to uninstall the same event if it already
 * exists in the manager.
 */
- (void) registerAndInstallGDCarbonEvent:(GDCarbonEvent *) event uninstallIfExists:(Boolean) uninstall;

/**
 * Register a GDCarbonEvent with a group.
 *
 * @param event The GDCarbonEvent to register.
 * @param groupName A group name that the event will be registered with.
 * @param uninstall Whether or not to uninstall the same event if it already
 * exists in the group.
 */
- (void) registerGDCarbonEvent:(GDCarbonEvent *) event inGroup:(NSString *) groupName uninstallIfExists:(Boolean) uninstall;

/**
 * Register a GDCarbonEvent with a group and install the event.
 *
 * @param event The GDCarbonEvent to register.
 * @param groupName A group name that the event will be registered with.
 * @param uninstall Whether or not to uninstall the same event if it already
 * exists in the group.
 */
- (void) registerAndInstallGDCarbonEvent:(GDCarbonEvent *) event inGroup:(NSString *) groupName uninstallIfExists:(Boolean) uninstall;

/**
 * Unregister a GDCarbonEvent from the manager.
 *
 * @param event The GDCarbonEvent to unregister.
 * @param uninstall Whether or not to uninstall the event.
 */
- (void) unregisterGDCarbonEvent:(GDCarbonEvent *) event shouldUninstall:(Boolean) uninstall;

/**
 * Releases a group but doesn't uninstall it.
 *
 * @param groupName The group name to release.
 */
- (void) releaseGroup:(NSString *) groupName;

/**
 * Uninstalls all GDCarbonEvents in a group then releases
 * the group.
 */
- (void) uninstallAndReleaseGroup:(NSString *) groupName;

/**
 * Registers and installs all queued events.
 */
- (void) registerAndInstallQueuedEvents;

/**
 * Registers and installs all queued events in a group queue.
 */
- (void) registerAndInstallQueuedEventsForGroup:(NSString *) groupName;

/**
 * Flushes the queue for installing GDCarbonEvents.
 */
- (void) flushQueuedInstall;

/**
 * Flushes the queue for a group of GDCarbonEvents.
 *
 * @param groupName The group name's queue to flush.
 */
- (void) flushQueuedInstallForGroup:(NSString *) groupName;

/**
 * Flushes all queued group installs.
 */
- (void) flushAllQueuedGroupInstalls;

/**
 * Releases all GDCarbonEvents registered.
 *
 * This does not uninstall the events.
 *
 * This does not guarantee that a GDCarbonEvent is disposed of -
 * if you have a reference to it from somewhere else it won't be
 * deallocated.
 */
- (void) releaseAll;

/**
 * Uninstalls all GDCarbonEvents.
 *
 * This uninstalls all GDCarbonEvents, then releases
 * the dictionary used to store them.
 *
 */
- (void) uninstallAndReleaseAll;

/**
 * Uninstalls all registered GDCarbonEvents, but does not dispose of
 * or release any of them from the manager.
 */
- (void) uninstallAll;

/**
 * Installs all registered GDCarbonEvents.
 */
- (void) installAll;

@end

