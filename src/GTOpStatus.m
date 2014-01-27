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

#import "GTOpStatus.h"
#import "GittyDocument.h"

@implementation GTOpStatus

- (void) setArguments {
	if([self isCancelled]) return;
	[self setArgumentsWithPythonScript:[GTPythonScripts statusScript] setArgsOnTask:true];
}

- (void) taskComplete {
	if([self isCancelled]) return;
	NSString * file = [NSString stringWithFormat:@"%@%@", [git gitConfigPath], [GTJSONFiles statusFile]];
	NSFileHandle * read = [[NSFileHandle alloc] initWithFile:file];
	if(read is nil) return;
	NSData * data = [read readDataToEndOfFile];
	[read closeFile];
	NSString * statusJSON = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	SBJSON * json = [[SBJSON alloc] init];
	NSDictionary * status = [json objectWithString:statusJSON error:nil];
	if([self isCancelled]) return;
	[gitd setUntrackedFiles:[status objectForKey:@"untracked"]];
	[gitd setModifiedFiles:[status objectForKey:@"modified"]];
	[gitd setDeletedFiles:[status objectForKey:@"deleted"]];
	[gitd setStageAddedFiles:[status objectForKey:@"stage_add"]];
	[gitd setStageDeletedFiles:[status objectForKey:@"stage_deleted"]];
	[gitd setStageModifiedFiles:[status objectForKey:@"stage_modified"]];
	[gitd setUnmergedFiles:[status objectForKey:@"unmerged"]];
}

@end
