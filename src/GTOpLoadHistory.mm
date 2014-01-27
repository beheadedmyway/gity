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

#import "GTOpLoadHistory.h"
#import "NSFileHandle+Additions.h"

#include <ext/stdio_filebuf.h>
#include <iostream>
#include <string>
#include <map>
using namespace std;

@implementation GTOpLoadHistory

- (id) initWithGD:(GittyDocument *) _gd andLoadInfo:(GTGitCommitLoadInfo *) _loadInfo {
	self=[super initWithGD:_gd];
	loadInfo=_loadInfo;
	stoutEncoding=NSASCIIStringEncoding;
	commits=[[NSMutableArray alloc] init];
	return self;
}

- (void) setArguments {
	if([self isCancelled]) return;
	readsSTDOUT=true;
	[args addObject:@"log"];
	GTGitDataStore *dataStore = [gd gitd];
	if ([loadInfo refName])
	{
		if ([[loadInfo refName] isEqualToString:dataStore.activeBranchName] && dataStore.isHeadDetatched)
			[args addObject:dataStore.currentAbbreviatedSha];
		else
			[args addObject:[loadInfo refName]];
	}
	NSString * formatString;
    // TODO: re-enable when graph support is working
    //formatString = @"--pretty=format:\01%h\01%H\01%an\01%s\01%at\01%p";
    formatString = @"--pretty=format:\01%h\01%H\01%an\01%s\01%at\01%p";
	[args addObject:@"--topo-order"];
    //[args addObject:@"--graph"];
	[args addObject:formatString];
    
    // safety addition in case there's a filename w/ the same name as the branch.
    [args addObject:@"--"];
	
	[self updateArguments];
}

- (void) readSTDOUT {
	NSFileHandle * handle = [[task standardOutput] fileHandleForReading];
    
    NSString *line = nil;
    while ((line = [handle readLine]))
    {
        NSArray *components = [line componentsSeparatedByString:@"\01"];
        NSUInteger count = [components count];
        
        NSString *graph = nil;
        NSString *abbrevSha = nil;
        NSString *shaw = nil;
        NSString *author = nil;
        NSString *subject = nil;
        NSDate *date = nil;
        
        if (count > 0)
            graph = [components objectAtIndex:0];
        if (count > 1)
            abbrevSha = [components objectAtIndex:1];
        if (count > 2)
            shaw = [components objectAtIndex:2];
        if (count > 3)
            author = [components objectAtIndex:3];
        if (count > 4)
            subject = [components objectAtIndex:4];
        if (count > 5)
        {
            NSString *dateString = [components objectAtIndex:5];
            date = [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]];
        }
        
        GTGitCommit * commit = [[GTGitCommit alloc] init];
        [commit setGraph:graph];
		[commit setAbbrevHash:abbrevSha];
		[commit setHash:shaw];
		[commit setAuthor:author];
        [commit setSubject:subject];
		[commit setDate:date];

        if (graph)
            [commits addObject:commit];
    }
	[handle closeFile];
}

- (void) taskComplete {
    done=true;
    [gitd setHistoryCommits:commits];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTOpLoadHistory\n");
	#endif
	GDRelease(loadInfo);
	GDRelease(commits);
}

@end
