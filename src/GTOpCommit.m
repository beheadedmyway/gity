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

#import "GTOpCommit.h"
#import "GittyDocument.h"

@interface GTOpCommit(internal)
- (void) setArgumentsAndFiles:(NSArray *)files;
@end

@implementation GTOpCommit

- (id) initWithGD:(GittyDocument *) _gd andFiles:(NSArray *)files {
	if(self=[super initWithGD:_gd]) {
		args=[[NSMutableArray alloc] init];
		readsSTDERR=true;
		[self initializeTask];
		[self setArgumentsAndFiles:files];
	}
	return self;
}

- (void) setArgumentsAndFiles:(NSArray *)files {
	if([self isCancelled]) return;
	[self setArgumentsWithPythonScript:[GTPythonScripts commitScript] setArgsOnTask:false];
	if([self isCancelled]) return;
	NSString * message = [[gd commit] commitMessageValue];
	NSString * file = [[git gitProjectPath] stringByAppendingString:@"/.git/vendor/gity/tmp/commitmsg"];
	NSFileHandle * fileHandle = [[NSFileHandle alloc] initWithTruncatedFile:file];
	NSData * commitMessage = [message dataUsingEncoding:NSUTF8StringEncoding];
	[fileHandle writeData:commitMessage];
	[fileHandle release];
	if([[gd commit] shouldSignoff]) [args addObject:@"-m1"];
	if (files && [files count] > 0) {
		for (int i = 0; i < [files count]; i++) {
			[args addObject:[@"-f " stringByAppendingString:[files objectAtIndex:i]]];
		}
	}
	[task setArguments:args];
}

- (void) setArguments {
	[self setArgumentsAndFiles:nil];
}

@end
