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

#import "GTOpDiscardChanges.h"
#import "GittyDocument.h"

@implementation GTOpDiscardChanges

- (void) setArguments {
	if([self isCancelled]) return;
	[self setArgumentsWithPythonScript:[GTPythonScripts discardChangesScript] setArgsOnTask:false];
	if([self isCancelled]) return;
	NSMutableArray * filesToDiscard = [[gd activeBranchView] filesForDiscard];
	if(filesToDiscard is nil) {
		done = true;
		return;
	}
	for(int i = 0; i < [filesToDiscard count]; i++) [args addObject:[@"-f " stringByAppendingString:[filesToDiscard objectAtIndex:i]]];
	[task setArguments:args];
}

@end
