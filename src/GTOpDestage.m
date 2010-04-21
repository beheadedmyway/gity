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

#import "GTOpDestage.h"
#import "GittyDocument.h"

@implementation GTOpDestage

- (void) setArguments {
	if([self isCancelled]) return;
	[self setArgumentsWithPythonScript:[GTPythonScripts destageScript] setArgsOnTask:false];
	if([self isCancelled]) return;
	NSMutableArray * filesToAdd = [[gd activeBranchView] filesForDelete];
	if(filesToAdd is nil) {
		done = true;
		return;
	}
	for(int i = 0; i < [filesToAdd count]; i++) [args addObject:[@"-f " stringByAppendingString:[filesToAdd objectAtIndex:i]]];
	[task setArguments:args];
}

@end
