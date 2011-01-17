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
#import "defs.h"
#import "GTScale9Control.h"
#import "GTBaseObject.h"

@class GittyDocument;
@class GTDocumentController;
@class GTSplitContentView;
@class GTSourceListView;
@class GTDiffView;
@class GTDiffBarDiffStateView;
@class GTActiveBranchView;

@interface GTContextMenuController : GTBaseObject <NSMenuDelegate> {
	
	GTSplitContentView * splitContentView;
	GTSourceListView * sourceListView;
	GTDiffView * diffView;
	GTDiffBarDiffStateView * diffStateView;
	GTActiveBranchView * activeBranchView;
	
	//active branch view context menu
	NSMenu * activeBranchActionsMenu;
	NSMenuItem * gitAddItem;
	NSMenuItem * gitAddAndCommitItem;
	NSMenuItem * gitDestageItem;
	NSMenuItem * gitDiscardChangesItem;
	NSMenuItem * gitRemoveItem;
	NSMenuItem * gitMergeTool;
	NSMenuItem * gitIgnoreItem;
	NSMenuItem * gitIgnoreContainer;
	NSMenuItem * gitIgnoreExension;
	NSMenuItem * openFile;
	NSMenuItem * quickLook;
	NSMenuItem * openInFinder;
	NSMenuItem * openContainerInFinder;
	NSMenuItem * moveToTrash;
	
	//source list "branch item" context menu
	NSMenu * branchActionsMenu;
	NSMenu * pushToMenu;
	NSMenu * pullFromMenu;
	NSMenu * defaultRemoteMenu;
	NSMenu * branchDeleteAtMenu;
	NSMenuItem * pushItem;
	NSMenuItem * pullItem;
	NSMenuItem * rebasePull;
	NSMenuItem * pullItemAlternate;
	NSMenuItem * pushTo;
	NSMenuItem * pullFrom;
	NSMenuItem * branchDelete;
	NSMenuItem * branchRename;
	NSMenuItem * branchCheckout;
	NSMenuItem * branchMerge;
	NSMenuItem * branchNewBranchFromThis;
	NSMenuItem * branchTagFromHead;
	NSMenuItem * branchExportZip;
	NSMenuItem * branchExportTar;
	NSMenuItem * defaultRemote;
	NSMenuItem * branchDeleteAtItem;
	NSMenuItem * branchHistoryItem;
	NSMenuItem * terminalItem;
	
	//source list "stash item" menu
	NSMenu * stashMenu;
	NSMenuItem * stashPop;
	NSMenuItem * stashDrop;
	NSMenuItem * stashApply;
	
	//source list "submodules item" menu
	NSMenu * submodulesMenu;
	NSMenuItem * subsUpdate;
	NSMenuItem * subsSync;
	NSMenuItem * subsPush;
	NSMenuItem * subsPull;
	NSMenuItem * subsOpenWithGitty;
	NSMenuItem * subsDelete;
	
	//source list "remotes item" menu
	NSMenu * remotesMenu;
	NSMenuItem * remotesDelete;
	
	//source list "remote branches" menu
	NSMenu * remoteBranchesMenu;
	NSMenuItem * rbFetchItem;
	NSMenuItem * rbMergeItem;
	NSMenuItem * rbHistoryItem;
	
	//source list "tags item" menu
	NSMenu * tagsMenu;
	NSMenu * tagsPushToMenu;
	NSMenu * tagsDeleteAtMenu;
	NSMenuItem * tagsDelete;
	NSMenuItem * exportZip;
	NSMenuItem * exportTar;
	NSMenuItem * tagsPush;
	NSMenuItem * tagsDeleteAtItem;
	NSMenuItem * tagHistoryItem;
	
	//source list "repo" actions menu
	NSMenu * actionsMenu;
	NSMenuItem * branchReset;
	NSMenuItem * branchDiscardNonStagedChanges;
	NSMenuItem * newRemoteActionsItem;
	NSMenuItem * newStash;
	NSMenuItem * newBranch;
	NSMenuItem * newBranchFrom;
	NSMenuItem * newTag;
	NSMenuItem * newTagFrom;
	NSMenuItem * newEmptyBranch;
	NSMenuItem * exportArchiveCommit;
	NSMenuItem * newBranchFromCommit;
	NSMenuItem * newTagFromCommit;
	NSMenuItem * newTrackingBranch;
	NSMenuItem * fetchTags;
	NSMenuItem * newSubmodule;
	
	//left selector context menu
	NSMenu * leftDiffSelectorMenu;
	NSMenuItem * leftDiffHEAD;
	NSMenuItem * leftDiffPWD;
	NSMenuItem * leftDiffStage;
	NSMenuItem * leftDiffCommit;
	
	NSMenu * rightDiffSelectorMenu;
	NSMenuItem * rightDiffHEAD;
	NSMenuItem * rightDiffPWD;
	NSMenuItem * rightDiffStage;
	NSMenuItem * rightDiffCommit;
	
	NSMenu * historyActionsMenu;
	NSMenuItem * checkoutCommit;
}

@property (readonly,nonatomic) NSMenu * actionsMenu;
@property (readonly,nonatomic) NSMenu * activeBranchActionsMenu;
@property (readonly,nonatomic) NSMenu * branchActionsMenu;
@property (readonly,nonatomic) NSMenu * remotesMenu;
@property (readonly,nonatomic) NSMenu * stashMenu;
@property (readonly,nonatomic) NSMenu * tagsMenu;
@property (readonly,nonatomic) NSMenu * submodulesMenu;
@property (readonly,nonatomic) NSMenu * leftDiffSelectorMenu;
@property (readonly,nonatomic) NSMenu * rightDiffSelectorMenu;
@property (readonly,nonatomic) NSMenu * remoteBranchesMenu;
@property (readonly,nonatomic) NSMenu * historyActionsMenu;

- (void) updateActionsMenuDelegate;
- (void) invalidate;
- (void) invalidateActiveBranchViewMenus;
- (void) invalidateBranchesSourceListMenus;
- (void) invalidateSourceListActionsMenu;
- (void) disablePushAndPull;
- (void) enablePushAndPull;
- (void) enableDeleteAt;
- (void) disableDeleteAt;
- (void) initActiveBranchMenuItems;
- (void) invalidateTagsSourceListMenu;
- (void) initSubmodulesMenu;
- (void) initSubmodulesMenuItems;
- (void) initRemoteBranchesMenu;
- (void) initRemoteBranchesItems;
- (void) initActiveBranchMenu;
- (void) initBranchActionsMenu;
- (void) initBranchActionItems;
- (void) initStashMenu;
- (void) initStashItems;
- (void) initRemotesMenu;
- (void) initRemotesItems;
- (void) initTagsMenu;
- (void) initTagsItems;
- (void) initActionsMenu;
- (void) initActionsMenuItems;
- (void) initLeftDiffSelectorMenu;
- (void) initLeftDiffSelectorMenuItems;
- (void) invalidateLeftDiffSelector;
- (void) initRightDiffSelectorMenu;
- (void) initRightDiffSelectorMenuItems;
- (void) invalidateRightDiffSelectorMenu;
- (void) initHistoryActionsMenu;
- (void) initHistoryActionsItems;
- (NSMenu *) branchActionsMenu;

@end
