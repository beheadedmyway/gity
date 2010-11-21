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

#import "GTOpGetGlobalConfigs.h"

@implementation GTOpGetGlobalConfigs

- (void) setArguments {
	if([self isCancelled]) return;
	[self setArgumentsWithPythonScript:[GTPythonScripts globalConfigs] setArgsOnTask:true];
}

- (void) taskComplete {
	if([self isCancelled]) return;
	NSString * file = [[git gitProjectPath] stringByAppendingString:[GTJSONFiles globalConfigsFile]];
	NSFileHandle * read = [[NSFileHandle alloc] initWithFile:file];
	if(read is nil) return;
	NSData * data = [read readDataToEndOfFile];
	[read closeFile];
	NSString * dataJSON = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	SBJSON * json = [[SBJSON alloc] init];
	NSMutableArray * status = [NSMutableArray arrayWithArray:[json objectWithString:dataJSON error:nil]];
	[dataJSON release];
	[json release];
	[read release];
	if([self isCancelled]) return;
	[gitd setGlobalConfigs:status];
}

@end
