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
#import "GTActiveBranchTextFieldCell.h"

/*@interface GTActiveBranchView(private)
@property (retain, nonatomic) NSMutableDictionary *fileDirectory;
@end*/


@implementation GTActiveBranchView

@synthesize files;
@synthesize fileDirectory;
@synthesize useOutline;

- (void) awakeFromNib {
	[super awakeFromNib];
	self.useOutline = YES;
	if (!self.useOutline)
	{
		[outlineContainer setHidden:YES];
	}
	
	[tableView setTarget:self]; 
	[tableView setDoubleAction:@selector(tableDoubleClickAction:)];
}

- (void) lazyInitWithGD:(GittyDocument *) _gd {
	[super lazyInitWithGD:_gd];
	[[contextMenus activeBranchActionsMenu] setDelegate:self];
	statusBarView=[gd statusBarView];
	splitContentView=[gd splitContentView];
	diffView=[gd diffView];
}

- (void)tableDoubleClickAction:(id)sender
{
	[gd openFile:sender];
}

- (void)clearEmptyDirectories:(NSMutableDictionary *)directory
{
	NSMutableArray *children = [directory objectForKey:@"children"];
	if (children)
	{
		NSMutableArray *toBeRemoved = [[[NSMutableArray alloc] init] autorelease];
		for (NSMutableDictionary *dict in children)
		{
			NSMutableArray *subDicts = [dict objectForKey:@"children"];
			if (subDicts)
			{
				[self clearEmptyDirectories:dict];
				if ([subDicts count] == 0)
					[toBeRemoved addObject:dict];
			}
		}
		
		for (NSMutableDictionary *dict in toBeRemoved)
		{
			[children removeObject:dict];
		}
	}
}

- (void)addFile:(GTGitFile *)file toDirectory:(NSMutableDictionary *)dictionary withFileIndex:(NSUInteger)fileIndex performFileCheck:(BOOL)fileCheck
{
	NSString *path = @"";
	int index = 0;
	NSMutableDictionary *currentDict = dictionary;
	
	while (path)
	{
		BOOL isPath = NO;
		path = [file pathComponentAtIndex:index isPath:&isPath];
		if (path)
		{
			NSMutableArray *children = [currentDict objectForKey:@"children"];
			if (!children)
			{
				children = [[[NSMutableArray alloc] init] autorelease];
				[currentDict setObject:children forKey:@"children"];
			}
			
			NSMutableArray *staleObjects = [[[NSMutableArray alloc] init] autorelease];
			BOOL needsNewEntry = YES;

			for (NSMutableDictionary *item in children)
			{
				// sort of an extra catch for instances where its refreshing.
				// since we're enumerating children, check to see if its been removed
				// from the main file list, if so, delete it from here too.
				GTGitFile *thefile = [item objectForKey:@"gitfile"];
				if (thefile && fileCheck)
				{
					BOOL foundOne = NO;
					for (GTGitFile *tempFile in files)
					{
						if ([tempFile.filename isEqualToString:thefile.filename])
						{
							foundOne = YES;
							break;
						}
					}
					if (!foundOne)
						[staleObjects addObject:item];
				}
				/*if (file && ![files containsObject:file])
				{
					// queue it up for removal.
					[staleObjects addObject:item];
				}*/
				
				// if it exists, lets skip it, but update its information, just in case.
				NSString *name = [item objectForKey:@"name"];
				if ([name isEqualToString:path])
				{
					currentDict = item;
					needsNewEntry = NO;
					if (!isPath)
					{
						[item setObject:[[file copyWithZone:NSDefaultMallocZone()] autorelease] forKey:@"gitfile"];
						[item setObject:[NSNumber numberWithUnsignedInt:fileIndex] forKey:@"fileIndex"];
					}
					break;
				}
			}
			
			// clear out those stale objects we found.
			for (NSMutableDictionary *item in staleObjects)
			{
				[children removeObject:item];
			}
			
			// it didn't exist.  we need to make a new entry for it.
			if (needsNewEntry)
			{
				NSMutableDictionary *newEntry = [[[NSMutableDictionary alloc] init] autorelease];
				[newEntry setObject:path forKey:@"name"];
				if (!isPath)
				{
					[newEntry setObject:[[file copyWithZone:NSDefaultMallocZone()] autorelease] forKey:@"gitfile"];
					[newEntry setObject:[NSNumber numberWithUnsignedInt:fileIndex] forKey:@"fileIndex"];
				}
				[children addObject:newEntry];
				currentDict = newEntry;
			}
			
			index++;
		}
	}
	
	// now at this point, we may have directory markers that have no children, so lets clear those out too.
	[self clearEmptyDirectories:fileDirectory];
}

