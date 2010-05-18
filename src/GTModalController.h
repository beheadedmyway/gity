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
#import "GTNewBranchController.h"
#import "GTBaseObject.h"
#import "GTUnknownErrorController.h"

#define kGTAccessoryViewDeleteAll 8

@class GTDeleteTagAccessoryView;
@class GTDeleteBranchAccessoryView;
@class GTCloneRepoController;
@class GTDontAskCommitsAheadView;
@class GTDontAskToCloseCommitsAheadView;
@class GTRemindQuitFileMerge;
@class GTAlertDeleteAccessoryView;
@class GTCherryPickAccessoryView;

@interface GTModalController : GTBaseObject {
	GTCloneRepoController * cloneRepoController;
	IBOutlet GTDeleteTagAccessoryView * deleteTagView;
	IBOutlet GTDeleteBranchAccessoryView * deleteBranchView;
	IBOutlet GTDontAskCommitsAheadView * dontAskForCommitsAhead;
	IBOutlet GTDontAskToCloseCommitsAheadView * dontAskToCloseForCommitsAhead;
	IBOutlet GTRemindQuitFileMerge * remindQuitFileMerge;
	IBOutlet GTAlertDeleteAccessoryView * looseObjectsReminderView;
	IBOutlet GTCherryPickAccessoryView * cherryPickView;
}

@property (readonly,nonatomic) GTCloneRepoController * cloneRepoController;

+ (GTModalController *) sharedInstance;
- (NSInteger) runCommitsAheadModalWithCount:(NSString *) aheadByCount andRemote:(NSString *) remote andBranch:(NSString *) branch;
- (NSInteger) runCommitsAheadForSingleModalWithCount:(NSString *) aheadByCount andRemote:(NSString *) remote andBranch:(NSString *) branch;
- (NSInteger) runCloseCommitsAheadModalWithCount:(NSString *) aheadByCount andRemote:(NSString *) remote andBranch:(NSString *) branch;
- (NSInteger) runCloseCommitsAheadForSingleModalWithCount:(NSString *) aheadByCount andRemote:(NSString *) remote andBranch:(NSString *) branch;
- (NSUInteger) runWorkingTreeDirty;
- (NSUInteger) runWorkingDirInConflict;
- (NSUInteger) runCantFindGitExecAlert;
- (NSInteger) runMoveToTrashConfirmation;
- (NSInteger) runHardResetConfirmation;
- (NSInteger) runSoftResetConfirmation;
- (NSInteger) runDeleteBranch;
- (NSInteger) runDeleteBranchAt:(NSString *) remote;
- (NSInteger) runDeleteTagAt:(NSString *) remote;
- (NSInteger) runDeleteTag;
- (NSInteger) runDeleteRemote;
- (NSInteger) runStashSavedFromDifferentBranch;
- (NSInteger) runDeleteStash;
- (NSInteger) runDeleteRemoteDoubleCheck;
- (NSInteger) runMergeBranch;
- (NSInteger) verifyGitRemove;
- (NSInteger) verifyGitDiscard;
- (NSInteger) runDeleteSubmodule;
- (NSInteger) runReportDiffBugNotice;
- (NSInteger) runShouldCheckForUpdates;
- (NSInteger) runReportCommitBugNotice;
- (NSUInteger) runCherryPickNotice:(NSString *) _currentBranch;
- (void) runWorkingTreeDirtyForCherry;
- (void) runHasRemoteAlready;
- (void) runCantPushToRemote;
- (void) runCantPushToNewerRemote;
- (void) runBranchDoesntPointToCommit;
- (void) runCantFindTextmateBinary;
- (void) runInstalledTMBundle;
- (void) runHostVerificationFailed;
- (void) runPermissionDeniedForClone;
- (void) runCloneDestinationNotDirectory;
- (void) runCloneDestinationNotExist;
- (void) runSavedLicenseInvalid;
- (void) runDocumentExpired;
- (void) runLooseObjectCountReminder;
- (void) runRemindQuitFileMerge;
- (void) runSubmoduleDestinationIncorrect;
- (void) runDirIsDirtyForRebase;
- (void) runCloneTimedOut;
- (void) runConfigNeedsSectionError;
- (void) cloneRepo;
- (void) runConflictedStateForCheckout;
- (void) runModalForError:(NSString *) errorMessage;
- (void) runModalFromCode:(NSInteger) code;
- (void) runRemoteEndHungUp;
- (void) runNoDefaultRemote;
- (void) runDirIsDirtyForEmptyBranch;
- (void) runNotAGitRepoAlert;
- (void) runAlreadyAGitRepoAlert;
- (void) runDirIsDirtyForCheckout;
- (void) runStageAllChangesBeforeContinueing;
- (void) runServerUnreachable;
- (void) runCantFindFileMerge;

@end
