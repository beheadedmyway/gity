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

#import "GTOpAddFiles.h"
#import "GittyDocument.h"

@implementation GTOpAddFiles

- (void) setArguments {
	[self setArgumentsWithPythonScript:[GTPythonScripts addFilesScript] setArgsOnTask:false];
	if([self isCancelled]) return;
	NSMutableArray * filesToAdd = [[gd activeBranchView] filesForAdd];
	for (int i = 0; i < [filesToAdd count]; i++) {
		[args addObject:[@"-f " stringByAppendingString:[filesToAdd objectAtIndex:i]]];
	}
	if([self isCancelled]) return;
	[task setArguments:args];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTOpAddFiles\n");
	#endif
	[super dealloc];
}

@end
