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

#import "GTOpDiff.h"

@implementation GTOpDiff

- (void) setArguments {
	if([self isCancelled]) return;
	[self setArgumentsWithPythonScript:[GTPythonScripts diff] setArgsOnTask:true];
}

- (void) setDiff:(GTGitDiff *) _diff {
	[args addObject:[@"-m " stringByAppendingString:[_diff diffModeAsString]]];
	[args addObject:[@"-m " stringByAppendingString:[_diff contextValueAsString]]];
	if([_diff filePathsCount] > 0) {
		NSMutableArray * filepaths = [_diff filePaths];
		NSString * filepath;
		for (filepath in filepaths) {
			[args addObject:[@"-f " stringByAppendingString:filepath]];
		}
	}
	[self updateArguments];
}

@end
