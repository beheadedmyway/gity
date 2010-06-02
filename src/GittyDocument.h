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
#import "defs.h"
#import "GTCallback.h"
#import "GTHistorySearchFilteredView.h"
#import "GTHistorySearchController.h"
#import "GDNSString+Additions.h"
#import "GTWindow.h"
#import "GTModalController.h"
#import "GTStateBarView.h"
#import "GTStatusBarView.h"
#import "GTGitCommandExecutor.h"
#import "GTActiveBranchView.h"
#import "GTStatusController.h"
#import "GTOperationsController.h"
#import "GTContextMenuController.h"
#import "GTCustomTitleController.h"
#import "GTMainMenuHelper.h"
#import "GTGitDataStore.h"
#import "GTCommitMessageController.h"
#import "GTSourceListView.h"
#import "GTSplitContentView.h"
#import "GTSingleInputController.h"
#import "GTNewRemoteController.h"
#import "GTConfigView.h"
#import "GTNuRemoteTrackBranch.h"
#import "GTRemoteView.h"
#import "GTFetchTagsController.h"
#import "GTSoundController.h"
#import "GTNewSubmoduleController.h"
#import "GTContentHSplitView.h"
#import "GTDiffView.h"
#import "GTHistoryView.h"
#import "GTHistoryDetailsContainerView.h"
#import "GTAdvancedDiffView.h"
#import "SCEvents.h"
#import "SCEventListenerProtocol.h"

@interface GittyDocument : NSDocument <NSWindowDelegate, SCEventListenerProtocol> {
	BOOL isSourceListHidden;
	BOOL commitAfterAdd;
	BOOL fixingConflict;
	BOOL isSearching;
	BOOL isTerminatingFromSessionExpired;
	BOOL justLaunched;
	BOOL runningExpiredModal;
	NSString * _tmpBranchStartName;
	NSString * _tmpTagStartPoint;
	NSString * _tmpUnknownError;
	NSView * topSplitView;
	NSView * bottomSplitView;
	NSView * rightView;
	IBOutlet GTWindow * gtwindow;
	IBOutlet GTStateBarView * stateBarView;
	IBOutlet GTStatusBarView * statusBarView;
	IBOutlet GTActiveBranchView * activeBranchView;
	IBOutlet GTSourceListView * sourceListView;
	IBOutlet GTSplitContentView * splitContentView;
	IBOutlet GTConfigView * configView;
	IBOutlet GTRemoteView * remoteView;
	IBOutlet GTContentHSplitView * contentHSplitView;
	IBOutlet GTDiffView * diffView;
	IBOutlet GTHistoryView * historyView;
	IBOutlet GTHistoryDetailsContainerView * historyDetailsContainerView;
	IBOutlet GTHistorySearchFilteredView * historyFilteredView;
	IBOutlet GTNuRemoteTrackBranch * newTrackBranch;
	IBOutlet GTFetchTagsController * fetchTags;
	IBOutlet GTStatusController * status;
	IBOutlet GTCommitMessageController * commit;
	IBOutlet GTUnknownErrorController * unknownError;
	IBOutlet GTSingleInputController * singleInput;
	IBOutlet GTNewRemoteController * newRemote;
	IBOutlet GTCustomTitleController * customWindowTitleController;
	IBOutlet GTNewSubmoduleController * newSubmodule;
	IBOutlet GTHistorySearchController * historySearch;
	IBOutlet GTAdvancedDiffView * advancedDiffView;
	GTGitDataStore * gitd;
	GTMainMenuHelper * mainMenuHelper;
	GTGitCommandExecutor * git;
	GTSoundController * sounds;
	GTOperationsController * operations;
	GTContextMenuController * contextMenus;
	SCEvents * fileEvents;
}

#pragma mark properties
@property (readonly,nonatomic) BOOL isSearching;
@property (readonly,nonatomic) BOOL commitAfterAdd;
@property (readonly,nonatomic) BOOL isSourceListHidden;
@property (readonly,nonatomic) IBOutlet GTWindow * gtwindow;
@property (readonly,nonatomic) IBOutlet GTActiveBranchView * activeBranchView;
@property (readonly,nonatomic) IBOutlet GTCustomTitleController * customWindowTitleController;
@property (readonly,nonatomic) IBOutlet GTSourceListView * sourceListView;
@property (readonly,nonatomic) IBOutlet GTSplitContentView * splitContentView;
@property (readonly,nonatomic) IBOutlet GTHistoryView * historyView;
@property (readonly,nonatomic) IBOutlet GTHistoryDetailsContainerView * historyDetailsContainerView;
@property (readonly,nonatomic) IBOutlet GTHistorySearchFilteredView * historyFilteredView;
@property (readonly,nonatomic) IBOutlet GTAdvancedDiffView * advancedDiffView;
@property (readonly,nonatomic) GTStateBarView * stateBarView;
@property (readonly,nonatomic) GTConfigView * configView;
@property (readonly,nonatomic) GTStatusBarView * statusBarView;
@property (readonly,nonatomic) GTRemoteView * remoteView;
@property (readonly,nonatomic) GTDiffView * diffView;
@property (readonly,nonatomic) GTFetchTagsController * fetchTags;
@property (readonly,nonatomic) GTGitCommandExecutor * git;
@property (readonly,nonatomic) GTStatusController * status;
@property (readonly,nonatomic) GTSingleInputController * singleInput;
@property (readonly,nonatomic) GTNewRemoteController * newRemote;
@property (readonly,nonatomic) GTUnknownErrorController * unknownError;
@property (readonly,nonatomic) GTOperationsController * operations;
@property (readonly,nonatomic) GTContextMenuController * contextMenus;
@property (readonly,nonatomic) GTMainMenuHelper * mainMenuHelper;
@property (readonly,nonatomic) GTGitDataStore * gitd;
@property (readonly,nonatomic) GTCommitMessageController * commit;
@property (readonly,nonatomic) GTNuRemoteTrackBranch * newTrackBranch;
@property (readonly,nonatomic) GTSoundController * sounds;
@property (readonly,nonatomic) GTNewSubmoduleController * newSubmodule;

