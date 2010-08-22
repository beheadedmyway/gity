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

#import "GTBasePythonTaskOperation.h"
#import "GittyDocument.h"
#import "GTDocumentController.h"

@implementation GTBasePythonTaskOperation

- (id) initWithGD:(GittyDocument *) _gd {
	if(self=[super initWithGD:_gd]) {
		args=[[NSMutableArray alloc] init];
		readsSTDERR=true;
		[self initializeTask];
		[self setArguments];
	}
	return self;
}

- (void) initializeTask {
	if([self isCancelled]) return;
	if(![git gitProjectPath]) return;
	task=[git newPythonBinTask];
	[task setEnvironment:[self environment]];
	if([self isCancelled]) return;
	[task setCurrentDirectoryPath:[git gitProjectPath]];
}

- (void) setArgumentsWithPythonScript:(NSString *) script setArgsOnTask:(BOOL) argsOnTask {
	if([self isCancelled]) return;
	if(![git gitProjectPath]) return;
	[args addObject:script];
	[self addGitInfoPaths];
	if(argsOnTask) [task setArguments:args];
}

- (void) updateArguments {
	[task setArguments:args];
}

- (void) addGitInfoPaths {
	if([self isCancelled]) return;
	[args addObject:[@"-g " stringByAppendingString:[git gitExecPath]]];
	if([self isCancelled]) return;
	[args addObject:[@"-p " stringByAppendingString:[git gitProjectPath]]];
	if([self isCancelled]) return;
	[args addObject:[@"-v" stringByAppendingString:[GTDocumentController gityVersion]]];
}

- (void) main {
	if(done) goto cleanup;
	[task launch];
	if(readsSTDOUT) [self readSTDOUT];
	if(done) goto cleanup;
	if(readsSTDERR) [self readSTDERR];
	if(done) goto cleanup;
	[task waitUntilExit];
	if(done) goto cleanup;
	
	[self performSelectorOnMainThread:@selector(validateResult) withObject:nil waitUntilDone:YES];
	[self performSelectorOnMainThread:@selector(taskComplete) withObject:nil waitUntilDone:YES];
cleanup:
	done=true;
	return;
}

- (void) validateResult {
	int res = [task terminationStatus];
	if(res == 84) {
		//NSFileHandle * ef = [[task standardError] fileHandleForReading];
		//NSData * data = [ef readDataToEndOfFile];
		//error = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		//if([self isCancelled]) return;
		[gd unknownErrorFromOperation:sterr];
	} else if (res > 84) {
		[[gd modals] runModalFromCode:res];
		//[gd runModalFromExitStatus:res];
	}
}

- (void) cancel {
	[super cancel];
	done=true;
	if(task && [task isRunning])[task terminate];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTBasePythonTaskOperation\n");
	#endif
	GDRelease(task);
	GDRelease(args);
	[super dealloc];
}

@end
