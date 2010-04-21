//copyright 2009 aaronsmith

#import <Cocoa/Cocoa.h>

/**
 * @file NSWorkspace+Additions.h
 *
 * Header file for NSWorkspace cocoa additions.
 */

/**
 * Macro definition of a string you can pass to openSystemPreference,
 * for universal access.
 */
#define kGDSystemPrefUniversalAccess @"UniversalAccessPref.prefPane"

/**
 * @class NSWorkspace
 *
 * Category additions to NSWorkspace.
 */
@interface NSWorkspace (GDAdditions)

/**
 * Brings an application to the front. Requires an application
 * info dictionary, which must contain the key "NSApplicationPath"
 */
- (void) bringApplicationToFront:(NSDictionary *) appInfo;

/**
 * Brings the current application to front - uses NSBundle internally.
 */
- (void) bringCurrentApplicationToFront;

/**
 * Brings an application to the front, from an application
 * path.
 */
- (void) bringApplicationToFrontFromPath:(NSString *) appPath;

/**
 * Opens the system preferences panel and opens the specified
 * preference. Pass in an argument like "UniversalAccessPref"
 * this function will append the ".prefpane", and also search
 * in two places for the prefpane: /System/Library/PreferencePanes/,
 * and ~/Library/PreferencePanes/
 */
- (void) openSystemPreference:(NSString *) preferencesFileName;

/**
 * Installs a launch agent/startup item into ~/Library/LaunchAgents, you
 * need to pass it a "plist" file. ex: "MyAppStartup.Agent.plist"
 */
- (void) installStartupLaunchdItem:(NSString *) plistName;

/**
 * Removes a launchd agent/startup item from ~/Library/LaunchAgents, you
 * need to pass it a "plist" file. ex: "MyAppStartup.Agent.plist"
 */
- (void) uninstallStartupLaunchdItem:(NSString *) plistName;

@end
