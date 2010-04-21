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

#import "GTOpErrorEmail.h"

@implementation GTOpErrorEmail

- (id) initWithGD:(GittyDocument *)_gd andErrors:(NSString *) _errors {
	errors = [_errors copy];
	self = [super initWithGD:_gd];
	return self;
}

- (void) setArguments {
	if([self isCancelled]) return;
	[self setArgumentsWithPythonScript:[GTPythonScripts emailErrorsScript] setArgsOnTask:false];
	if([self isCancelled]) return;
	NSString * file = [[git gitProjectPath] stringByAppendingString:@"/.git/vendor/gity/tmp/errors"];
	NSFileHandle * fileHandle = [[NSFileHandle alloc] initWithTruncatedFile:file];
	NSData * errorMsg = [errors dataUsingEncoding:NSUTF8StringEncoding];
	[fileHandle writeData:errorMsg];
	[fileHandle release];
	[self updateArguments];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTOpErrorEmail\n");
	#endif
	GDRelease(errors);
	[super dealloc];
}

@end
