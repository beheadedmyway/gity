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

#import "GTOpInitRepo.h"

@implementation GTOpInitRepo

- (id) initWithTargetDir:(NSString *) _dir {
	dir = [_dir copy];
	modals = [GTModalController sharedInstance];
	self=[super initWithGD:nil];
	return self;
}

- (void) initializeTask {
	if([self isCancelled]) return;
	[self setEnviron];
	git = [[GTGitCommandExecutor alloc] init];
	task = [git newPythonBinTask];
	[task setEnvironment:[self environment]];
	[task setCurrentDirectoryPath:dir];
}

- (void) setArguments {
	[args addObject:[GTPythonScripts initRepoScript]];
	if([self isCancelled]) return;
	[args addObject:[@"-g " stringByAppendingString:[git gitExecPath]]];
	[self updateArguments];
}

- (void) main {
	if([self isCancelled]) goto cleanup;
	[task launch];
	[task waitUntilExit];
cleanup:
	[self taskComplete];
}

- (void) taskComplete {
	NSInteger res = [task terminationStatus];
	if(res > 84) {
		[modals runModalFromCode:res];
	}
	done = true;
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTOpInitRepo\n");
	#endif
	GDRelease(git);
	GDRelease(dir);
	modals = nil;
	[super dealloc];
}

@end
