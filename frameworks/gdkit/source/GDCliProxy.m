//copyright 2009 aaronsmith

#import "GDCliProxy.h"

@implementation GDCliProxy
@synthesize connection;

- (void) connectWithConnectionName:(NSString *) connectionName {
	connection=[[NSConnection alloc] init];
	[connection setRootObject:self];
	[connection registerName:connectionName];
}

- (void) dealloc {
	GDRelease(connection);
}

@end
