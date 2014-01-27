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

#import <Cocoa/Cocoa.h>
#import <GDKit/GDKit.h>
#import "LNSSourceListView.h"
#import "GTGittyView.h"
#import "GTSourceListItem.h"
#import "GTSourceListMenuView.h"
#import "GTImageView.h"
#import "GTModalController.h"
#import "GTSplitContentView.h"

@interface GTSourceListView : GTGittyView <NSOutlineViewDelegate,NSOutlineViewDataSource,NSMenuDelegate> {
	BOOL wasJustUpdated;
	BOOL missingDefaultsExpandState;
	BOOL wasBranchesExpanded;
	BOOL wasTagsExpanded;
	BOOL wasStashExpanded;
	BOOL wasSubmodulesExpanded;
	BOOL wasRemotesExpanded;
	BOOL wasRemoteBranchesExpanded;
	NSMutableArray * branches;
	NSSavePanel * savePanel;
	NSImage * versionTag;
	NSView * leftView;
	NSString * gitProjectPath;
	IBOutlet NSScrollView * scrollView;
	IBOutlet LNSSourceListView * sourceListView;
	IBOutlet GTSourceListMenuView * sourceListMenuView;
	GTSourceListItem * rootItem;
	GTSourceListItem * tagsItem;
	GTSourceListItem * branchesItem;
	GTSourceListItem * remotesItem;
	GTSourceListItem * stashItem;
	GTSourceListItem * subsItem;
	GTSourceListItem * remoteBranchesItem;
	GTSourceListItem * _tmpItemForExport;
	GTSplitContentView * splitContentView;
}

@property (strong,nonatomic) IBOutlet NSScrollView * scrollView;
@property (strong,nonatomic) IBOutlet LNSSourceListView * sourceListView;
@property (strong,nonatomic) IBOutlet GTSourceListMenuView * sourceListMenuView;
@property (readonly)  BOOL wasJustUpdated;

@property (readonly) GTSourceListItem * rootItem;
@property (readonly) GTSourceListItem * tagsItem;
@property (readonly) GTSourceListItem * branchesItem;
@property (readonly) GTSourceListItem * remotesItem;

- (void) branchCheckout:(id) sender;
- (void) branchMerge:(id) sender;
- (void) branchPushTo:(id) sender;
- (void) branchPullFrom:(id) sender;
- (void) branchDelete:(id) sender;
- (void) branchRename:(id) sender;
- (void) branchNewBranchFromHere:(id) sender;
- (void) branchNewTag:(id) sender;
- (void) branchHardReset:(id) sender;
- (void) branchDiscardNonStagedChanges:(id) sender;
- (void) gitPush:(id) sender;
- (void) gitPushFromActiveBranch;
- (void) gitPullFromActiveBranch;
- (void) gitPull:(id) sender;
- (void) gitExportZip;
- (void) gitExportTar;
- (void) gitPushTo:(id) sender;
- (void) gitPullFrom:(id) sender;
- (void) gitRebaseFrom:(id) sender;
- (void) gitRebaseFromActiveBranch;
- (void) gitSubmoduleUpdate:(id) sender;
- (void) gitSubmoduleSync:(id) sender;
- (void) gitSubmodulePush:(id) sender;
- (void) gitDeleteSub:(id) sender;
- (void) openSubmoduleWithGity:(id) sender;
- (void) remoteDelete:(id) sender;
- (void) remoteBranchMerge:(id) sender;
- (void) remoteBranchFetch:(id) sender;
- (void) saveSizeToDefaults;
- (void) stashApply:(id) sender;
- (void) stashPop:(id) sender;
- (void) stashDelete:(id) sender;
- (void) update;
- (void) updateDefaultRemote:(id) sender;
- (void) persistViewState;
- (void) loadHistoryFromRef:(id) sender;
- (void) showActionsMenu;
- (void) removeObservers;
- (void) selectActiveBranch;
- (BOOL) isSelectedItemActiveBranch;
- (BOOL) isScrollBarShown;
- (NSString *) getWidthKey;
- (NSString *) selectedItemName;
- (NSString *) selectedItemLowercaseName;
- (GTSourceListItem *) selectedItem;

@end
