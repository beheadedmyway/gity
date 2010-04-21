//copyright 2009 aaronsmith

#include <asl.h>
#import <Cocoa/Cocoa.h>

/**
 * @file GDASLLog.h
 *
 * Header file for GDASLLog.
 */

//Forward declaration.
@class GDASLLogManager;

/**
 * The GDASLLog is a wrapper around Apple's system log facility (man asl).
 */
@interface GDASLLog : NSObject {
	
	Boolean logToStdOut;
	
	/**
	 * File descriptor for log file.
	 */
	int fd;
	
	/**
	 * Apple Sys Log client.
	 */
	aslclient client;
	
	/**
	 * The log manager.
	 */
	GDASLLogManager * manager;
}

/**
 * Whether or not to log all messages to
 * stdout as well.
 */
@property (assign) Boolean logToStdOut;

/**
 * Designated initializer - inits with required parameters.
 *
 * Here's an extracted example:
 * @code
 * GDASLLog * log = [[GDASLLog alloc] initWithSender:@"MyAppName" facility:@"my.company.AppName" connectImmediately:TRUE];
 * [log setLogFile:@"/var/log/MyApp"];
 * [log info:@"TEST"];
 * @endcode
 */
- (id) initWithSender:(NSString *) sender facility:(NSString *) facility connectImmediately:(Boolean) connectImmediately;

/**
 * Set's a log file to write all logs to. If a log
 * file isn't set the logs aren't stored, they're still
 * visible in the console.
 */
- (int) setLogFile:(NSString *) filePath;

/**
 * Alert message.
 */
- (void) alert:(NSString *) message;

/**
 * Critical message.
 */
- (void) critical:(NSString *) message;

/**
 * Debug message.
 */
- (void) debug:(NSString *) message;

/**
 * Emergency message.
 */
- (void) emergency:(NSString *) message;

/**
 * Error message.
 */
- (void) error:(NSString *) message;

/**
 * Info message.
 */
- (void) info:(NSString *) message;

/**
 * Notice message.
 */
- (void) notice:(NSString *) message;

/**
 * Warning message.
 */
- (void) warning:(NSString *) message;

/**
 * Close this log. If you call close directly
 * this log won't work anymore - it's
 * called when this object is deallocated.
 */
- (void) close;

@end
