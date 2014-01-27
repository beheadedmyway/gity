//copyright 2009 aaronsmith

#import <Cocoa/Cocoa.h>
#import "GDASLLog.h"

/**
 * @file GDASLLogManager.h
 *
 * Header file for GDASLLogManager.
 */

/**
 * The GDASLLogManager manages GDASLLog objects.
 *
 * Here's an extracted example:
 * @code
 * GDASLLogManager * logManager = [GDASLLogManager sharedInstance];
 * GDASLLog * log = [[GDASLLog alloc] initWithSender:@"MyAppName" facility:@"my.company.AppName" connectImmediately:TRUE];
 * [log setLogFile:@"/var/log/MyApp"];
 * [log info:@"TEST"];
 * [logManager setLog:log forKey:@"main"];
 *
 * //pull out the log:
 * GDASLLog * mainLog = [GDASLLogManager getLogForKey:@"main"];
 * [mainLog info:@"TEST2"];
 * @endcode
 */
@interface GDASLLogManager : NSObject {
	
	Boolean enabled;
	
	/**
	 * Lookup for any stored log objects.
	 */
	NSMutableDictionary * logs;
}

/**
 * Whether or not logging is enabled. You can
 * toggle this to disable or enable all GDASLLog
 * instances - they're just disabled, not
 * destroyed.
 */
@property (assign) Boolean enabled;

/**
 * Singleton instance.
 */
+ (instancetype) sharedInstance;

/**
 * Set a log object for key.
 *
 * @param log The GDASLLog to save.
 * @param key The key to store it with.
 */
- (void) setLog:(GDASLLog *) log forKey:(NSString *) key;

/**
 * Get a log object by key.
 *
 * @param key The key the log was saved with.
 */
- (GDASLLog *) getLogForKey:(NSString *) key;

@end
