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

#import "GTOpLoadCommitDetails.h"

@implementation GTOpLoadCommitDetails

- (id) initWithGD:(GittyDocument *) _gd andCommit:(GTGitCommit *) _commit andCommitLoadInfo:(GTGitCommitDetailLoadInfo *) _loadInfo andTemplate:(NSString *) _template {
	commitTemplate=[_template retain];
	commit=[_commit retain];
	loadInfo=[_loadInfo retain];
	self=[super initWithGD:_gd];
	return self;
}

- (void) setArguments {
	if([self isCancelled]) return;
	readsSTDOUT=true;
	[args addObject:@"show"];
	[args addObject:@"--pretty=raw"];
	[args addObject:@"-M"];
	[args addObject:@"--no-color"];
	[args addObject:[@"-U" stringByAppendingFormat:@"%li",[loadInfo contextValue]]];
	[args addObject:[commit hash]];
	[self updateArguments];
}

- (void) taskComplete {
	if([self isCancelled]) return;
	NSString * replaced1 = [stout stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
	NSString * replaced2 = [replaced1 stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
	NSArray * parts = [commitTemplate componentsSeparatedByString:@"@content@"];
	NSString * commitHTML = [parts componentsJoinedByString:replaced2];
	[loadInfo setParsedCommitDetails:commitHTML];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTOpLoadCommitDetails\n");
	#endif
	GDRelease(commit);
	GDRelease(commitTemplate);
	GDRelease(loadInfo);
	[super dealloc];
}

@end
