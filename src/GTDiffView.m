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

#import "GTDiffView.h"
#import "GittyDocument.h"

@implementation GTDiffView
@synthesize diffContentView;
@synthesize diffBarView;

- (void) lazyInitWithGD:(GittyDocument *) _gd {
	[super lazyInitWithGD:_gd];
	[diffBarView lazyInitWithGD:_gd];
	[diffContentView lazyInitWithGD:_gd];
	diff=[[GTGitDiff alloc] init];
	[diff workingTreeChanges];
	[self initViews];
}

- (void) initViews {
	[lineView setLineColor:[NSColor colorWithDeviceRed:.62 green:.62 blue:.62 alpha:1]];
}

- (void) releaseDiffContent {
	[diff setDiffContent:nil];
}

- (void) showDiffCommitSelectorState {
	[commitSelectorView showInView:contentContainer];
	[diffBarView showDiffSelectState];
}

- (void) moreContext {
	[[diffBarView diffStateView] moreContext];
}

- (void) lessContext {
	[[diffBarView diffStateView] lessContext];
}

- (void) rediffFromContextUpdate {
	[diff setContextValue:[[diffBarView diffStateView] contextValue]];
	[self runDiff];
}

- (void) showDiffViewer {
	[diffContentView showInView:contentContainer withAdjustments:NSMakeRect(0,0,0,-1)];
	[diffBarView showDiffState];
	[diffContentView showWebView];
}

- (void) runDiff {
	if([[gd gitd] diffTemplate] is nil) [[gd gitd] loadDiffTemplate];
	[operations runAsyncDiffWithDiff:diff andTemplate:[[gd gitd] diffTemplate] withCallback:self action:@selector(onAsyncDiffComplete)];
}

- (void) reportDiff {
	[operations runReportDiffWithDiffContent:[diff diffContent]];
}

- (void) onAsyncDiffComplete {
	[diffContentView performSelectorOnMainThread:@selector(updateWebViewWithDiff:) withObject:diff waitUntilDone:true];
}

