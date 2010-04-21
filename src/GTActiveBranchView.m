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

#import "GTActiveBranchView.h"
#import "GittyDocument.h"
#import "GTDocumentController.h"

@implementation GTActiveBranchView
@synthesize files;

- (void) awakeFromNib {
	[super awakeFromNib];
	NSTableColumn * statusColum = [tableView tableColumnWithIdentifier:@"status"];
	NSImageCell * c = [[NSImageCell alloc] init];
	[statusColum setDataCell:c];
	[c release];
}

- (void) lazyInitWithGD:(GittyDocument *) _gd {
	[super lazyInitWithGD:_gd];
	[[contextMenus activeBranchActionsMenu] setDelegate:self];
	statusBarView=[gd statusBarView];
	splitContentView=[gd splitContentView];
	diffView=[gd diffView];
}

- (void) show {
	NSView * rightView = [splitContentView rightView];
	[self showInView:rightView withAdjustments:NSMakeRect(0,0,0,-28)];
}

- (void) deleteAtRow {
	[gd moveToTrash:nil];
}

- (void) activateTableView {
	[gtwindow makeFirstResponder:tableView];
}

- (void) onEscapeKey:(id) sender {
	[tableView deselectAll:nil];
}

- (BOOL) isClickedRowIncludedInSelection {
	NSIndexSet * indexes = [tableView selectedRowIndexes];
	if([tableView clickedRow] == -1) return true;
	return [indexes containsIndex:[tableView clickedRow]];
}

- (NSString *) getSelectedFileExtension {
	NSMutableArray * f = [self selectedFiles];
	NSString * fl = [f objectAtIndex:0];
	return [fl pathExtension];
}

- (NSString *) selectedFileShortName {
	NSMutableArray * f = [self selectedFiles];
	NSString * fl = [f objectAtIndex:0];
	return fl;
}

- (GTGitFile *) selectedGitFile {
	NSIndexSet * indexes = [self getSelectedIndexSet];
	if(indexes == nil || [indexes count] < 0) return nil;
	NSArray * gtfiles = [files objectsAtIndexes:indexes];
	if([gtfiles count] < 1) return nil;
	return [gtfiles objectAtIndex:0];
}

- (NSArray *) selectedGitFiles {
	NSIndexSet * indexes = [self getSelectedIndexSet];
	if(indexes == nil || [indexes count] < 0) return nil;
	return [files objectsAtIndexes:indexes];
}

- (NSIndexSet *) getSelectedIndexSet {
	NSIndexSet * indexes = nil;
	if(![self isClickedRowIncludedInSelection]) indexes = [[[NSIndexSet alloc] initWithIndex:[tableView clickedRow]] autorelease];
	else indexes = [tableView selectedRowIndexes];
	return indexes;
}

- (NSMutableArray *) selectedFiles {
	NSIndexSet * indexes = [self getSelectedIndexSet];
	if(indexes == nil || [indexes count] < 0) return nil;
	NSArray * gtfiles = [files objectsAtIndexes:indexes];
	NSMutableArray * names = [[[NSMutableArray alloc] init] autorelease];
	GTGitFile * fl;
	for(fl in gtfiles) [names addObject:[fl filename]];
	return names;
}

- (NSMutableArray *) allFiles {
	GTGitFile * fl;
	NSMutableArray * names = [[[NSMutableArray alloc] init] autorelease];
	for(fl in files) [names addObject:[fl filename]];
	return names;
}

- (NSInteger) selectedFilesCount {
	if([tableView numberOfSelectedRows] == 0 && [tableView clickedRow] > -1) return 1;
	return [tableView numberOfSelectedRows];
}

- (BOOL) isSelectedFileAConflictedFile {
	if([self selectedFilesCount] == 0 || [self selectedFilesCount] > 1) return false;
	NSMutableArray * selectedFiles = [self selectedFiles];
	NSString * file = [selectedFiles objectAtIndex:0];
	if([gitd isFileConflicted:file]) return true;
	return false;
}

- (NSMutableArray *) filesForAdd {
	return [self selectedFiles];
}

- (NSMutableArray *) filesForRemove {
	return [self selectedFiles];
}

- (NSMutableArray *) filesForDelete {
	return [self selectedFiles];
}

- (NSMutableArray *) filesForDiscard {
	return [self selectedFiles];
}

- (void) appendFiles:(NSMutableArray *) _files toArray:(NSMutableArray *) _appendTo forType:(int) _type {
	NSMutableArray * adds = [GTGitFile createArrayOfItemsFromArray:_files ofStatusType:_type];
	[_appendTo addObjectsFromArray:adds];
}

- (void) updateFromStatusBarView {
	[tableView deselectAll:nil];
	[tableView scrollRowToVisible:0];
	[self update];
}

