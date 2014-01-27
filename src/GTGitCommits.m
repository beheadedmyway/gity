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

#import "GTGitCommits.h"

@implementation GTGitCommits

- (void) loadSimpleCommitHistory {
}

- (void) loadSimpleCommitHistoryWithCallback:(id) _target toAction:(SEL) _action {
	_simpleLoadCLTarget=_target;
	_simpleLoadCLAction=_action;
	isSimpleLoadWithCallback=true;
	[self loadSimpleCommitHistory];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTGitCommits\n");
	#endif
	_simpleLoadCLTarget=nil;
	_simpleLoadCLAction=nil;
}

@end
