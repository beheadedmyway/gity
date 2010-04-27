
#import <Cocoa/Cocoa.h>
#import "GDBaseObject.h"

/**
 * @file GDCliProxy.h
 * 
 * Header file for GDCliProxy.
 */

/**
 * The GDCliProxy is the host proxy you use inside of your application that needs
 * to expose some usage from the commandline.
 *
 * You use this class inside of your app, then use GDCliProxyConnector inside of
 * your commandline tool to connect to this proxy.
 */
@interface GDCliProxy : GDBaseObject {
	
	/**
	 * An NSConnection for distributed objects.
	 */
	NSConnection * connection;
}

/**
 * An NSConnection for distributed objects.
 */
@property (retain) NSConnection * connection;

/**
 * Connect the NSConnection using connection name.
 *
 * @param connectionName The connection name to use when the NSConnection connects.
 */
- (void) connectWithConnectionName:(NSString *) connectionName;

@end
