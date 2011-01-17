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
#import "GTGittyView.h"
#import "GTHistoryDetailsContainerView.h"
#import "GTGitCommitLoadInfo.h"
#import "NSTableView+Additions.h"
#import "GTGitCommit.h"
#import "GTTableHeaderCell.h"

@interface GTHistoryView : GTGittyView <NSTableViewDataSource,NSTableViewDelegate> {
	BOOL hasSetDelegate;
	BOOL hasObserver;
	BOOL selectedFirst;
	NSMutableArray * commits;
	NSMutableArray * commitsCopy;
	NSTableColumn * subject;
	NSTableColumn * date;
	NSTableColumn * author;
	IBOutlet NSTableView * tableView;
	GTHistoryDetailsContainerView * detailsContainerView;
	GTGitCommitLoadInfo * loadInfo;
	NSString * lastSearchTerm;
	NSInteger headRow;
}

@property (retain,nonatomic) NSMutableArray * commits;
@property (retain,nonatomic) NSMutableArray * commitsCopy;
@property (readonly,nonatomic) GTGitCommitLoadInfo * loadInfo;

- (void) activateTableView;
- (void) invalidate;
- (void) update;
- (void) search:(NSString *) _term;
- (void) clearSearch;
- (void) updateTableHeaderCells;
- (void) clearHistoryRef;
- (void) adjustColumnSizes;
- (void) clearLoadInfoAndLoadHistory;
- (void) setHistoryRefName:(NSString *) _refName;
- (void) updateBefore:(NSDate *) _before andAfter:(NSDate *) _after andAuthorContains:(NSString *) _ac andMessageContains:(NSString *) _mc andShouldMatchAll:(BOOL) _ma;
- (void) selectCommitFromSHA:(NSString *) _sha;
- (void) selectFirstItem;
- (void) removeObservers;
- (NSString *) currentRef;
- (NSInteger) hasRowSelected;
- (NSInteger) selectedRow;
- (GTGitCommit *) selectedItem;

@end
