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
#import "GTOpCherryPick.h"
#import "GTOpReportCommit.h"
#import "GTGitCommitDetailLoadInfo.h"
#import "GTOpLoadCommitDetails.h"
#import "GTOpFetch.h"
#import "GTOpMergeRemoteBranch.h"
#import "GTOpFetchRemoteBranch.h"
#import "GTCallback.h"
#import "GTOpLoadHistory.h"
#import "GTOpApplyPatch.h"
#import "GTOpReportDiff.h"
#import "GTOpDirectDiff.h"
#import "GTOpDiff.h"
#import "GTOpPrepareDiffing.h"
#import "GTOpCountObjects.h"
#import "GTOpOpenFileMerge.h"
#import "GTOpSubmoduleDelete.h"
#import "GTOpUpdateSubs.h"
#import "GTOpInitializeSubs.h"
#import "GTOpSubmodulePull.h"
#import "GTOpSubmodulePush.h"
#import "GTOpSubmoduleSync.h"
#import "GTOpSubmoduleUpdate.h"
#import "GTOpRebaseFrom.h"
#import "GTOpFindCommitHash.h"
#import "GTOpNewSubmodule.h"
#import "GTOpIgnoreExtension.h"
#import "GTOpTagDeleteAllRemotes.h"
#import "GTOpBranchDeleteAtAllRemotes.h"
#import "GTOpDeleteTagAt.h"
#import "GTOpDeleteBranchAt.h"
#import "GTOpCommitsAhead.h"
#import "GTOpPackObjects.h"
#import "GTOpInitRepo.h"
#import "GTOpErrorEmail.h"
#import "GTBaseOp.h"
#import "GTStatusController.h"
#import "GTOpUpdateActiveBranchView.h"
#import "GTOpGetActiveBranchName.h"
#import "GTOpGetBranchNames.h"
#import "GTOpGetTagNames.h"
#import "GTBaseObject.h"
#import "GTOpGetFiles.h"
#import "GTOpAddFiles.h"
#import "GTOpCommit.h"
#import "GTOpRemove.h"
#import "GTOpDestage.h"
#import "GTOpDiscardChanges.h"
#import "GTOpStatus.h"
#import "GTOpDiffWithHead.h"
#import "GTOpRemoteTrackingBranches.h"
#import "GTOpRemotes.h"
#import "GTOpSavedStashes.h"
#import "GTOpStashApply.h"
#import "GTOpHardReset.h"
#import "GTOpSoftReset.h"
#import "GTOpIgnoreFiles.h"
#import "GTOpCheckout.h"
#import "GTOpStashDelete.h"
#import "GTOpBranchDelete.h"
#import "GTOpTagDelete.h"
#import "GTOpNewEmptyBranch.h"
#import "GTOpNewStash.h"
#import "GTOpStashPop.h"
#import "GTOpNewBranch.h"
#import "GTOpNewTag.h"
#import "GTOpNewRemote.h"
#import "GTOpDeleteRemote.h"
#import "GTOpExportZip.h"
#import "GTOpExportTar.h"
#import "GTOpMetaStatus.h"
#import "GTOpUpdateSourceListView.h"
#import "GTOpMerge.h"
#import "GTOpPushTo.h"
#import "GTOpPullFrom.h"
#import "GTOpSetDefaultRemote.h"
#import "GTOpGetConfigs.h"
#import "GTOpGetGlobalConfigs.h"
#import "GTOpWriteConfig.h"
#import "GTOpGarbageCollect.h"
#import "GTOpAddTrackingBranch.h"
#import "GTOpGetRemoteBranches.h"
#import "GTOpGetRemoteTags.h"
#import "GTOpFetchTag.h"
#import "GTOpPushTagTo.h"
#import "GTOpUnsetConfig.h"
#import "GTOpPackRefs.h"

@class GittyDocument;
@class GTDocumentController;

@interface GTOperationsController : GTBaseObject {
	id showStatusForHistoryLoadMutex;
	BOOL showStatusForHistoryLoad;
	BOOL allCanceled;
	BOOL networkOpsCancelled;
	BOOL isRunningStartup;
	BOOL isRunningRefresh;
	BOOL isRunningMetaRefresh;
	BOOL isRunningAddFiles;
	BOOL isRunningCommit;
	BOOL isRunningRemove;
	BOOL isRunningDestage;
	BOOL isRunningDiscard;
	BOOL isRunningGetConfig;
	GTStatusController * status;
	NSMutableArray * cancelables;
	NSMutableArray * networkCancelables;
}

