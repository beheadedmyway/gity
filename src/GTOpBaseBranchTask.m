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

#import "GTOpBaseBranchTask.h"

@implementation GTOpBaseBranchTask

- (id) initWithGD:(GittyDocument *) _gd andBranchName:(NSString *) _branchName {
	branchName=[_branchName copy];
	self=[super initWithGD:_gd];
	return self;
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTOpBaseBranchTask\n");
	#endif
	GDRelease(branchName);
	[super dealloc];
}

@end
