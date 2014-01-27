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

#import "GTHistoryDetailsContainerView.h"
#import "GTHistoryView.h"
#import "GittyDocument.h"

@implementation GTHistoryDetailsContainerView
@synthesize barView;
@synthesize detailsView;

- (void) awakeFromNib {
	[super awakeFromNib];
	[self initViews];
}

- (void) setGDRefs {
	[super setGDRefs];
	historyView=[gd historyView];
}

- (void) lazyInitWithGD:(GittyDocument *) _gd {
	[super lazyInitWithGD:_gd];
	[barView lazyInitWithGD:_gd];
	[treeView lazyInitWithGD:_gd];
	[detailsView lazyInitWithGD:_gd];
}

- (void) initViews {
	[lineView setLineColor:[NSColor colorWithDeviceRed:.62 green:.62 blue:.62 alpha:1]];
	[self showTileView];
}

- (void) showTileView {
	[tileView setFrame:[self frame]];
	[tileView showInView:contentContainer];
}

- (void) invalidate {
	GTGitCommit * commit = [historyView selectedItem];
	[barView invalidate];
	if(commit is nil) {
		[treeView removeFromSuperview];
		[detailsView removeFromSuperview];
		[detailsView disposeWebkit];
		[detailsView clearCurSHA];
		[detailsView invalidate];
		[mainMenuHelper invalidateViewMenu];
		[self showTileView];
		return;
	}
	[tileView removeFromSuperview];
	if([barView isDetailsButtonPushed]) {
		[detailsView showInView:contentContainer withAdjustments:NSMakeRect(0,0,0,-1)];
		[detailsView invalidate];
	} else if([barView isTreeButtonPushed]) {
		[treeView showInView:contentContainer];
		[treeView invalidate];
	}
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTHistoryDetailsContainerView\n");
	#endif
	GDRelease(tileView);
}

@end
