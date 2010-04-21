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

#import "GTOpAddTrackingBranch.h"

@implementation GTOpAddTrackingBranch

- (id) initWithGD:(GittyDocument *) _gd andBranchName:(NSString *) _branchName andRemoteName:(NSString *) _remoteName andRemoteBranchName:(NSString *) _remoteBranchName {
	remoteBranchName=[_remoteBranchName copy];
	self=[super initWithGD:_gd andBranchName:_branchName andRemoteName:_remoteName];
	return self;
}

- (void) setArguments {
	if([self isCancelled]) return;
	[self setArgumentsWithPythonScript:[GTPythonScripts newTrackingBranch] setArgsOnTask:true];
	[args addObject:[@"-m " stringByAppendingString:branchName]];
	[args addObject:[@"-m " stringByAppendingString:remoteBranchName]];
	[args addObject:[@"-m " stringByAppendingString:remoteName]];
	[self updateArguments];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTOpAddTrackingBranch\n");
	#endif
	GDRelease(remoteBranchName);
	[super dealloc];
}

@end
