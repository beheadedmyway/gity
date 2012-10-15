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

#import "GTGitDiff.h"

@implementation GTGitDiff
@synthesize filePaths;
@synthesize contextValue;
@synthesize diffContent;
@synthesize left;
@synthesize right;
@synthesize isCommitDiff;

- (void) appendPath:(NSString *) _path {
	[filePaths addObject:_path];
	diffMode=0;
}

- (void) headVSWorkingTree {
	diffMode=0;
}

- (void) headVSStage {
	diffMode=1;
}

- (void) stageVSWorkingTree {
	diffMode=2;
}

- (void) workingTreeChanges {
	diffMode=0;
}

- (void) stagedChanges {
	diffMode=1;
}

- (BOOL) isStagedChangesMode {
	return (diffMode == 1);
}

- (BOOL) isWorkingTreeChangesMode {
	return (diffMode == 0);
}

- (BOOL) isStageVSWorkingTreeMode {
	return (diffMode == 2);
}

- (NSInteger) filePathsCount {
	if(filePaths is nil) return 0;
	return [filePaths count];
}

- (NSString *) contextValueAsString {
	return [NSString stringWithFormat:@"%li",contextValue];
}

- (NSString *) diffModeAsString {
	return [NSString stringWithFormat:@"%li",diffMode];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTGitDiff\n");
	#endif
	GDRelease(filePaths);
	GDRelease(diffContent);
	diffMode=0;
	contextValue=0;
	[super dealloc];
}

@end
