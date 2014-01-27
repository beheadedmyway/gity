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

#import "GTOpReportCommit.h"
#import "GittyDocument.h"

@implementation GTOpReportCommit

- (id) initWithGD:(GittyDocument *) _gd andCommitContent:(NSString *) _commitContent {
	self=[super initWithGD:_gd];
	commitContent=[_commitContent copy];
	return self;
}

- (void) setArguments {
	if([self isCancelled]) return;
	[self setArgumentsWithPythonScript:[GTPythonScripts reportCommit] setArgsOnTask:true];
}

- (void) main {
@autoreleasepool {
	if(done) return;
	NSString * fileName = [[[gd git] gitProjectPath] stringByAppendingString:[GTJSONFiles commitReport]];
	NSFileHandle * fileToWrite = [[NSFileHandle alloc] initWithTruncatedFile:fileName];
	if(fileToWrite is nil) return;
	NSData * data = [commitContent dataUsingEncoding:NSUTF8StringEncoding];
	if(done) return;
	[fileToWrite writeData:data];
	[fileToWrite closeFile];
	[fileToWrite release];
	[super main];
}
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTOpReportCommit\n");
	#endif
	GDRelease(commitContent);
	[super dealloc];
}

@end
