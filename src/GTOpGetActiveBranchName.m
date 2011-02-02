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

#import "GTOpGetActiveBranchName.h"
#import "GittyDocument.h"

@implementation GTOpGetActiveBranchName

- (void) setArguments {
	if([self isCancelled]) return;
	readsSTDOUT=true;
	[self setArgumentsWithPythonScript:[GTPythonScripts getCurrentBranchScript] setArgsOnTask:true];
}

- (void) taskComplete {
	if([self isCancelled]) return;
	if([task terminationStatus] == 79) {
		[gitd setIsHeadDetatched:true];
		if([self isCancelled]) return;
		[gitd setCurrentAbbreviatedSha:stout];
		//[gitd setActiveBranchName:[gitd currentAbbreviatedSha]];
		[gitd setActiveBranchName:@"(no branch)"];
	} else {
		[gitd setIsHeadDetatched:false];
		if([self isCancelled]) return;
		[gitd setActiveBranchName:stout];
	}
}

@end
