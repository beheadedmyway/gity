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
#import <QuickLook/QuickLook.h>
#import <Quartz/Quartz.h>
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
#import "Terminal.h"

@class GTActiveBranchTableView;

@interface GittyDocument : NSDocument <NSWindowDelegate, SCEventListenerProtocol, QLPreviewPanelDataSource> {
	BOOL isSourceListHidden;
	BOOL commitAfterAdd;
	BOOL fixingConflict;
	BOOL isSearching;
	BOOL isTerminatingFromSessionExpired;
	BOOL justLaunched;
	BOOL runningExpiredModal;
	BOOL needsFileUpdates;
	NSString *_tmpBranchStartName;
	NSString *_tmpTagStartPoint;
	NSString *_tmpUnknownError;
	NSView *topSplitView;
	NSView *bottomSplitView;
	NSView *rightView;
	IBOutlet GTWindow *__weak gtwindow;
	IBOutlet GTStateBarView *__weak stateBarView;
	IBOutlet GTStatusBarView *__weak statusBarView;
	IBOutlet GTActiveBranchView *__weak activeBranchView;
	IBOutlet GTSourceListView *__weak sourceListView;
	IBOutlet GTSplitContentView *__weak splitContentView;
	IBOutlet GTConfigView *__weak configView;
	IBOutlet GTRemoteView *__weak remoteView;
	IBOutlet GTContentHSplitView *contentHSplitView;
	IBOutlet GTDiffView *__weak diffView;
	IBOutlet GTHistoryView *__weak historyView;
	IBOutlet GTHistoryDetailsContainerView *__weak historyDetailsContainerView;
	IBOutlet GTHistorySearchFilteredView *__weak historyFilteredView;
	IBOutlet GTNuRemoteTrackBranch *__weak trackBranchController;
	IBOutlet GTFetchTagsController *__weak fetchTags;
	IBOutlet GTStatusController *__weak status;
	IBOutlet GTCommitMessageController *__weak commit;
	IBOutlet GTUnknownErrorController *__weak unknownError;
	IBOutlet GTSingleInputController *__weak singleInput;
	IBOutlet GTNewRemoteController *__weak remoteController;
	IBOutlet GTNewSubmoduleController *__weak submoduleController;
	IBOutlet GTHistorySearchController *historySearch;
	IBOutlet GTAdvancedDiffView *__weak advancedDiffView;
	IBOutlet NSToolbar *toolbar;
	GTGitDataStore *gitd;
	GTMainMenuHelper *mainMenuHelper;
	GTGitCommandExecutor *git;
	GTSoundController *__weak sounds;
	GTOperationsController *operations;
	GTContextMenuController *contextMenus;
#warning fileEvents is never set!
	SCEvents *fileEvents;
}

#pragma mark properties

@property (readonly,nonatomic) BOOL isSearching;
@property (readonly,nonatomic) BOOL commitAfterAdd;
@property (readonly,nonatomic) BOOL isSourceListHidden;
@property (weak, readonly,nonatomic) IBOutlet GTWindow *gtwindow;
@property (weak, readonly,nonatomic) IBOutlet GTActiveBranchView *activeBranchView;
@property (weak, readonly,nonatomic) IBOutlet GTSourceListView *sourceListView;
@property (weak, readonly,nonatomic) IBOutlet GTSplitContentView *splitContentView;
@property (weak, readonly,nonatomic) IBOutlet GTHistoryView *historyView;
@property (weak, readonly,nonatomic) IBOutlet GTHistoryDetailsContainerView *historyDetailsContainerView;
@property (weak, readonly,nonatomic) IBOutlet GTHistorySearchFilteredView *historyFilteredView;
@property (weak, readonly,nonatomic) IBOutlet GTAdvancedDiffView *advancedDiffView;
@property (weak, readonly,nonatomic) GTStateBarView *stateBarView;
@property (weak, readonly,nonatomic) GTConfigView *configView;
@property (weak, readonly,nonatomic) GTStatusBarView *statusBarView;
@property (weak, readonly,nonatomic) GTRemoteView *remoteView;
@property (weak, readonly,nonatomic) GTDiffView *diffView;
@property (weak, readonly,nonatomic) GTFetchTagsController *fetchTags;
@property (readonly,nonatomic) GTGitCommandExecutor *git;
@property (weak, readonly,nonatomic) GTStatusController *status;
@property (weak, readonly,nonatomic) GTSingleInputController *singleInput;
@property (weak, readonly,nonatomic) GTNewRemoteController *remoteController;
@property (weak, readonly,nonatomic) GTUnknownErrorController *unknownError;
@property (readonly,nonatomic) GTOperationsController *operations;
@property (readonly,nonatomic) GTContextMenuController *contextMenus;
@property (readonly,nonatomic) GTMainMenuHelper *mainMenuHelper;
@property (readonly,nonatomic) GTGitDataStore *gitd;
@property (weak, readonly,nonatomic) GTCommitMessageController *commit;
@property (weak, readonly,nonatomic) GTNuRemoteTrackBranch *trackBranchController;
@property (weak, readonly,nonatomic) GTSoundController *sounds;
@property (weak, readonly,nonatomic) GTNewSubmoduleController *submoduleController;