+ (void) updateLicenseRunStatus:(BOOL) _isRunningWithValidLicense;
- (NSOperationQueue * ) createCancelableQueueWithOperation:(NSOperation *) op;
- (NSOperationQueue * ) createCancelableQueueWithNetworkOperation:(NSOperation *) op;
- (void) removeOpQueueFromCancelables:(NSOperationQueue *) q;
- (void) removeOpQueueFromCancelablesAndNetworkCancelables:(NSOperationQueue *) q;
- (void) releaseAndRemoveQFromCancelables:(NSOperationQueue *) q;
- (void) releaseAndRemoveQFromCancelablesAndNetworkCancelables:(NSOperationQueue *) q;
- (void) runStartupOperation;
- (void) runRefreshOperation;
- (void) runRefreshMetaOperation;
- (void) runRefreshStatusOperation;
- (void) runAddFilesOperation;
- (void) runCommitOperation;
- (void) runCommitOperationWithFiles:(NSArray *)files;
- (void) runRemoveFilesOperation;
- (void) runDestageOperation;
- (void) runDiscardChangesOperation;
- (void) runStashApply:(NSInteger) stashIndex;
- (void) runStashPop:(NSInteger) stashIndex;
- (void) runHardReset;
- (void) runSoftReset;
- (void) runIgnoreFiles:(NSMutableArray *) files;
- (void) runBranchCheckout:(NSString *) branch;
- (void) runStashDelete:(NSInteger) stashIndex;
- (void) runBranchDelete:(NSString *) branchName;
- (void) runTagDelete:(NSString *) tagName;
- (void) runNewEmptyBranch:(NSString *) branchName;
- (void) runNewStash:(NSString *) stashName;
- (void) runNewBranch:(NSString *) branchName fromStartBranch:(NSString *) startBranch checkoutNewBranch:(BOOL) checksOut;
- (void) runNewTag:(NSString *) tagName fromStart:(NSString *) start;
- (void) runNewRemote:(NSString *) _remoteName withURL:(NSString *) _url;
- (void) runDeleteRemote:(NSString *) remoteName;
- (void) runExportZip:(NSString *) path andCommit:(NSString *) commit;
- (void) runExportTar:(NSString *) path andCommit:(NSString *) commit;
- (void) runMergeWithBranch:(NSString *) branchName;
- (void) runPushBranchTo:(NSString *) branch toRemote:(NSString *) remote;
- (void) runPullBranchFrom:(NSString *) branch toRemote:(NSString *) remote;
- (void) runSetDefaultRemote:(NSString *) remote forBranch:(NSString *) branch;
- (void) runWriteConfigForKey:(NSString *) key andValue:(NSString *) value isGlobal:(BOOL) _global;
- (void) runNewTrackingBranchWithLocalBranch:(NSString *) _localBranch andRemoteBranch:(NSString *) _remoteBranch andRemote:(NSString *) _remote;
- (void) runGetRemoteBranchNamesFromRemote:(NSString *) remote;
- (void) runGetRemoteTagNamesFromRemote:(NSString *) remote;
- (void) runFetchTag:(NSString *) tag fromRemote:(NSString *) remote;
- (void) runPushTag:(NSString *) tag toRemote:(NSString *) remote;
- (void) runAggressiveGarbageCollect;
- (void) runUnsetConfigForKey:(NSString *) key isGlobal:(BOOL) _isGlobal;
- (void) runGetConfigs;
- (void) runGetGlobalConfigs;
- (void) runGarbageCollect;
- (void) runPackRefs;
- (void) runSendErrorEmail:(NSString *) error;
- (void) runPackObjects;
- (void) runGetCommitsAhead;
- (void) runDeleteBranch:(NSString *) branch atRemote:(NSString *) remote;
- (void) runDeleteTag:(NSString *) tag atRemote:(NSString *) remote;
- (void) runDeleteBranchAtAllRemotes:(NSString *) branch;
- (void) runDeleteTagAtAllRemotes:(NSString *) tag;
- (void) runIgnoreExtension:(NSString *) ext;
- (void) runNewSubmodule:(NSString *) _submoduleURL inLocalDir:(NSString *) _localDir withName:(NSString *) _submoduleName;
- (void) runRebaseFrom:(NSString *) remote withBranch:(NSString *) branch;
- (void) runGetCommitsAheadWithoutSpinner;
- (void) runSubmoduleUpdateForSubmodule:(NSString *) _submodule;
- (void) runSubmoduleSyncForSubmodule:(NSString *) _submodule;
- (void) runSubmodulePushForSubmodule:(NSString *) _submodule;
- (void) runSubmodulePullForSubmodule:(NSString *) _submodule;
- (void) runSubmoduleUpdateAll;
- (void) runSubmoduleInitAll;
- (void) runDeleteSubmodule:(NSString *) _submodule;
- (void) runOpenFileMergeForFile:(NSString *) _file;
- (void) runGetLooseObjects;
- (void) runPrepareDiffing;
- (void) runDiff;
- (void) runDiffWithDiff:(GTGitDiff *) diff;
- (void) runDiffWithDiff:(GTGitDiff *) _diff andTemplate:(NSString *) _template withCallback:(id) _target action:(SEL) _action;
- (void) runAsyncDiffWithDiff:(GTGitDiff *) _diff andTemplate:(NSString *) _template withCallback:(id) _target action:(SEL) _action;
- (void) runReportDiffWithDiffContent:(NSString *) _diffContent;
- (void) runPatchApplyWithFile:(NSString *) _patchFilePath;
//- (void) runLoadHistoryWithLoadInfo:(GTGitCommitLoadInfo *) _loadInfo andCallback:(GTCallback *) _callback;
- (void) runFetchRemoteBranch:(NSString *) _remoteBranch;
- (void) runMergeRemoteBranch:(NSString *) _remoteBranch;
- (void) runFetch;
- (void) runLoadHistoryWithLoadInfo:(GTGitCommitLoadInfo *) _loadInfo;
- (void) runLoadCommitDetailsWithCommit:(GTGitCommit *) _commit andCommitDetailsTemplate:(NSString *) _template andCommitDetailLoadInfo:(GTGitCommitDetailLoadInfo *) _loadInfo withCallback:(GDCallback *) _callback;
- (void) runReportCommitWithCommitContent:(NSString *) _commitContent;
- (void) runCherryPickCommitWithSHA:(NSString *) _sha withCallback:(GDCallback *) _callback;
- (void) onCherryPickComplete;
- (void) onReportCommitComplete;
- (void) onLoadCommitDetailsComplete:(GDCallback *) _callback;
- (void) onLoadHistoryComplete;
- (void) onFetchComplete;
- (void) onMergeRemoteBranchComplete;
- (void) onFetchRemoteBranchComplete;
- (void) onPatchApplyComplete;
- (void) onReportDiffComplete;
- (void) onDiff2Complete;
- (void) onDiffComplete;
- (void) onPrepareDiffingComplete;
- (void) onGetLooseObjectsComplete;
- (void) onOpenFileMergeComplete;
- (void) onSubmoduleDeleteComplete;
- (void) onSubmoduleInitAllComplete;
- (void) onSubmoduleUpdateAllComplete;
- (void) onSubmodulePullComplete;
- (void) onSubmodulePushComplete;
- (void) onSubmoduleSyncComplete;
- (void) onSubmoduleUpdateComplete;
- (void) onCommitsAheadCompleteWithoutSpinner;
- (void) onRebaseFromComplete;
- (void) onFindCommitIDComplete;
- (void) onNewSubmoduleComplete;
- (void) onIgnoreExtensionComplete;
- (void) onDeleteTagAtAllRemotesComplete;
- (void) onDeleteBranchAtAllRemotesComplete;
- (void) onDeleteTagAtComplete;
- (void) onDeleteBranchAtComplete;
- (void) onCommitsAheadComplete;
- (void) onPackObjectsComplete;
- (void) onInitComplete;
- (void) onSendEmailComplete;
- (void) onPackRefsComplete;
- (void) onGetRemoteTagsComplete;
- (void) onGetRemoteBranchesComplete;
- (void) onNewTrackingBranchComplete;
- (void) onPushTagToComplete;
- (void) onFetchTagComplete;
- (void) onUnsetConfigComplete;
- (void) onGarbageCollectComplete;
- (void) onWriteConfigComplete;
- (void) onGetGlobalConfigsComplete;
- (void) onSetDefaultRemoteComplete;
- (void) onPullFromComplete;
- (void) onPushBranchToComplete;
- (void) onMergeComplete;
- (void) onExportTarComplete;
- (void) onExportZipComplete;
- (void) onDeleteRemoteComplete;
- (void) onNewRemoteComplete;
- (void) onNewTagComplete;
- (void) onNewBranchComplete;
- (void) onTagDeleteComplete;
- (void) onCheckoutComplete;
- (void) onIgnoreFilesComplete;
- (void) onSoftResetComplete;
- (void) onHardResetComplete;
- (void) onStashApplyComplete;
- (void) onStashPopComplete;
- (void) onStartupOperationComplete;
- (void) onRefreshOperationComplete;
- (void) onAddFilesComplete;
- (void) onCommitComplete;
- (void) onRemoveComplete;
- (void) onDestageComplete;
- (void) onDiscardComplete;
- (void) onStashDeleteComplete;
- (void) onBranchDeleteComplete;
- (void) onNewEmptyBranchComplete;
- (void) onNewStashComplete;
- (void) onRefreshMetaComplete;
- (void) onRefreshStatusComplete;
- (void) onGetConfigsComplete;
- (void) cancelNetworkOperations;
- (void) cancelAll;

@end