- (id) init;
- (void) adjustMinWindowSize;
- (void) applicationWillBecomeActive;
- (void) clearSearch;
- (void) clearSearchField;
- (void) clearSearchHistory:(id) sender;
- (void) commitDetails:(id) sender;
- (void) commitTree:(id) sender;
- (void) expireSession;
- (void) focusOnSearch:(id) sender;
- (void) gitApplyPatch:(id) sender;
- (void) gitNewBranchFromActiveBranch:(id) sender;
- (void) gitNewTagFromActiveBranch:(id) sender;
- (void) gitNewRemote:(id) sender;
- (void) gitGarbageCollect:(id) sender;
- (void) gitAggresiveGarbageCollect:(id) sender;
- (void) gitAdd:(id) sender;
- (void) gitCommit:(id) sender;
- (void) gitDestage:(id) sender;
- (void) gitPushFromMenu:(id) sender;
- (void) gitPullFromMenu:(id) sender;
- (void) gitNewEmptyBranch:(id) sender;
- (void) gitRemove:(id) sender;
- (void) gitStashLocalChanges:(id) sender;
- (void) gitIgnore:(id) sender;
- (void) gitDiscardChanges:(id) sender;
- (void) gitCheckout:(NSString *) branch;
- (void) gitNewBranch:(NSString *) startBranch;
- (void) gitNewTag:(NSString *) startPoint;
- (void) gitFetchTags:(id) sender;
- (void) gitPackRefs:(id) sender;
- (void) gitPackObjects:(id) sender;
- (void) gitSoftReset:(id) sender;
- (void) gitHardReset:(id) sender;
- (void) gitNewSubmodule:(id) sender;
- (void) gitRebaseFromMenu:(id) sender;
- (void) gitAddAndCommit:(id) sender;
- (void) gitFetch:(id) sender;
- (void) gitUpdateAllSubmodules:(id) sender;
- (void) gitInitializeAllSubmodules:(id) sender;
- (void) hideSourceList;
- (void) initNotifications;
- (void) lessContext:(id) sender;
- (void) moveToTrash:(id) sender;
- (void) moreContext:(id) sender;
- (void) newRemoteTrackingBranch:(id) sender;
- (void) openProjectInTextmate:(id) sender;
- (void) onStartupOperationComplete;
- (void) onRefreshOperationComplete;
- (void) onRefreshMetaOperationComplete;
- (void) onGitAddComplete;
- (void) onGetConfigsComplete;
- (void) onGetGlobalConfigsComplete;
- (void) onGotRemoteBranches;
- (void) onGotRemoteTags;
- (void) onGotLooseObjectsCount;
- (void) onStatusBarFilesToggled;
- (void) onSearch;
- (void) onActiveBranchViewSelectionChange;
- (void) onHistoryViewSelectionChange;
- (void) onHistoryLoaded;
- (void) onHistorySearch;
- (void) onClearSearch;
- (void) openInFinder:(id) sender;
- (void) openContainingFolder:(id) sender;
- (void) persistWindowState;
- (void) reload:(id) sender;
- (void) resolveConflictsWithFileMerge:(id) sender;
- (void) runStartupOperation;
- (void) search:(NSString *) term;
- (void) showRemoteViewForRemote:(NSString *) remote;
- (void) showDifferView:(id) sender;
- (void) showActiveBranch:(id)sender;
- (void) showActiveBranchWithDiffUpdate:(BOOL) _invalidateDiffView forceIfAlreadyActive:(BOOL) _force;
- (void) showConfig:(id) sender;
- (void) showGlobalConfig:(id) sender;
- (void) showHistory:(id) sender;
- (void) showHistoryFromRef:(NSString *) _refName;
- (void) showSourceList;
- (void) searchHistory:(id) sender;
- (void) toggleAllFiles:(id) sender;
- (void) toggleSourceList:(id) sender;
- (void) toggleStagedFiles:(id) sender;
- (void) toggleConflictedFiles:(id) sender;
- (void) toggleUntrackedFiles:(id) sender;
- (void) toggleModifiedFiles:(id) sender;
- (void) toggleDeletedFiles:(id) sender;
- (void) tryToShowUnknownError;
- (void) unknownErrorFromOperation:(NSString *) error;
- (void) updateAfterWindowBecameActive;
- (void) waitForWindow;
- (void) windowReady;
- (BOOL) isCurrentViewActiveBranchView;
- (BOOL) isCurrentViewConfigView;
- (BOOL) isCurrentViewRemoteView;
- (BOOL) isThisDocumentForURL:(NSURL *) proposedURL;
- (BOOL) isCurrentViewHistoryView;
- (NSInteger) shouldQuitNow;
- (NSInteger) shouldCloseNow;
- (GTModalController *) modals;

@end