- (void) invalidate {
	if(![self superview]) return;
	[self showDiffViewer];
	
	BOOL isSearching=[gd isSearching];
	BOOL hasReturned=false;
	NSInteger selectedFilesCount = [[gd activeBranchView] selectedFilesCount];
	NSArray * selectedGitFiles = [[gd activeBranchView] selectedGitFiles];
	NSMutableArray * selectedFiles = [[gd activeBranchView] selectedFiles];
	NSMutableArray * allFiles = [[gd activeBranchView] allFiles];
	GTGitFile * selectedGitFile = [[gd activeBranchView] selectedGitFile];
	
	[diffContentView useWhiteColor];
	[diff workingTreeChanges];
	[diff setFilePaths:nil];
	
	if(![[gd statusBarView] isDirty] && ![[gd statusBarView] isStagedFilesButtonToggled]) {
		[[diffBarView diffStateView] showNoChanges];
		[diffContentView useTiledBG];
		[diffContentView clearDiffView];
		return;
	}
	
	if([[gd statusBarView] isOnlyUntrackedFilesButtonToggled]) {
		[[diffBarView diffStateView] showNoChanges];
		[diffContentView useTiledBG];
		[diffContentView clearDiffView];
		return;
	}
	
	if([[gd statusBarView] hasOnlyUntrackedFilesExceptStage] && ![[gd statusBarView] isStagedFilesButtonToggled]) {
		[[diffBarView diffStateView] showNoChanges];
		[diffContentView useTiledBG];
		[diffContentView clearDiffView];
		return;
	}
	
	//-when 1 file is selected show selectors, set default selectors to appropriate values based on the status of the files.
	if(selectedFilesCount == 1) {
		if([selectedGitFile isNoneStatus] || [selectedGitFile isUntrackedFile]) {
			[[diffBarView diffStateView] showNoChanges];
			[diffContentView useTiledBG];
			[diffContentView clearDiffView];
			return;
		}
		if(!hasReturned && [selectedGitFile isStaged]) {
			[diff stagedChanges];
			[[diffBarView diffStateView] showStagedChanges];
			hasReturned=true;
		}
		if(!hasReturned) {
			[diff workingTreeChanges];
			[[diffBarView diffStateView] showWorkingTreeChanges];
		}
	}
	
	//-when two files are selected check if they are the same file but different status, run relevant diff
	if(selectedFilesCount == 2) {
		GTGitFile * file1 = [selectedGitFiles objectAtIndex:0];
		GTGitFile * file2 = [selectedGitFiles objectAtIndex:1];
		if([[file1 filename] isEqual:[file2 filename]]) {
			if([file1 isStaged] || [file2 isStaged]) {
				hasReturned=true;
				[[diffBarView diffStateView] showStageVSWorkingTree];
				[diff stageVSWorkingTree];
			}
		}
	}
	
	BOOL allNoneStatus=false;
	BOOL allStagedStatus=false;
	BOOL allUntrackedStatus=false;
	//BOOL allModifiedStatus=false;
	BOOL allDeletedStatus=false;
	NSInteger noneStatusCount=0;
	NSInteger stagedStatusCount=0;
	NSInteger untrackedFilesCount=0;
	NSInteger modifiedFilesCount=0;
	NSInteger deletedFilesCount=0;
	GTGitFile * gf;
	if(!hasReturned && selectedFilesCount > 1) {
		for(gf in selectedGitFiles) {
			if([gf isNoneStatus]) noneStatusCount++;
			if([gf isUntrackedFile]) untrackedFilesCount++;
			if([gf isModifiedFile]) modifiedFilesCount++;
			if([gf isStaged]) stagedStatusCount++;
			if([gf isDeletedFile]) deletedFilesCount++;
		}
		if(noneStatusCount == [selectedGitFiles count]) allNoneStatus=true;
		if(untrackedFilesCount == [selectedGitFiles count]) allUntrackedStatus=true;
		//if(modifiedFilesCount == [selectedGitFiles count]) allModifiedStatus=true;
		if(stagedStatusCount == [selectedGitFiles count]) allStagedStatus=true;
		if(deletedFilesCount == [selectedGitFiles count]) allDeletedStatus=true;
		if(allNoneStatus) {
			[[diffBarView diffStateView] showNoChanges];
			[diffContentView useTiledBG];
			[diffContentView clearDiffView];
			return;
		}
		if(allUntrackedStatus) {
			[[diffBarView diffStateView] showNoChanges];
			[diffContentView useTiledBG];
			[diffContentView clearDiffView];
			return;
		}
		if(allDeletedStatus) {
			[[diffBarView diffStateView] showNothingToDiff];
			[diffContentView useTiledBG];
			[diffContentView clearDiffView];
			return;
		}
		if(!allStagedStatus || !allUntrackedStatus || !allNoneStatus) {
			[diff workingTreeChanges];
			[[diffBarView diffStateView] showWorkingTreeChanges];
			hasReturned=true;
		}
		if(allStagedStatus) {
			[diff stagedChanges];
			[[diffBarView diffStateView] showStagedChanges];
			hasReturned=true;
		}
	}
	
	//-if no modifications
	if(!hasReturned && ![[gd statusBarView] isDirtyWithStage]) {
		[[diffBarView diffStateView] showNoChanges];
		[diffContentView useTiledBG];
		[diffContentView clearDiffView];
		hasReturned = true;
	}
	
	//-when no files are selected, if staged files are toggled run "git diff --cached"
	if(!hasReturned && selectedFilesCount < 1) {
		if([[gd statusBarView] isStagedFilesButtonToggled] && ![[gd statusBarView] areAnyButtonsToggledExceptStage]) {
			[diff stagedChanges];
			[[diffBarView diffStateView] showStagedChanges];
			hasReturned=true;
		}
	}
	
	//-when no files are selected, run "git diff"
	if(!hasReturned && selectedFilesCount < 1) {
		[diff workingTreeChanges];
		[[diffBarView diffStateView] showWorkingTreeChanges];
	}
	
	if(selectedFilesCount > 0) [diff setFilePaths:selectedFiles];
	
	BOOL allNone=true;
	if(selectedFilesCount < 1 && isSearching) {
		for(gf in selectedGitFiles) {
			if(![gf isNoneStatus]) {
				allNone=false;
				break;
			}
		}
		if(allNone) {
			[[diffBarView diffStateView] showNoChanges];
			[diffContentView useTiledBG];
			[diffContentView clearDiffView];
		}
		else [diff setFilePaths:allFiles];
	}
	[diff setContextValue:[[diffBarView diffStateView] contextValue]];
	[self runDiff];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTDiffView\n");
	#endif
	GDRelease(diff);
	[super dealloc];
}

@end