- (void)buildFileDirectory;
{
	BOOL fileCheck = YES;
	if (!self.fileDirectory)
	{
		self.fileDirectory = [[NSMutableDictionary alloc] init];
		fileCheck = NO;
	}
	
	if (files)
		for (NSUInteger i = 0; i < [files count]; i++)
		{
			GTGitFile *file = [files objectAtIndex:i];
			[self addFile:file toDirectory:self.fileDirectory withFileIndex:i performFileCheck:fileCheck];		
		}
	
	[outlineView reloadData];
}

- (void)setFiles:(NSMutableArray *)fileArray
{
	[files release];
	files = nil;
	if (fileArray)
		files = [[NSMutableArray alloc] initWithArray:fileArray copyItems:YES];
	
	[self buildFileDirectory];
}

- (void) show {
	NSView * rightView = [splitContentView rightView];
	[self showInView:rightView withAdjustments:NSMakeRect(0,0,0,-28)];
}

- (void) deleteAtRow {
	[gd moveToTrash:nil];
}

- (void) activateTableView {
	if (useOutline)
		[gtwindow makeFirstResponder:outlineView];
	else
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

	if (useOutline)
	{
		if(![self isClickedRowIncludedInSelection]) 
			indexes = [[[NSIndexSet alloc] initWithIndex:[outlineView clickedRow]] autorelease];
		else 
			indexes = [outlineView selectedRowIndexes];
		
		if ([indexes count])
		{
			NSMutableIndexSet *indexSet = [[[NSMutableIndexSet alloc] init] autorelease];
			
			// turn this into something -files- will understand.
			NSUInteger *indexInts = malloc(sizeof(NSUInteger) * [indexes count]);
			[indexes getIndexes:indexInts maxCount:[indexes count] inIndexRange:nil];
			for (NSUInteger i = 0; i < [indexes count]; i++)
			{
				id item = [outlineView itemAtRow:indexInts[i]];
				NSNumber *fileIndex = [item objectForKey:@"fileIndex"];
				if (fileIndex)
				{
					[indexSet addIndex:[fileIndex unsignedIntValue]];
				}
				NSLog(@"item = %@", item);
			}
			free(indexInts);
			
			indexes = indexSet;
		}
	}
	else
	{
		if(![self isClickedRowIncludedInSelection]) 
			indexes = [[[NSIndexSet alloc] initWithIndex:[tableView clickedRow]] autorelease];
		else 
			indexes = [tableView selectedRowIndexes];
	}
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
	activeState |= _type;
}

- (void) updateFromStatusBarView {
	[tableView deselectAll:nil];
	[tableView scrollRowToVisible:0];
	[self update];
}

- (void) update {
	NSUInteger currentState = activeState;
	activeState = 0;
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
	
	// if our display state is different, lets clear the file list so it gets rebuilt.
	// if its the same, it should just be updated.
	if (activeState != currentState)
		self.fileDirectory = nil;
	
	NSMutableArray * copy = [[NSMutableArray alloc] initWithArray:fls copyItems:true];
	NSArray * srt = [copy sortedArrayUsingSelector:@selector(sortAscending:)];
	NSMutableArray * sorted = [[NSMutableArray alloc] initWithArray:srt copyItems:true];
	
	if(filesCopy) [filesCopy release];
	filesCopy = [[NSMutableArray alloc] initWithArray:sorted copyItems:true];
	
	self.files = sorted;//[self setFiles:sorted];
	if (useOutline)
		[self buildFileDirectory];
	
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
	self.fileDirectory = nil;
	[self setFiles:newFiles];
	[newFiles release];
	[tableView reloadData];
	[gd onSearch];
}

