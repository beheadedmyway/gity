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
#import "GTGradientView.h"
#import "GTScale9Control.h"
#import "GTTopBlackGradientView.h"
#import "GTStyles.h"
#import "GTSplitContentView.h"
#import "GTConfigView.h"
#import "GDTitleBarRefView.h"

@class GittyDocument;
@class GTDocumentController;

@interface GTStateBarView : GTTopBlackGradientView {
	IBOutlet NSTextField * barLabel;
	IBOutlet NSSearchField * searchField;
	GTScaledButtonControl * lastRightButton;
	GTScaledButtonControl * lastLeftButton;
	GTScale9Control * dropDown;
	GTScale9Control * __weak currentStateButton;
	GTScale9Control * configAdd;
	GTScale9Control * configRemove;
	GTSplitContentView * splitContentView;
	GTConfigView * configView;
	GDTitleBarRefView * refDropDownView;
}

@property (weak, readonly,nonatomic) GTScale9Control * currentStateButton;

- (void) showHiddenSourceListState;

- (void) clearSearchField;
- (void) show;
- (void) showActiveBranchState;
- (void) showConfigState;
- (void) showGlobalConfigState;
- (void) showRemoteStateForRemote:(NSString *) remote;
- (void) showDetatchedHeadState;
- (void) showHistoryState;
- (void) showHistoryStateWithRefName:(NSString *) _refName;
- (void) showWithHiddenSourceList;
- (void) focusOnSearch;
- (void) searchOccured:(id) sender;
- (void) invalidateSearchControl;
- (void) removeEverything;
- (void) updateLeftButtonSizeAndPosition:(GTScale9Control *) button label:(NSAttributedString *) label;
- (void) initConfigRemoveButton;
- (void) initRefDropDownView;
- (void) invalidateConfigRemoveButton;
- (void) invalidateConfigAddButton;
- (void) initConfigAddButton;
- (float) getRequiredWidth;
- (NSPoint) getAttributedStringPositionForLabel:(NSAttributedString *) label;
- (NSRect) updateButtonRectPositionFromRight:(id) button;
- (NSRect) updateButtonRectPositionFromLeft:(GTScale9Control *) button;

@end
