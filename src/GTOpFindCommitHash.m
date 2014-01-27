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

#import "GTOpFindCommitHash.h"

@implementation GTOpFindCommitHash

- (id) initWithGD:(GittyDocument *)_gd andTarget:(id) _target andAction:(SEL) _action andArchiveFile:(NSString *) _archiveFile {
	archiveFile = [_archiveFile copy];
	self=[super initWithGD:_gd andTarget:_target andAction:_action];
	return self;
}

- (void) setArguments {
	if([self isCancelled]) return;
	[self setArgumentsWithPythonScript:[GTPythonScripts findCommitFromArchive] setArgsOnTask:true];
	[args addObject:[@"-m " stringByAppendingString:archiveFile]];
	[self updateArguments];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTOpFindCommitHash\n");
	#endif
	GDRelease(archiveFile);
}

@end
