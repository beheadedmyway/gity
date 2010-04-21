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
#import "GTGittyView.h"
#import "GTScale3Control.h"
#import "GTSolidColorView.h"
#import "GTSplitContentView.h"
#import "GTStateBarView.h"
#import "GTStyles.h"

@class GittyDocument;
@class GTDocumentController;

@interface GTStatusBarView : GTGittyView {
	BOOL hasRendered;
	BOOL deletedFilesStatus;
	BOOL untrackedFilesStatus;
	BOOL stagedFilesStatus;
	BOOL modifiedFilesStatus;
	BOOL conflictedFilesStatus;
	NSInteger deletedFilesCount;
	NSInteger untrackedFilesCount;
	NSInteger modifiedFilesCount;
	NSInteger stagedFilesCount;
	NSInteger unmergedFilesCount;
	NSAttributedString * deletedFilesLabel;
	NSAttributedString * untrackedFilesLabel;
	NSAttributedString * stagedFilesLabel;
	NSAttributedString * modifiedFilesLabel;
	NSAttributedString * conflictedFilesLabel;
	GTScale3Control * deletedFiles;
	GTScale3Control * untrackedFiles;
	GTScale3Control * stagedFiles;
	GTScale3Control * modifiedFiles;
	GTScale3Control * lastButton;
	GTScale3Control * conflictedFiles;
	GTSplitContentView * splitContentView;
	GTStateBarView * stateBarView;
}

- (void) update;
- (void) updateAfterViewChange;
- (void) updateButtonLabels;
- (void) updateLabelForButton:(GTScale3Control *) button newLabel:(NSAttributedString *) label;
- (void) updateButton:(GTScale3Control *) button toNewX:(float) x;
- (void) updateConflictedLabelForButton:(GTScale3Control *) button newLabel:(NSAttributedString *) label;
- (void) invalidateLabels;
- (void) invalidateCounts;
- (void) invalidateSelfFrame;
- (void) invalidateAllButtons;
- (void) invalidateConflictedFilesButton;
- (void) invalidateDeleteFilesButton;
- (void) invalidateUntrackedFilesButton;
- (void) invalidateStagedFilesButton;
- (void) invalidateModifiedFilesButton;
- (void) initDeletedFilesButton;
- (void) initConflictedFilesButton;
- (void) initUntrackedFilesButton;
- (void) initStagedFilesButton;
- (void) initModifiedFilesButton;
- (void) setButtonTargetAndAction:(GTScale3Control *) button;
- (void) toggleAllFiles;
- (void) toggleStagedFiles;
- (void) toggleUntrackedFiles;
- (void) toggleModifiedFiles;
- (void) toggleDeletedFiles;
- (void) toggleConflictedFiles;
- (void) toggleFilesStatus:(id) sender;
- (BOOL) isDirty;
- (BOOL) isDirtyWithStage;
- (BOOL) isOnlyUntrackedFilesButtonToggled;
- (BOOL) isStagedFilesButtonToggled;
- (BOOL) areAnyButtonsToggledExceptStage;
- (BOOL) hasOnlyUntrackedFilesExceptStage;
- (BOOL) shouldShowUntrackedFiles;
- (BOOL) shouldShowConflictedFiles;
- (BOOL) shouldShowModifiedFiles;
- (BOOL) shouldShowDeletedFiles;
- (BOOL) shouldShowAnyFilesExceptStaged;
- (BOOL) shouldShowStagedFiles;
- (float) getTotalButtonWidth;
- (NSRect) updateButtonRectPositionForRightAlign:(GTScale3Control *) button;
- (NSRect) updateButtonRectPositionForLeftAlign:(GTScale3Control *) button;

@end
