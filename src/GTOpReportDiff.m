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

#import "GTOpReportDiff.h"
#import "GittyDocument.h"

@implementation GTOpReportDiff

- (id) initWithGD:(GittyDocument *) _gd andDiffContent:(NSString *) _diffContent {
	self=[super initWithGD:_gd];
	diffContent=[_diffContent copy];
	return self;
}

- (void) setArguments {
	if([self isCancelled]) return;
	[self setArgumentsWithPythonScript:[GTPythonScripts reportDiff] setArgsOnTask:true];
}

- (void) main {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	
	if(done) goto cleanup;
	NSString * fileName = [[[gd git] gitProjectPath] stringByAppendingString:[GTJSONFiles diffReport]];
	NSFileHandle * fileToWrite = [[NSFileHandle alloc] initWithTruncatedFile:fileName];
	if(fileToWrite is nil) goto cleanup;
	NSData * data = [diffContent dataUsingEncoding:NSUTF8StringEncoding];
	if(done) goto cleanup;
	[fileToWrite writeData:data];
	[fileToWrite closeFile];
	[fileToWrite release];
	[super main];
cleanup:
	[pool drain];
	return;
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTOpReportDiff\n");
	#endif
	GDRelease(diffContent);
	[super dealloc];
}

@end
