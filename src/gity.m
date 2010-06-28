// Copyright Aaron Smith 2009
// 
// This file is part of Gity.
// 
// Gity is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// Gity is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with Gity. If not, see <http://www.gnu.org/licenses/>.

#import "GTCLIProxy.h"

NSDistantObject * connect() {
	id proxy = [NSConnection rootProxyForConnectionWithRegisteredName:kGTCLIProxyConnectionName host:nil];
	if(proxy != nil) [proxy setProtocolForProxy:@protocol(GTCLIProxyProtocol)];
	return proxy;
}

NSDistantObject * createProxy() {
	NSDistantObject * proxy = connect();
	if(proxy) return proxy;
	[[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.macendeavor.Gity" options:NSWorkspaceLaunchAsync additionalEventParamDescriptor:nil launchIdentifier:nil];
	int c = 0;
	for(c; proxy == nil && c<50; c++) {
		if(proxy = connect()) break;
		usleep(15000);
	}
	if(proxy) return proxy;
	fprintf(stderr, "Error connecting to Gity\n");
	exit(1);
	return nil;
}

void usage() 
{
	printf("Usage: gity\n");
	exit(0);
}

int main(int argc, const char** argv) {
	fclose(stderr);
	fclose(stdout);
	fclose(stdin);
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	if(argc >= 2 && (!strcmp(argv[1], "--help") || !strcmp(argv[1], "-h"))) {
		usage();
		exit(0);
	}
	id proxy = createProxy();
	NSString * pwd = [[[NSProcessInfo processInfo] environment] objectForKey:@"PWD"];
	if(!pwd) {
		printf("Error finding working directory");
		exit(2);
	}
	[proxy openWithGity:pwd];
	[pool drain];
	return 0;
}
