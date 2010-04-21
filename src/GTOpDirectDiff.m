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

#import "GTOpDirectDiff.h"

@implementation GTOpDirectDiff

- (id) initWithGD:(GittyDocument *) _gd andDiff:(GTGitDiff *) _diff andTemplate:(NSString *) _template {
	diff=[_diff retain];
	diffTemplate=[_template retain];
	self=[super initWithGD:_gd];
	return self;
}

- (void) setArguments {
	//NSLog(@"SET ARGS");
	if([self isCancelled]) return;
	readsSTDERR=true;
	readsSTDOUT=true;
	if([self isCancelled]) return;
	if([diff isCommitDiff]) {
		//NSLog(@"isCommitDiff");
		//NSLog(@"%@ %@",[diff left],[diff right]);
		[args addObject:@"diff"];
		NSString * lr = [[[diff left] stringByAppendingString:@".."] stringByAppendingString:[diff right]];
		[args addObject:lr];
	} else {
		if([diff isWorkingTreeChangesMode]) [args addObject:@"diff"];
		if([self isCancelled]) return;
		if([diff isStagedChangesMode]) {
			[args addObject:@"diff"];
			[args addObject:@"--cached"];
		}
		if([self isCancelled]) return;
		if([diff isStageVSWorkingTreeMode]) [args addObject:@"diff-files"];
	}
	[args addObject:@"--no-renames"];
	[args addObject:@"--no-ext-diff"];
	[args addObject:[NSString stringWithFormat:@"-U%@",[diff contextValueAsString]]];
	if([self isCancelled]) return;
	NSMutableArray * files=[diff filePaths];
	if(files) {
		[args addObject:@"--"];
		NSString * file;
		for(file in files) [args addObject:[NSString stringWithFormat:@"%@",file]];
	}
	//NSLog(@"%@",args);
	files=nil;
	if([self isCancelled]) return;
	[self updateArguments];
}

- (void) taskComplete {
	if([self isCancelled]) return;
	NSString * replaced1 = [stout stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
	NSString * replaced2 = [replaced1 stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
	NSArray * parts = [diffTemplate componentsSeparatedByString:@"@content@"];
	NSString * diffHTML = [parts componentsJoinedByString:replaced2];
	[diff setDiffContent:diffHTML];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTOpDirectDiff\n");
	#endif
	GDRelease(diff);
	GDRelease(diffTemplate);
	[super dealloc];
}

@end