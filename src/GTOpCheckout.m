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

#import "GTOpCheckout.h"

@implementation GTOpCheckout

- (id) initWithGD:(GittyDocument *)_gd andBranchForCheckout:(NSString *) _branch {
	branch=[_branch copy];
	self=[super initWithGD:_gd];
    readsSTDOUT=true;
    readsSTDERR=true;
	return self;
}

- (void) setArguments {
	if([self isCancelled]) return;
	[self setArgumentsWithPythonScript:[GTPythonScripts checkoutScript] setArgsOnTask:true];
	[args addObject:[@"-m " stringByAppendingString:branch]];
	[self updateArguments];
}

- (void) main {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	
	if([self isCancelled]) goto cleanup;
	[task launch];
	if(readsSTDOUT) [self readSTDOUT];
	if(readsSTDERR) [self readSTDERR];
	[task waitUntilExit];
cleanup:
	[self performSelectorOnMainThread:@selector(taskComplete) withObject:nil waitUntilDone:YES];
	[pool drain];
}

- (void) taskComplete {
	NSInteger res = [task terminationStatus];
    if (res >= 84) {
		done=true;
		[[gd modals] runModalFromCode:res];
		return;
	}
	//pathToOpen=[stout copy];
	done=true;
}


- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTOpCheckout\n");
	#endif
	GDRelease(branch);
	[super dealloc];
}

@end
