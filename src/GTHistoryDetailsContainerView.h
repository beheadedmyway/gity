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
#import "GTGittyView.h"
#import "GTHistoryCommitDetailsView.h"
#import "GTHistoryCommitTreeView.h"
#import "GTHistoryBarView.h"
#import "GTLineView.h"
#import "GTHistoryTileView.h"
#import "GTGitCommit.h"

@class GTHistoryView;

@interface GTHistoryDetailsContainerView : GTGittyView {
	IBOutlet NSView * contentContainer;
	IBOutlet GTHistoryBarView * __weak barView;
	IBOutlet GTHistoryCommitTreeView * treeView;
	IBOutlet GTHistoryCommitDetailsView * __weak detailsView;
	IBOutlet GTLineView * lineView;
	IBOutlet GTHistoryTileView * tileView;
	GTHistoryView * historyView;
}

@property (weak,nonatomic) IBOutlet GTHistoryBarView * barView;
@property (weak,nonatomic) IBOutlet GTHistoryCommitDetailsView * detailsView;

- (void) initViews;
- (void) invalidate;
- (void) showTileView;

@end
