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

#import "GTHistoryView.h"
#import "GTOperationsController.h"
#import "GittyDocument.h"


@implementation GTHistoryView
@synthesize commits;
@synthesize commitsCopy;
@synthesize loadInfo;

- (void) awakeFromNib {
	hasSetDelegate = false;
	hasObserver = false;
	loadInfo = [[GTGitCommitLoadInfo alloc] init];
	selectedFirst = false;

	[self updateTableHeaderCells];
}

- (void) activateTableView {
	[gtwindow makeFirstResponder:tableView];
}

- (void) updateTableHeaderCells {
	NSTableColumn * subjectColumn = [tableView tableColumnWithIdentifier:@"subject"];
	GTTableHeaderCell * thc = [[[GTTableHeaderCell alloc] init] autorelease];
	[thc setTitle:@"Subject"];
	[subjectColumn setHeaderCell:thc];
}

- (void) showInView:(NSView *) _view {
	[super showInView:_view];
	[self adjustColumnSizes];
	if(!hasObserver) {
		hasObserver=true;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onWindowResized) name:NSWindowDidResizeNotification object:[gd gtwindow]];
	}
}

- (void) removeFromSuperview {
	[super removeFromSuperview];
}

- (void) onWindowResized {
	if(![self superview]) return;
	[self adjustColumnSizes];
}

- (void) adjustColumnSizes {
	NSSize s = [self frame].size;
	float width = s.width;
	int dateWidth = 200;
	int authorWidth = 140;
	int subjectWidth = width - dateWidth - authorWidth;
	if(subject is nil) subject = [tableView tableColumnWithIdentifier:@"subject"];
	if(author is nil) author = [tableView tableColumnWithIdentifier:@"author"];
	if(date is nil) date = [tableView tableColumnWithIdentifier:@"date"];
	[subject setWidth:subjectWidth];
	[date setWidth:dateWidth];
	[author setWidth:authorWidth];
}

- (void) clearLoadInfoAndLoadHistory {
	[loadInfo setBefore:nil];
	[loadInfo setAfter:nil];
	[loadInfo setAuthorContains:nil];
	[loadInfo setMessageContains:nil];
	[loadInfo setMatchAll:false];
	//[gd showHistoryWithForcedRemovalOfFilteredSearch:nil];
}

- (void) onEscapeKey:(id) sender {
	[tableView deselectAll:nil];
}

- (void) setGDRefs {
	[super setGDRefs];
	detailsContainerView=[gd historyDetailsContainerView];
}

- (NSInteger) selectedRow {
	return [tableView selectedRow];
}

- (NSInteger) hasRowSelected {
	return !([tableView selectedRow] is -1);
}

- (GTGitCommit *) selectedItem {
	NSInteger row = [tableView selectedRow];
	if(row == -1) return nil;
	return [commits objectAtIndex:row];
}

- (void) updateBefore:(NSDate *) _before andAfter:(NSDate *) _after andAuthorContains:(NSString *) _ac andMessageContains:(NSString *) _mc andShouldMatchAll:(BOOL) _ma{
	[loadInfo updateBefore:_before andAfter:_after andAuthorContains:_ac andMessageContains:_mc andShouldMatchAll:_ma];
}

- (void) selectCommitFromSHA:(NSString *) _sha {
	GTGitCommit * c;
	BOOL found = false;
	int i = 0;
	for(c in commits) {
		if([[c hash] isEqual:_sha]) {
			found=true;
			break;
		}
		i++;
	}
	if(!found) {
		NSBeep();
		return;
	}
	[gd clearSearch];
	[gd clearSearchField];
	[tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:i] byExtendingSelection:false];
	[tableView scrollRowToVisible:i];
}

- (void) invalidate {
	[operations runLoadHistoryWithLoadInfo:loadInfo];
}

- (void) clearHistoryRef {
	[loadInfo setRefName:nil];
}

- (void) setHistoryRefName:(NSString *) _refName {
	[loadInfo setRefName:_refName];
}

- (void) selectFirstItem {
	//selectedFirst=false;
	[tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:false];
	[tableView scrollRowToVisible:0];
}

- (NSString *) currentRef {
	return [loadInfo refName];
}

- (void) update {
	[self setCommits:[gitd historyCommits]];
	if(commitsCopy) [commitsCopy release];
	commitsCopy = [[NSMutableArray alloc] initWithArray:commits copyItems:true];
	if(lastSearchTerm) {
		[self search:lastSearchTerm];
		return;
	}
	if(!hasSetDelegate) {
		[tableView setDelegate:self];
		[tableView setDataSource:self];
		hasSetDelegate=true;
	} else {
		[tableView reloadData];		
		headRow = -1;
	}
}

- (void) search:(NSString *) _term {
	GDRelease(lastSearchTerm);
	lastSearchTerm=[_term copy];
	NSMutableArray * newCommits = [[NSMutableArray alloc] initWithArray:[commitsCopy arrayByMatchingObjectsWithRegex:_term]];
	[self setCommits:newCommits];
	[newCommits release];
	[tableView reloadData];
	headRow = -1;
	//[gd onSearch];
}

- (void) clearSearch {
	[self setCommits:commitsCopy];
	[tableView reloadData];
	headRow = -1;
}

- (id) tableView:(NSTableView *) _tableView objectValueForTableColumn:(NSTableColumn *) _tableColumn row:(NSInteger) _row {
	id res = nil;
	GTGitCommit * commit=[commits objectAtIndex:_row];
	
	BOOL matchingHash = NO;
	if ([commit.abbrevHash isEqualToString:[gitd currentAbbreviatedSha]])
		matchingHash = YES;
	
	if([[_tableColumn identifier] isEqual:@"subject"])res=[commit subject];
	else if([[_tableColumn identifier] isEqual:@"author"])res=[commit author];
	else if([[_tableColumn identifier] isEqual:@"date"]) {
		res=[[commit date] descriptionWithCalendarFormat:@"%B %e, %Y" timeZone:nil locale:nil];
	}
	[[_tableColumn dataCell] setMenu:[contextMenus historyActionsMenu]];
	
	if (matchingHash && [[_tableColumn identifier] isEqualToString:@"image"])
	{
		res = [NSImage imageNamed:@"currentBranch.png"];
	}
	
	return res;
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *) table {
	return [commits count];
}

- (void) tableViewSelectionDidChange:(NSNotification *) notification {
	[detailsContainerView invalidate];
}

- (void) removeObservers {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResizeNotification object:[gd gtwindow]];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTHistoryView\n");
	#endif
	GDRelease(loadInfo);
	GDRelease(commits);
	GDRelease(commitsCopy);
	GDRelease(lastSearchTerm);
	detailsContainerView=nil;
	author=nil;
	subject=nil;
	date=nil;
	hasSetDelegate=false;
	[super dealloc];
}

@end
