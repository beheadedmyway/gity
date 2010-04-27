
#import <Cocoa/Cocoa.h>

/**
 * @file GDCliProxyConnector.h
 * 
 * Header file for GDCliProxyConnector.
 */

/**
 * The GDCliProxyConnector wraps up the distributed object (NSDistantObject) logic,
 * needed to connect to a registered application and give you back the
 * root proxy.
 * 
 * This class is used inside of a commandline tool to connect to a GDCliProxy
 * and call methods that it exposes.
 *
 * Example usage:
 * @code
 * //mytool.m:
 * 
 * #import "GDCliProxyConnector.m"
 * void main(int argc, char * argv[]) {
 *     NSAutoReleasePool * pool = [[NSAutoReleasePool alloc] init];
 *     GDCliProxyConnector * connector = [[[GDCliProxyConnector alloc] init];
 *     [connector setDistantProtocol:@protocol(MyProtocol)];
 *     
 *     //get the distant object. this will launch the application if the
 *     //connection is not available, and keep trying to connect.
 *     //it will attempt 50 connections.
 *     NSDistantObject * proxy = [connector getDistantObjectInApplication:@"com.mycompany.MyApplication" withConnectionName:@"cliConnection" andLaunchAppIfNotAvailable:true];
 *     
 *     //call a method on the distant object to do something
 *     //from within your application.
 *     [proxy myMethod];
 *     [pool drain];
 * }
 * @endcode
 */
@interface GDCliProxyConnector : NSObject {
	
	/**
	 * The NSDistantObjects' protocol. 
	 */
	Protocol * distantProtocol;
}

/**
 * Get an NSDistantObject from a connection name. If the connection is
 * not available the application will be launched, and 50 connection attempt
 * will be made after it's launched or the distant object will be returned
 * if it's connected sooner.
 *
 * This returns nil after all attempts to connect to the object have been
 * exhausted.
 *
 * @param _bundleIdentifier The application's bundle identifier.
 * @param _connectionName The connection name used to connect a GDCliProxy.
 * @param _launch Whether or not to launch the application if no connection can be made.
 */
- (NSDistantObject *) getDistantObjectInApplication:(NSString *) _bundleIdentifier withConnectionName:(NSString *) _connectionName andLaunchAppIfNotAvailable:(BOOL) _launch;

/**
 * Set the protocol on the NSDistantObject.
 *
 * @param _protocol The protocol.
 */
- (void) setDistantProtocol:(id) _protocol;

/**
 * [internal].
 */
- (NSDistantObject *) connectWithName:(NSString *) _connectionName;

@end
