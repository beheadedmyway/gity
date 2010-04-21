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

#import "GTOpCloneRepo.h"
#import "GittyDocument.h"
#import "GTCloneRepoController.h"

@implementation GTOpCloneRepo
@synthesize cloneController;
@synthesize pathToOpen;

- (id) initWithRepoURL:(NSString *) url inDir:(NSString *) _dir {
	done=false;
	canceled=false;
	args = [[NSMutableArray alloc] init];
	repoURL = [url copy];
	dir = [_dir copy];
	self=[super init];
	[self initializeTask];
	[self setArguments];
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
	readsSTDOUT=true;
	[args addObject:[GTPythonScripts getCloneRepoScript]];
	if([self isCancelled]) return;
	[args addObject:[@"-g " stringByAppendingString:[git gitExecPath]]];
	[args addObject:[@"-r " stringByAppendingString:repoURL]];
	[task setArguments:args];
}

- (void) main {
	if([self isCancelled]) goto cleanup;
	[task launch];
	if(readsSTDOUT) [self readSTDOUT];
	if(readsSTDERR) [self readSTDERR];
	[task waitUntilExit];
cleanup:
	[self taskComplete];
}

- (void) taskComplete {
	NSInteger res = [task terminationStatus];
	if(res > 84) {
		[cloneController onCloneError:res];
		done=true;
		return;
	}
	pathToOpen=[stout copy];
	done=true;
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTOpCloneRepo\n");
	#endif
	GDRelease(git);
	GDRelease(repoURL);
	GDRelease(dir);
	GDRelease(pathToOpen);
	cloneController = nil;
	[super dealloc];
}

@end