- (id) init;
- (void) adjustMinWindowSize;
- (void) applicationWillBecomeActive;
- (void) clearSearch;
- (void) clearSearchField;
- (IBAction) clearSearchHistory:(id) sender;
- (IBAction) commitDetails:(id) sender;
- (IBAction) commitTree:(id) sender;
- (void) expireSession;
- (IBAction) focusOnSearch:(id) sender;
- (IBAction) gitApplyPatch:(id) sender;
- (IBAction) gitNewBranchFromActiveBranch:(id) sender;
- (IBAction) gitNewTagFromActiveBranch:(id) sender;
- (IBAction) gitNewRemote:(id) sender;
- (IBAction) gitGarbageCollect:(id) sender;
- (IBAction) gitAggresiveGarbageCollect:(id) sender;
- (IBAction) gitAdd:(id) sender;
- (IBAction) gitCommit:(id) sender;
- (IBAction) gitDestage:(id) sender;
- (IBAction) gitPushFromMenu:(id) sender;
- (IBAction) gitPullFromMenu:(id) sender;
- (IBAction) gitNewEmptyBranch:(id) sender;
- (IBAction) gitRemove:(id) sender;
- (IBAction) gitStashLocalChanges:(id) sender;
- (IBAction) gitIgnore:(id) sender;
- (IBAction) gitDiscardChanges:(id) sender;
- (void) gitCheckout:(NSString *) branch;
- (void) gitNewBranch:(NSString *) startBranch;
- (void) gitNewTag:(NSString *) startPoint;
- (IBAction) gitFetchTags:(id) sender;
- (IBAction) gitPackRefs:(id) sender;
- (IBAction) gitPackObjects:(id) sender;
- (IBAction) gitSoftReset:(id) sender;
- (IBAction) gitHardReset:(id) sender;
- (IBAction) gitNewSubmodule:(id) sender;
- (IBAction) gitRebaseFromMenu:(id) sender;
- (IBAction) gitAddAndCommit:(id) sender;
- (IBAction) gitFetch:(id) sender;
- (IBAction) gitUpdateAllSubmodules:(id) sender;
- (IBAction) gitInitializeAllSubmodules:(id) sender;
- (void) hideSourceList;
- (void) initNotifications;
- (IBAction) lessContext:(id) sender;
- (IBAction) moveToTrash:(id) sender;
- (IBAction) moreContext:(id) sender;
- (IBAction) newRemoteTrackingBranch:(id) sender;
- (IBAction) openProjectInTextmate:(id) sender;
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
- (IBAction) openFile:(id) sender;
- (IBAction) quickLook:(id) sender;
- (IBAction) openInFinder:(id) sender;
- (IBAction) openContainingFolder:(id) sender;
- (IBAction) openInTerminal:(id)sender;
- (IBAction) reload:(id) sender;
- (IBAction) resolveConflictsWithFileMerge:(id) sender;
- (void) runStartupOperation;
- (void) search:(NSString *) term;
- (void) showRemoteViewForRemote:(NSString *) remote;
- (IBAction) showDifferView:(id) sender;
- (IBAction) showActiveBranch:(id)sender;
- (void) showActiveBranchWithDiffUpdate:(BOOL) _invalidateDiffView forceIfAlreadyActive:(BOOL) _force;
- (IBAction) showConfig:(id) sender;
- (IBAction) showGlobalConfig:(id) sender;
- (IBAction) showHistory:(id) sender;
- (void) showHistoryFromRef:(NSString *) _refName;
- (void) showSourceList;
- (IBAction) searchHistory:(id) sender;
- (IBAction) toggleAllFiles:(id) sender;
- (IBAction) toggleSourceList:(id) sender;
- (IBAction) toggleStagedFiles:(id) sender;
- (IBAction) toggleConflictedFiles:(id) sender;
- (IBAction) toggleUntrackedFiles:(id) sender;
- (IBAction) toggleModifiedFiles:(id) sender;
- (IBAction) toggleDeletedFiles:(id) sender;
- (void) tryToShowUnknownError;
- (void) unknownErrorFromOperation:(NSString *) error;
- (IBAction) updateAfterFilesChanged:(id)sender;
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
