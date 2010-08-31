//copyright 2009 aaronsmith

#import "GDCliProxyConnector.h"
#import "macros.h"

@implementation GDCliProxyConnector

- (NSDistantObject *) connectWithName:(NSString *) _connectionName {
	NSDistantObject * proxy = [NSConnection rootProxyForConnectionWithRegisteredName:_connectionName host:nil];
	return proxy;
}

- (NSDistantObject *) getDistantObjectInApplication:(NSString *) _bundleIdentifier withConnectionName:(NSString *) _connectionName andLaunchAppIfNotAvailable:(BOOL) _launch {
	NSDistantObject * proxy = [self connectWithName:_connectionName];
	if(proxy) {
		if(distantProtocol)[proxy setProtocolForProxy:distantProtocol];
		return proxy;
	}
	if(!_launch) return nil;
	[[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:_bundleIdentifier options:NSWorkspaceLaunchAsync additionalEventParamDescriptor:nil launchIdentifier:nil];
	for(int c = 0;proxy==nil && c<50; c++) {
		proxy=[self connectWithName:_connectionName];
		if(proxy)break;
		usleep(15000);
	}
	if(proxy){
		if(distantProtocol)[proxy setProtocolForProxy:distantProtocol];
		return proxy;
	}
	return nil;
}

- (void) setDistantProtocol:(Protocol *) _protocol {
	distantProtocol=_protocol;
}

- (void) dealloc {
	GDRelease(distantProtocol);
	[super dealloc];
}

@end