- (void) clearSearch {
	self.fileDirectory = nil;
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

- (NSCell *)tableView:(NSTableView *)aTableView dataCellForTableColumn:(NSTableColumn *)column row:(NSInteger)row
{
	if ([[column identifier] isEqualTo:@"status"])
	{
		NSImageCell *cell = (NSImageCell *)[column dataCell];
		return cell;
	}
	
	if ([[column identifier] isEqualTo:@"filename"])
	{
		GTGitFile *	file = [files objectAtIndex:row];
		GTActiveBranchTextFieldCell *cell = (GTActiveBranchTextFieldCell *)[column dataCell];
		cell.file = file;
		[cell setMenu:[contextMenus activeBranchActionsMenu]];
		
		return cell;
	}
	
	return nil;	
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

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
	[gd onActiveBranchViewSelectionChange];
}

- (void)outlineViewItemDidExpand:(NSNotification *)notification
{
	NSLog(@"notification = %@", notification);
	NSDictionary *dict = [notification userInfo];
	NSMutableDictionary *item = [dict objectForKey:@"NSObject"];
	[expandedItems addObject:item];
}

- (void)outlineViewItemDidCollapse:(NSNotification *)notification
{
	NSLog(@"notification = %@", notification);
	NSDictionary *dict = [notification userInfo];
	NSMutableDictionary *item = [dict objectForKey:@"NSObject"];
	[expandedItems removeObject:item];
}

- (NSCell *)outlineView:(NSOutlineView *)anOutlineView dataCellForTableColumn:(NSTableColumn *)column item:(id)item
{
	if ([[column identifier] isEqualTo:@"status"])
	{
		NSImageCell *cell = (NSImageCell *)[column dataCell];
		return cell;
	}
	
	if ([[column identifier] isEqualTo:@"filename"])
	{
		GTGitFile *	file = [item objectForKey:@"gitfile"];
		GTActiveBranchTextFieldCell *cell = (GTActiveBranchTextFieldCell *)[column dataCell];
		cell.file = file;
		[cell setMenu:[contextMenus activeBranchActionsMenu]];
	}
	
	return nil;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(long)index ofItem:(id)item
{
	if (!item)
		item = self.fileDirectory;

	NSMutableArray *children = [item objectForKey:@"children"];
	if (children)
	{
		return [children objectAtIndex:index];
	}
	return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
	NSMutableArray *children = [item objectForKey:@"children"];
	if ([children count])
		return YES;
	return NO;
}

- (long)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
	if (!item)
		item = self.fileDirectory;
	NSMutableArray *children = [item objectForKey:@"children"];
	return [children count];
}

- (id)outlineView:(NSOutlineView *)anOutlineView objectValueForTableColumn:(NSTableColumn *)column byItem:(id)item
{
	GTGitFile *	file = [item objectForKey:@"gitfile"];

	if (file)
		[[column dataCell] setMenu:[contextMenus activeBranchActionsMenu]];
	
	id val = nil;
	if ([[column identifier] isEqualTo:@"status"])
	{
		BOOL selected = [anOutlineView isRowSelected:[anOutlineView rowForItem:item]];
		val = [NSImage imageNamed:@"statusNone.png"];
		if (file)
		{
			if (selected) 
				val = [NSImage imageNamed:[file selectedStatusImageFilename]];
			else 
				val = [NSImage imageNamed:[file statusImageFilename]];
		}
	} 
	else
	if ([[column identifier] isEqualTo:@"filename"])
	{
		val = [item objectForKey:@"name"];
	}
	return val;
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTActiveBranchView\n");
	#endif
	GDRelease(lastSearchTerm);
	GDRelease(files);
	GDRelease(filesCopy);
	GDRelease(fileDirectory);
	hasSetTableProperties=false;
	statusBarView=nil;
	diffView=nil;
	splitContentView=nil;
	[super dealloc];
}

@end

