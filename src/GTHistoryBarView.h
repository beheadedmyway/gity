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
#import "GTGradientView.h"
#import "GTInsetLabelView.h"
#import "GTViewLayoutHelper.h"
#import "GTScale9Control.h"

@class GTHistoryView;
@class GTHistoryCommitDetailsView;

@interface GTHistoryBarView : GTGradientView {
	BOOL state;
	BOOL hasContextChanged;
	NSInteger lastContextValue;
	NSView * viewSelectorButtons;
	IBOutlet NSSlider * contextSlider;
	GTInsetLabelView * centeredLabel;
	GTInsetLabelView * contextLabel;
	GTHistoryView * historyView;
	GTHistoryCommitDetailsView * detailsView;
	GTScale9Control * details;
	GTScale9Control * tree;
	GTScale9Control * bugButton;
}

- (void) initBugButton;
- (void) initContextLabel;
- (void) initViews;
- (void) initButtons;
- (void) invalidate;
- (void) removeSelectorButtons;
- (void) removeContext;
- (void) showCenteredLabel;
- (void) showSelectorButtons;
- (void) toggleState;
- (void) onContextSliderUpdate;
- (void) moreContext;
- (void) lessContext;
- (void) showBugButton;
- (void) onBugButtonClick;
- (BOOL) isDetailsButtonPushed;
- (BOOL) isTreeButtonPushed;
- (BOOL) hasContextChanged;
- (NSInteger) contextValue;

@end
