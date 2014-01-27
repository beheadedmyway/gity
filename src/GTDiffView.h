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
#import "GTDiffContentView.h"
#import "GTDiffBarView.h"
#import "GTLineView.h"
#import "GTDiffCommitSelectorView.h"
#import "GTGitDiff.h"

@interface GTDiffView : GTGittyView {
	IBOutlet NSView * contentContainer;
	IBOutlet GTLineView * lineView;
	IBOutlet GTDiffBarView * __weak diffBarView;
	IBOutlet GTDiffContentView * __weak diffContentView;
	IBOutlet GTDiffCommitSelectorView * commitSelectorView;
	GTGitDiff * diff;
}

@property (weak, readonly,nonatomic) GTDiffContentView * diffContentView;
@property (weak, readonly,nonatomic) GTDiffBarView * diffBarView;

- (void) initViews;
- (void) showDiffCommitSelectorState;
- (void) showDiffViewer;
- (void) reportDiff;
- (void) invalidate;
- (void) rediffFromContextUpdate;
- (void) moreContext;
- (void) lessContext;
- (void) runDiff;
- (void) releaseDiffContent;

@end
