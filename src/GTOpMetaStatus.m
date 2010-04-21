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

#import "GTOpMetaStatus.h"

@implementation GTOpMetaStatus

- (void) setArguments {
	if([self isCancelled]) return;
	[self setArgumentsWithPythonScript:[GTPythonScripts metaStatus] setArgsOnTask:true];
}

- (void) taskComplete {
	if([self isCancelled]) return;
	NSString * file = [[git gitProjectPath] stringByAppendingString:[GTJSONFiles metaStatusFile]];
	NSFileHandle * read = [[NSFileHandle alloc] initWithFile:file];
	if(read is nil) return;
	NSData * data = [read readDataToEndOfFile];
	NSString * dataJSON = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	SBJSON * json = [[SBJSON alloc] init];
	NSDictionary * status = [json objectWithString:dataJSON error:nil];
	[dataJSON release];
	[json release];
	[read release];
	if([self isCancelled]) return;
	[gitd setRemotes:[status objectForKey:@"remotes"]];
	[gitd setSavedStashes:[status objectForKey:@"stashes"]];
	[gitd setBranchNames:[status objectForKey:@"branches"]];
	[gitd setTagNames:[status objectForKey:@"tags"]];
	[gitd setDefaultRemotes:[status objectForKey:@"default_remotes"]];
	[gitd setSubmodules:[status objectForKey:@"submodules"]];
	[gitd setRemoteTrackingBranches:[status objectForKey:@"remote_branches"]];
	[gitd setRefs:[status objectForKey:@"refs"]];
	//[gitd setSubmoduleNames:[status objectForKey:@"submodules"]];
}

@end
