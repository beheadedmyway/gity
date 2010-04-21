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
#import <BWToolkitFramework/BWToolkitFramework.h>
#import "GTGittyView.h"
#import "GTStyles.h"
#import "GTInsetLabelView.h"
#import "GTImageView.h"
#import "GTViewLayoutHelper.h"
#import "GTGitDiff.h"
#import "GTScale9Control.h"

@class GTDiffView;

@interface GTDiffBarDiffStateView : GTGittyView <NSMenuDelegate> {
	BOOL updatedContextSlider;
	IBOutlet BWTexturedSlider * contextSlider;
	NSInteger lastContextValue;
	NSImage * vsimg;
	NSView * selectorContainer;
	GTInsetLabelView * centeredLabel;
	GTInsetLabelView * contextLabel;
	GTScale9Control * leftSelector;
	GTScale9Control * rightSelector;
	GTImageView * vs;
	GTDiffView * diffView;
	GTScale9Control * bugButton;
}

- (void) initViews;
- (void) hideCenteredLabel;
- (void) onBugButtonClick;
- (void) removeAll;
- (void) removeAllAndShowContext;
- (void) showBugButton;
- (void) showContextSlider;
- (void) showContextLabel;
- (void) showCenteredLabel;
- (void) showCenteredLabelWithLabel:(NSString *) _label;
- (void) showNoChanges;
- (void) showHeadVSStage;
- (void) showHeadVSWorkingTree;
- (void) showStageVSWorkingTree;
- (void) showNothingToDiff;
- (void) showStagedChanges;
- (void) showWorkingTreeChanges;
- (void) moreContext;
- (void) lessContext;
- (NSInteger) contextValue;

@end

/*
 - (void) leftDiffSelectorHEADSelected:(id) sender;
 - (void) leftDiffSelectorPWDSelected:(id) sender;
 - (void) leftDiffSelectorStageSelected:(id) sender;
 - (void) leftDiffSelectorCommitSelected:(id) sender;
 - (void) updateSelector:(GTScale9Control *) _selector withLabel:(NSString *) _label;
 - (void) showSelector;
 - (BOOL) isLeftSelectorOnWorking;
 - (BOOL) isLeftSelectorOnStage;
 - (BOOL) isLeftSelectorOnHead;
 - (BOOL) isLeftSelectorOnCommit;
 - (BOOL) isRightSelectorOnWorking;
 - (BOOL) isRightSelectorOnStage;
 - (BOOL) isRightSelectorOnHead;
 - (BOOL) isRightSelectorOnCommit;
 - (BOOL) shouldRunDiff;
 - (NSString *) leftSelectorValue;
 - (NSString *) rightSelectorValue;
*/