- (void) update {
	NSMutableArray * tmp;
	NSMutableArray * fls = [[NSMutableArray alloc] init];
	BOOL addedFiles = false;
	if([statusBarView shouldShowStagedFiles]) {
		if([gitd stagedAddedFilesCount] > 0) {
			addedFiles=true;
			tmp=[[NSMutableArray alloc] initWithArray:[gitd stageAddedFiles] copyItems:true];
			[self appendFiles:tmp toArray:fls forType:kStageAdded];
			[tmp release];
			tmp=nil;
		}
		if([gitd stagedModifiedFilesCount] > 0) {
			addedFiles=true;
			tmp=[[NSMutableArray alloc] initWithArray:[gitd stageModifiedFiles] copyItems:true];
			[self appendFiles:tmp toArray:fls forType:kStageModified];
			[tmp release];
			tmp=nil;
		}
		if([gitd stagedDeletedFilesCount] > 0) {
			addedFiles=true;
			tmp=[[NSMutableArray alloc] initWithArray:[gitd stageDeletedFiles] copyItems:true];
			[self appendFiles:tmp toArray:fls forType:kStageDeleted];
			[tmp release];
			tmp=nil;
		}
	}
	if([statusBarView shouldShowUntrackedFiles] and [gitd untrackedFilesCount] > 0) {
		addedFiles=true;
		tmp=[[NSMutableArray alloc] initWithArray:[gitd untrackedFiles] copyItems:true];
		[self appendFiles:tmp toArray:fls forType:kUntracked];
		[tmp release];
		tmp=nil;
	}
	if([statusBarView shouldShowModifiedFiles] and [gitd modifiedFilesCount] > 0) {
		addedFiles=true;
		tmp=[[NSMutableArray alloc] initWithArray:[gitd modifiedFiles] copyItems:true];
		[self appendFiles:tmp toArray:fls forType:kModified];
		[tmp release];
		tmp=nil;
	}
	if([statusBarView shouldShowDeletedFiles] and [gitd deletedFilesCount] > 0) {
		addedFiles=true;
		tmp=[[NSMutableArray alloc] initWithArray:[gitd deletedFiles] copyItems:true];
		[self appendFiles:tmp toArray:fls forType:kDeleted];
		[tmp release];
		tmp=nil;
	}
	if([statusBarView shouldShowConflictedFiles] and [gitd unmergedFilesCount] > 0) {
		addedFiles=true;
		tmp=[[NSMutableArray alloc] initWithArray:[gitd unmergedFiles] copyItems:true];
		[self appendFiles:tmp toArray:fls forType:kConflicted];
		[tmp release];
		tmp=nil;
	}
	if(!addedFiles) {
		tmp=[[NSMutableArray alloc] initWithArray:[gitd allFiles] copyItems:true];
		[self appendFiles:tmp toArray:fls forType:kNoStatus];
		[tmp release];
		tmp=nil;
	}
	
	NSMutableArray * copy = [[NSMutableArray alloc] initWithArray:fls copyItems:true];
	NSArray * srt = [copy sortedArrayUsingSelector:@selector(sortAscending:)];
	NSMutableArray * sorted = [[NSMutableArray alloc] initWithArray:srt copyItems:true];
	
	if(filesCopy) [filesCopy release];
	filesCopy = [[NSMutableArray alloc] initWithArray:sorted copyItems:true];
	
	[self setFiles:sorted];
	[sorted release];
	[copy release];
	[fls release];
	
	if(lastSearchTerm) {
		[self search:lastSearchTerm];
		return;
	}
	if(!hasSetTableProperties) {
		[tableView setDelegate:self];
		[tableView setDataSource:self];
		hasSetTableProperties=true;
	} else [tableView reloadData];
}

- (void) search:(NSString *) term {
	if(lastSearchTerm neq term) {
		[lastSearchTerm release];
		lastSearchTerm = [term copy];
	}
	NSMutableArray * newFiles = [[NSMutableArray alloc] initWithArray:[filesCopy arrayByMatchingObjectsWithRegex:term]];
	[self setFiles:newFiles];
	[newFiles release];
	[tableView reloadData];
	[gd onSearch];
}

- (void) clearSearch {
	[self setFiles:filesCopy];
	if(lastSearchTerm) {
		[lastSearchTerm release];
		lastSearchTerm = nil;
	}
	[tableView reloadData];
	[gd onClearSearch];
}

- (void) menuNeedsUpdate:(NSMenu *) menu {
	NSCell * c = [tableView preparedCellAtColumn:1 row:[tableView clickedRow]];
	[contextMenus invalidateActiveBranchViewMenus];
	[c setMenu:[contextMenus activeBranchActionsMenu]];
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *) table {
	return [files count];
}

- (id) tableView:(NSTableView *) table objectValueForTableColumn:(NSTableColumn *) column row:(NSInteger) index {
	[[column dataCell] setMenu:[contextMenus activeBranchActionsMenu]];
	GTGitFile * file = [files objectAtIndex:index];
	id val;
	if([[column identifier] isEqualTo:@"status"]) {
		BOOL selected = [tableView isRowSelected:index];
		if(selected) val = [NSImage imageNamed:[file selectedStatusImageFilename]];
		else val = [NSImage imageNamed:[file statusImageFilename]];
	} else {
		val=[file filename];
	}
	return val;
}

- (void) tableViewSelectionDidChange:(NSNotification *) aNotification {
	[gd onActiveBranchViewSelectionChange];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTActiveBranchView\n");
	#endif
	GDRelease(lastSearchTerm);
	GDRelease(files);
	GDRelease(filesCopy);
	hasSetTableProperties=false;
	statusBarView=nil;
	diffView=nil;
	splitContentView=nil;
	[super dealloc];
}

@end

