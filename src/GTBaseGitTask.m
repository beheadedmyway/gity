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

#import "GTBaseGitTask.h"

@implementation GTBaseGitTask

- (id) initWithGD:(GittyDocument *) _gd {
	self=[super initWithGD:_gd];
	args=[[NSMutableArray alloc] init];
	[self initializeTask];
	[self setArguments];
	return self;
}

- (void) initializeTask {
	if([self isCancelled]) return;
	[self setEnviron];
	if(![git gitProjectPath]) return;
	task=[git newGitBashTask];
	[task setEnvironment:[self environment]];
	if([self isCancelled]) return;
}

- (void) main {
	if(done)goto cleanup;
	[task launch];
	//NSLog(@"%@",[self class]);
	if(readsSTDOUT)[self readSTDOUT];
	if(done)goto cleanup;
	if(readsSTDERR)[self readSTDERR];
	if(done)goto cleanup;
	[task waitUntilExit];
	if(done) goto cleanup;
	[self performSelectorOnMainThread:@selector(validateResult) withObject:nil waitUntilDone:YES];
	[self performSelectorOnMainThread:@selector(taskComplete) withObject:nil waitUntilDone:YES];
cleanup:
	GDRelease(task);
	close([[task standardOutput] fileDescriptor]);
	done=true;
	return;
}

- (void) cancel {
	[super cancel];
	done=true;
	if(task && [task isRunning]) [task terminate];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTBaseGitTask\n");
	#endif
	GDRelease(task);
	GDRelease(args);
	[super dealloc];
}

@end
