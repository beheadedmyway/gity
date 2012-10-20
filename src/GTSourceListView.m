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

#import "GTSourceListView.h"
#import "GittyDocument.h"
#import "GTDocumentController.h"
#import "NSOutlineView+Additions.h"


@implementation GTSourceListView
@synthesize scrollView;
@synthesize sourceListView;
@synthesize wasJustUpdated;
@synthesize sourceListMenuView;
@synthesize rootItem;
@synthesize tagsItem;
@synthesize branchesItem;
@synthesize remotesItem;

- (void) lazyInitWithGD:(GittyDocument *) _gd {
	[super lazyInitWithGD:_gd];
	
	missingDefaultsExpandState = true;
	wasBranchesExpanded = false;
	wasTagsExpanded = false;
	wasStashExpanded = false;
	wasSubmodulesExpanded = false;
	wasRemotesExpanded = false;
	
	[sourceListMenuView lazyInitWithGD:_gd];
	[sourceListView setGd:_gd];

	splitContentView = [gd splitContentView];
	leftView = [[gd splitContentView] leftView];
	gitProjectPath = [[git gitProjectPath] copy];
	
	NSDictionary * expandState = [[NSUserDefaults standardUserDefaults] objectForKey:[@"GTSourceListExpandedState_" stringByAppendingString:gitProjectPath]];
	
	if(expandState == nil) {
		missingDefaultsExpandState = true;
		wasBranchesExpanded = true;
		wasRemotesExpanded = true;
		wasStashExpanded = true;
		wasSubmodulesExpanded = true;
		wasTagsExpanded = true;
	} 
	else {
		missingDefaultsExpandState=false;
		wasBranchesExpanded = [[expandState objectForKey:@"GTSourceListBranchExpanded"] boolValue];
		wasTagsExpanded = [[expandState objectForKey:@"GTSourceListTagExpanded"] boolValue];
		wasRemotesExpanded = [[expandState objectForKey:@"GTSourceListRemoteExpanded"] boolValue];
		wasSubmodulesExpanded = [[expandState objectForKey:@"GTSourceListSubmoduleExpanded"] boolValue];
		wasStashExpanded = [[expandState objectForKey:@"GTSourceListStashExpanded"] boolValue];
		wasRemoteBranchesExpanded = [[expandState objectForKey:@"GTSourceListRemoteBranchesExpanded"] boolValue];
	}
	
	[sourceListView setDoubleAction:@selector(doubleClickAction:)];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onWindowResized) name:NSWindowDidResizeNotification object:[gd gtwindow]];
}

- (void) onWindowResized {
	if(![self superview]) return;
	[self showActionsMenu];
}

- (BOOL) isScrollBarShown {
	NSRect svf = [scrollView frame];
	NSRect slv = [sourceListView frame];
	if(slv.size.height > svf.size.height) return true;
	return false;
}

- (NSString *) getWidthKey {
	return [@"GTGitySourceListWidth " stringByAppendingString:gitProjectPath];
}

- (void)setFrame:(NSRect)frameRect
{
	[super setFrame:frameRect];
	if (gitProjectPath)
	{
		[self saveSizeToDefaults];
		[self persistViewState];
	}
}

- (void) saveSizeToDefaults {
	NSSize lvs = [leftView frame].size;
	NSString * key = [self getWidthKey];
	if(key is nil) return;
	[[NSUserDefaults standardUserDefaults] setInteger:lvs.width forKey:key];
}

- (void) persistViewState {
	wasBranchesExpanded = [sourceListView isItemExpanded:branchesItem];
	wasTagsExpanded = [sourceListView isItemExpanded:tagsItem];
	wasSubmodulesExpanded = [sourceListView isItemExpanded:subsItem];
	wasStashExpanded = [sourceListView isItemExpanded:stashItem];
	wasRemotesExpanded = [sourceListView isItemExpanded:remotesItem];
	wasRemoteBranchesExpanded = [sourceListView isItemExpanded:remoteBranchesItem];
	NSMutableDictionary * expandState = [[NSMutableDictionary alloc] init];
	if(wasBranchesExpanded) [expandState setObject:[NSNumber numberWithBool:YES] forKey:@"GTSourceListBranchExpanded"];
	else [expandState setObject:[NSNumber numberWithBool:NO] forKey:@"GTSourceListBranchExpanded"];
	if(wasTagsExpanded) [expandState setObject:[NSNumber numberWithBool:YES] forKey:@"GTSourceListTagExpanded"];
	else [expandState setObject:[NSNumber numberWithBool:NO] forKey:@"GTSourceListTagExpanded"];
	if(wasRemotesExpanded) [expandState setObject:[NSNumber numberWithBool:YES] forKey:@"GTSourceListRemoteExpanded"];
	else [expandState setObject:[NSNumber numberWithBool:NO] forKey:@"GTSourceListRemoteExpanded"];
	if(wasStashExpanded) [expandState setObject:[NSNumber numberWithBool:YES] forKey:@"GTSourceListStashExpanded"];
	else [expandState setObject:[NSNumber numberWithBool:NO] forKey:@"GTSourceListStashExpanded"];
	if(wasSubmodulesExpanded) [expandState setObject:[NSNumber numberWithBool:YES] forKey:@"GTSourceListSubmoduleExpanded"];
	else [expandState setObject:[NSNumber numberWithBool:NO] forKey:@"GTSourceListSubmoduleExpanded"];
	if(wasRemoteBranchesExpanded) [expandState setObject:[NSNumber numberWithBool:YES] forKey:@"GTSourceListRemoteBranchesExpanded"];
	else [expandState setObject:[NSNumber numberWithBool:NO] forKey:@"GTSourceListRemoteBranchesExpanded"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:expandState] forKey:[@"GTSourceListExpandedState_" stringByAppendingString:gitProjectPath]];
	[expandState release];
}

- (void) show {
	NSRect lvf=[leftView frame];
	NSString * key=[self getWidthKey];
	int width=[[NSUserDefaults standardUserDefaults] integerForKey:key];
	NSRect r;
	if(width > 0) {
		r = NSMakeRect(0,0,width,lvf.size.height);
		[leftView setFrame:r];
		[self setFrame:r];
	} else {
		r = NSMakeRect(0,0,lvf.size.width,lvf.size.height);
		[self setFrame:r];
	}
	[leftView addSubview:self];
	[sourceListView setAppearance:kSourceList_NumbersAppearance];
	[sourceListView setDelegate:self];
	[sourceListView setDataSource:self];
	[sourceListView setAllowsMultipleSelection:false];
	[sourceListView setFrame:NSMakeRect(0,0,lvf.size.width,lvf.size.height)];
	[self showActionsMenu];
}

- (void) showActionsMenu {
	NSRect nfr;
	NSRect sf = [leftView frame];
	if([self isScrollBarShown]) nfr = NSMakeRect(sf.size.width-38,sf.size.height-19,17,13);
	else nfr = NSMakeRect(sf.size.width-27,sf.size.height-19,17,13);
	[sourceListMenuView setFrame:nfr];
	if(![sourceListMenuView superview])[self addSubview:sourceListMenuView];
}

- (BOOL) isSelectedItemActiveBranch {
	GTSourceListItem * item = [self selectedItem];
	if(item == nil) return false;
	return ([[item name] isEqual:[gitd activeBranchName]]);
}

- (NSString *) selectedItemName {
	GTSourceListItem * item = [sourceListView itemAtRow:[sourceListView clickedRow]];
	if(item == nil) item = [sourceListView itemAtRow:[sourceListView selectedRow]];
	return [item name];
}

- (NSString *) selectedItemLowercaseName {
	GTSourceListItem * item = [sourceListView itemAtRow:[sourceListView clickedRow]];
	if(item == nil) item = [sourceListView itemAtRow:[sourceListView selectedRow]];
	return [[item name] lowercaseString];
}

- (void)selectActiveBranch
{
	for (GTSourceListItem *item in branchesItem.items)
	{
		if ([[item name] isEqual:[gitd activeBranchName]])
		{
			[sourceListView selectItem:item];
			break;
		}
	}
}

- (GTSourceListItem *) selectedItem {
	GTSourceListItem * item = [sourceListView itemAtRow:[sourceListView clickedRow]];
	if(item == nil) item = [sourceListView itemAtRow:[sourceListView selectedRow]];
	return item;
}

- (void) doubleClickAction:(id)sender {
	if ([[self selectedItem] isChildOfSubmodules])
		[self openSubmoduleWithGity:nil];
}

- (void) branchCheckout:(id) sender {
	if([gitd isConflicted]) {
		NSBeep();
		[modals runConflictedStateForCheckout];
		return;
	}
	GTSourceListItem * item = [self selectedItem];
	[gd gitCheckout:[item name]];
}

- (void) branchMerge:(id) sender {
	if([gitd isConflicted]) {
		NSBeep();
		[modals runConflictedStateForCheckout];
		return;
	}
	GTSourceListItem * item = [self selectedItem];
	if([modals runMergeBranch] == NSCancelButton) return;
	[operations runMergeWithBranch:[item name]];
}

- (void) remoteBranchMerge:(id) sender {
	if([gitd isConflicted]) {
		NSBeep();
		[modals runConflictedStateForCheckout];
		return;
	}
	GTSourceListItem * item = [self selectedItem];
	NSString * branch = [item name];
	[operations runMergeRemoteBranch:branch];
}

- (void) remoteBranchFetch:(id) sender {
	GTSourceListItem * item = [self selectedItem];
	NSString * branch = [item name];
	[operations runFetchRemoteBranch:branch];
}

- (BOOL)hasDefaultRemoteForBranch:(NSString *)branch
{
    BOOL result = [gitd hasDefaultRemoteForBranch:branch];
    
    if (!result)
    {
        int remotesCount = [gitd remotesCount];
        if (remotesCount == 1)
        {
            // if there's only one, lets set it to the only remote.
            NSString *origin = [[gitd remoteNames] objectAtIndex:0];
            [gitd setDefaultRemote:origin forBranch:[branch lowercaseString]];
            [[gd operations] runSetDefaultRemote:origin forBranch:branch];
            result = [gitd hasDefaultRemoteForBranch:branch];
        }
    }

    return result;
}

- (void) gitPush:(id) sender {
	GTSourceListItem * item = [self selectedItem];
	if([gitd isConflicted]) {
		NSBeep();
		[modals runConflictedStateForCheckout];
		return;
	}
	if(![self hasDefaultRemoteForBranch:[item name]]) {
		[modals runNoDefaultRemote];
		return;
	}
	NSString * remote = [gitd defaultRemoteForBranch:[item name]];
	[operations runPushBranchTo:[item name] toRemote:remote];
}

- (void) gitPushFromActiveBranch {
	if([gitd isConflicted]) {
		NSBeep();
		[modals runConflictedStateForCheckout];
		return;
	}
	NSString * branch = [gitd activeBranchName];
	if(![self hasDefaultRemoteForBranch:branch]) {
		[modals runNoDefaultRemote];
		return;
	}
	NSString * remote = [gitd defaultRemoteForBranch:branch];
	[operations runPushBranchTo:branch toRemote:remote];
}

- (void) gitPullFromActiveBranch {
	if([gitd isConflicted]) {
		NSBeep();
		[modals runConflictedStateForCheckout];
		return;
	}
	NSString * branch = [gitd activeBranchName];
	if(![self hasDefaultRemoteForBranch:branch]) {
		[modals runNoDefaultRemote];
		return;
	}
	NSString * remote = [gitd defaultRemoteForBranch:branch];
	[operations runPullBranchFrom:branch toRemote:remote];
}

- (void) gitRebaseFromActiveBranch {
	if([gitd isConflicted]) {
		NSBeep();
		[modals runConflictedStateForCheckout];
		return;
	}
	if([gitd isDirty]) {
		[modals runDirIsDirtyForRebase];
		return;
	}
	NSString * branch = [gitd activeBranchName];
	if(![self hasDefaultRemoteForBranch:branch]) {
		[modals runNoDefaultRemote];
		return;
	}
	NSString * remote = [gitd defaultRemoteForBranch:branch];
	[operations runRebaseFrom:remote withBranch:branch];
}

- (void) gitPull:(id) sender {
 	GTSourceListItem * item = [self selectedItem];
	if([gitd isConflicted]) {
		NSBeep();
		[modals runConflictedStateForCheckout];
		return;
	}
	if(![self hasDefaultRemoteForBranch:[item name]]) {
		[modals runNoDefaultRemote];
		return;
	}
	NSString * remote = [gitd defaultRemoteForBranch:[item name]];
	[operations runPullBranchFrom:[item name] toRemote:remote];
}

- (void) branchPushTo:(id) sender {
}

- (void) branchPullFrom:(id) sender {
}

- (void) tagDelete:(id) sender {
	GTSourceListItem * item = [self selectedItem];
	NSBeep();
	NSInteger res = [modals runDeleteTag];
	if(res == NSCancelButton) return;
	if(res == kGTAccessoryViewDeleteAll) {
		[operations runDeleteTagAtAllRemotes:[item name]];
		return;
	}
	[operations runTagDelete:[item name]];
}

- (void) branchDelete:(id) sender {
	GTSourceListItem * item = [self selectedItem];
	NSBeep();
	NSInteger res = [modals runDeleteBranch];
	if(res == NSCancelButton) return;
	if(res == kGTAccessoryViewDeleteAll) {
		[operations runDeleteBranchAtAllRemotes:[item name]];
		return;
	}
	[operations runBranchDelete:[item name]];
}

- (void) branchDeleteAt:(id) sender {
	GTSourceListItem * item = [self selectedItem];
	NSString * remote = [(NSMenuItem *) sender title];
	NSString * branch = [item name];
	if([modals runDeleteBranchAt:remote] == NSCancelButton) return;
	if(remote is nil or branch is nil) return;
	[operations runDeleteBranch:branch atRemote:remote];
}

- (void) tagDeleteAt:(id) sender {
	GTSourceListItem * item = [self selectedItem];
	NSString * remote = [(NSMenuItem *) sender title];
	NSString * tag = [item name];
	if([modals runDeleteTagAt:remote] == NSCancelButton) return;
	if(remote is nil or tag is nil) return;
	[operations runDeleteTag:tag atRemote:remote];
}

- (void) branchRename:(id) sender {
}

- (void) branchNewTag:(id) sender {
	if([gitd isConflicted]) {
		NSBeep();
		[modals runConflictedStateForCheckout];
		return;
	}
	GTSourceListItem * item = [self selectedItem];
	[gd gitNewTag:[item name]];
}

- (void) branchNewBranchFromHere:(id) sender {
	GTSourceListItem * item = [self selectedItem];
	if([gitd isConflicted]) {
		NSBeep();
		[modals runConflictedStateForCheckout];
		return;
	}
	[gd gitNewBranch:[item name]];
}

- (void) branchHardReset:(id) sender {
	if([modals runHardResetConfirmation] == NSCancelButton) return;
	[operations runHardReset];
}

- (void) branchDiscardNonStagedChanges:(id) sender {
	if([modals runSoftResetConfirmation] == NSCancelButton) return;
	[operations runSoftReset];
}

- (void) remoteDelete:(id) sender {
	GTSourceListItem * item = [self selectedItem];
	if([modals runDeleteRemote] == NSCancelButton) return;
	if([[item name] isEqual:@"origin"]) {
		if([modals runDeleteRemoteDoubleCheck] == NSCancelButton) return;
	}
	[operations runDeleteRemote:[item name]];
}

- (void) stashApply:(id) sender {
	GTSourceListItem * item = [self selectedItem];
	if([gitd isDirtyExcludingStage]) {
		[modals runStageAllChangesBeforeContinueing];
		return;
	}
	NSMutableDictionary * stash = (NSMutableDictionary *)[item data];
	if(![[stash objectForKey:@"branch"] isEqual:[gitd activeBranchName]]) {
		if([modals runStashSavedFromDifferentBranch] == NSCancelButton) return;
	}
	[operations runStashApply:[item index]];
}

- (void) stashPop:(id) sender {
	GTSourceListItem * item = [self selectedItem];
	if([gitd isDirtyExcludingStage]) {
		[modals runStageAllChangesBeforeContinueing];
		return;
	}
	NSMutableDictionary * stash = (NSMutableDictionary *)[item data];
	if(![[stash objectForKey:@"branch"] isEqual:[gitd activeBranchName]]) {
		if([modals runStashSavedFromDifferentBranch] == NSCancelButton) return;
	}
	[operations runStashPop:[item index]];
}

- (void) stashDelete:(id) sender {
	GTSourceListItem * item = [self selectedItem];
	if([modals runDeleteStash] == NSCancelButton) return;
	[operations runStashDelete:[item index]];
}

- (void) gitExportZip {
	GTSourceListItem * item = [self selectedItem];
	_tmpItemForExport = [item retain];
	savePanel = [NSSavePanel savePanel];
	[savePanel setCanCreateDirectories:true];
    [savePanel beginSheetModalForWindow:[gd gtwindow] completionHandler:^(NSInteger result) {
        if(result == NSFileHandlingPanelCancelButton)
            return;
        [operations runExportZip:[[savePanel URL] path] andCommit:[_tmpItemForExport name]];
        [_tmpItemForExport release];
        _tmpItemForExport=nil;
    }];
}

- (void) gitExportTar {
	GTSourceListItem * item = [self selectedItem];
	_tmpItemForExport = [item retain];
	savePanel = [NSSavePanel savePanel];
	[savePanel setCanCreateDirectories:true];
    [savePanel beginSheetModalForWindow:[gd gtwindow] completionHandler:^(NSInteger result) {
        if(result == NSFileHandlingPanelCancelButton)
            return;
        [operations runExportTar:[[savePanel URL] path] andCommit:[_tmpItemForExport name]];
        [_tmpItemForExport release];
    }];
}

- (void) updateDefaultRemote:(id) sender {
	NSMenuItem * item = (NSMenuItem *)sender;
	NSString * remote = [item title];
	GTSourceListItem * sitem = [self selectedItem];
	[gitd setDefaultRemote:remote forBranch:[[sitem name] lowercaseString]];
	[operations runSetDefaultRemote:remote forBranch:[sitem name]];
}

- (void) gitPushTo:(id) sender {
	NSString * remote = [(NSMenuItem *)sender title];
	GTSourceListItem * item = [self selectedItem];
	[operations runPushBranchTo:[item name] toRemote:remote];
}

- (void) gitPullFrom:(id) sender {
	NSString * remote = [(NSMenuItem *)sender title];
	GTSourceListItem * item = [self selectedItem];
	[operations runPullBranchFrom:[item name] toRemote:remote];
}

- (void) gitRebaseFrom:(id) sender {
	GTSourceListItem * item = [self selectedItem];
	if([gitd isConflicted]) {
		NSBeep();
		[modals runConflictedStateForCheckout];
		return;
	}
	if([gitd isDirty]) {
		[modals runDirIsDirtyForRebase];
		return;
	}
	if(![self hasDefaultRemoteForBranch:[item name]]) {
		[modals runNoDefaultRemote];
		return;
	}
	NSString * remote = [gitd defaultRemoteForBranch:[item name]];
	[operations runRebaseFrom:remote withBranch:[item name]];
}

- (void) gitPushTagTo:(id) sender {
	NSString * remote = [(NSMenuItem *)sender title];
	GTSourceListItem * item = [self selectedItem];
	[operations runPushTag:[item name] toRemote:remote];
}

- (void) gitSubmoduleUpdate:(id) sender {
	GTSourceListItem * item = [self selectedItem];
	NSString * subspec = [[item data] objectForKey:@"spec"];
	[operations runSubmoduleUpdateForSubmodule:subspec];
}

- (void) gitSubmoduleSync:(id) sender {
	GTSourceListItem * item = [self selectedItem];
	NSString * subspec = [[item data] objectForKey:@"spec"];
	[operations runSubmoduleSyncForSubmodule:subspec];
}

- (void) gitSubmodulePush:(id) sender {
	GTSourceListItem * item = [self selectedItem];
	NSString * subspec = [[item data] objectForKey:@"spec"];
	[operations runSubmodulePushForSubmodule:subspec];
}

- (void) gitSubmodulePull:(id) sender {
	GTSourceListItem * item = [self selectedItem];
	NSString * subspec = [[item data] objectForKey:@"spec"];
	[operations runSubmodulePullForSubmodule:subspec];
}

- (void) openSubmoduleWithGity:(id) sender {
	GTSourceListItem * item = [self selectedItem];
	NSString * subspec = [[item data] objectForKey:@"spec"];
	NSString * proj = [git gitProjectPath];
	NSString * projsl = [proj stringByAppendingString:@"/"];
	NSString * final = [projsl stringByAppendingString:subspec];
	[[GTDocumentController sharedDocumentController] openNSURLAndActivate:final];
}

- (void) gitDeleteSub:(id) sender {
	GTSourceListItem * item = [self selectedItem];
	NSInteger res = [modals runDeleteSubmodule];
	if(res == NSCancelButton) return;
	NSString * subspec = [[item data] objectForKey:@"spec"];
	[operations runDeleteSubmodule:subspec];
}

- (void) loadHistoryFromRef:(id) sender {
	GTSourceListItem * item = [self selectedItem];
	if(![item isChildOfTags] and ![item isChildOfBranches] and ![item isChildOfRemoteBranches]) return;
	[gd showHistoryFromRef:[item name]];
}

- (void) menuNeedsUpdate:(NSMenu *) menu {
	GTSourceListItem * item = [sourceListView itemAtRow:[sourceListView clickedRow]];
	if([item isChildOfBranches]) {
		NSCell * c = [sourceListView preparedCellAtColumn:0 row:[sourceListView clickedRow]];
		[c setMenu:[contextMenus branchActionsMenu]];
	} else if([item isChildOfRemoteBranches]) {
		NSCell * c = [sourceListView preparedCellAtColumn:0 row:[sourceListView clickedRow]];
		[c setMenu:[contextMenus remoteBranchesMenu]];
	}
}

#pragma mark delegate methods
- (void) outlineView:(NSOutlineView *) outlineView willDisplayCell:(NSCell *) cell forTableColumn:(NSTableColumn *) tableColumn item:(id) item {
	if([item isChildOfBranches]) {
		[cell setMenu:[contextMenus branchActionsMenu]];
	} else if([item isChildOfStashes]) {
		[cell setMenu:[contextMenus stashMenu]];
	} else if([item isChildOfRemotes]) {
		[cell setMenu:[contextMenus remotesMenu]];
	} else if([item isChildOfTags]) {
		[cell setMenu:[contextMenus tagsMenu]];
	} else if([item isChildOfSubmodules]) {
		[cell setMenu:[contextMenus submodulesMenu]];
	} else if([item isChildOfRemoteBranches]) {
		[cell setMenu:[contextMenus remoteBranchesMenu]];
	} else {
		[cell setMenu:nil];
	}
	GTSourceListItem * clr = [sourceListView itemAtRow:[sourceListView clickedRow]];
	if(clr) {
		[contextMenus invalidateSourceListActionsMenu];
		[contextMenus invalidateBranchesSourceListMenus];
		[contextMenus invalidateTagsSourceListMenu];
	}
}

- (void) outlineViewSelectionDidChange:(NSNotification*) notification {
	//NSPoint event_location = [theEvent locationInWindow];
	//NSPoint local_point = [self convertPoint:event_location fromView:nil];
	//NSInteger row = [self rowAtPoint:local_point];
	//GTSourceListItem * item = [self itemAtRow:row];
	GTSourceListItem * item = [self selectedItem];
	if([item isChildOfBranches] && [[item name] isEqual:[[gd gitd] activeBranchName]]) {
		[gd showActiveBranch:nil];
	}
	else if([item isChildOfTags] or [item isChildOfBranches] or [item isChildOfRemoteBranches]) {
		[gd showHistoryFromRef:[item name]];
	}
	[contextMenus invalidateSourceListActionsMenu];
	[contextMenus invalidateBranchesSourceListMenus];
	[contextMenus invalidateTagsSourceListMenu];
	[self showActionsMenu];
}

- (BOOL) outlineView:(NSOutlineView*) outlineView shouldSelectItem:(id) item {
	return ![item isGroupItem];
}

- (CGFloat) outlineView:(NSOutlineView*) outlineView heightOfRowByItem:(id) item {
	CGFloat res = 0;
	if([item isGroupItem]) res=[sourceListView rowHeight]+4;
	else res = [sourceListView rowHeight];
	return res;
}

- (BOOL) outlineView:(NSOutlineView *) outlineView isItemExpandable:(id) item {
	return (item == nil) ? YES : ([item numChildren] > 0);
}

- (id) outlineView:(NSOutlineView *) outlineView child:(NSInteger) index ofItem:(id) item {
	GTSourceListItem * gitem = (GTSourceListItem *) item;
	if(item == nil) return [rootItem itemAtIndex:index];
	return [gitem itemAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item {
	return NO;
}

- (NSInteger) outlineView:(NSOutlineView *) outlineView numberOfChildrenOfItem:(id) item {
	return (item == nil) ? [rootItem numChildren] : [item numChildren];
}

- (id) outlineView:(NSOutlineView *) outlineView objectValueForTableColumn:(NSTableColumn *) tableColumn byItem:(id) item {
	return (item == nil) ? nil : [item label];
}

- (void) outlineViewItemDidCollapse:(NSNotification *) notification {
	[NSTimer scheduledTimerWithTimeInterval:.001 target:self selector:@selector(showActionsMenu) userInfo:nil repeats:false];
}

- (void) outlineViewItemDidExpand:(NSNotification *) notification {
	[NSTimer scheduledTimerWithTimeInterval:.001 target:self selector:@selector(showActionsMenu) userInfo:nil repeats:false];
}

- (void)outlineViewItemWillCollapse:(NSNotification *)notification {
	//[self showActionsMenu];
}

- (void)outlineViewItemWillExpand:(NSNotification *)notification {
	//[self showActionsMenu];
}

- (void) update {
	//[sourceListView deselectAll:nil];
	//if(![self superview]) return;
	
	if(branchesItem) {
		wasBranchesExpanded = [sourceListView isItemExpanded:branchesItem];
		GDRelease(branchesItem);
	}
	if(tagsItem) {
		wasTagsExpanded = [sourceListView isItemExpanded:tagsItem];
		GDRelease(tagsItem);
	}
	if(subsItem) {
		wasSubmodulesExpanded = [sourceListView isItemExpanded:subsItem];
		GDRelease(subsItem);
	}
	if(stashItem) {
		wasStashExpanded = [sourceListView isItemExpanded:stashItem];
		GDRelease(stashItem);
	}
	if(remotesItem) {
		wasRemotesExpanded = [sourceListView isItemExpanded:remotesItem];
		GDRelease(remotesItem);
	}
	if(remoteBranchesItem) {
		wasRemoteBranchesExpanded = [sourceListView isItemExpanded:remoteBranchesItem];
		GDRelease(remoteBranchesItem);
	}
	
	GTSourceListItem * item;
	if(rootItem) {
		[rootItem releaseTree];
		GDRelease(rootItem);
	}
	rootItem=[[GTSourceListItem alloc] init];
	[rootItem setIsGroupItem:true];
	NSInteger remotesCount = [[gitd remotes] count];
	NSIndexSet * selected = [[sourceListView selectedRowIndexes] retain];
	
	if([[gitd branchNames] count] > 0) {
		branches = [gitd branchNames];
		branchesItem = [[GTSourceListItem alloc] init];
		[branchesItem setIsGroupItem:true];
		[branchesItem setName:@"branches" andLabel:@"branches"];
		NSString * branch;
		for(branch in branches) {
			item = [[GTSourceListItem alloc] init];
			if([branch isEqual:[gitd activeBranchName]]) [item setName:branch andLabel:branch];
			else [item setName:branch andLabel:branch];
			[branchesItem addChild:item];
			[item release];
			item = nil;
		}
		[rootItem addChild:branchesItem];
	}
	
	if([[gitd remoteTrackingBranches] count] > 0) {
		NSMutableArray * remoteTrackingBranches = [gitd remoteTrackingBranches];
		remoteBranchesItem = [[GTSourceListItem alloc] init];
		[remoteBranchesItem setIsGroupItem:true];
		[remoteBranchesItem setName:@"remote_branches" andLabel:@"Remote Branches"];
		NSString * rb;
		for(rb in remoteTrackingBranches) {
			item = [[[GTSourceListItem alloc] init] autorelease];
			[item setName:rb andLabel:rb];
			[remoteBranchesItem addChild:item];
			item=nil;
		}
		[rootItem addChild:remoteBranchesItem];
	}
	
	if([[gitd tagNames] count] > 0) {
		NSMutableArray * tags = [gitd tagNames];
		tagsItem = [[GTSourceListItem alloc] init];
		[tagsItem setIsGroupItem:true];
		[tagsItem setName:@"tags" andLabel:@"tags"];
		NSString * tag;
		for(tag in tags) {
			item = [[[GTSourceListItem alloc] init] autorelease];
			[item setName:tag andLabel:tag];
			[tagsItem addChild:item];
			item=nil;
		}
		[rootItem addChild:tagsItem];
	}
	
	if(remotesCount > 0) {
		NSMutableArray * remotes = [gitd remoteNames];
		remotesItem = [[GTSourceListItem alloc] init];
		[remotesItem setIsGroupItem:true];
		[remotesItem setName:@"remotes" andLabel:@"remotes"];
		NSString * remote;
		for(remote in remotes) {
			item = [[[GTSourceListItem alloc] init] autorelease];
			[item setName:remote andLabel:remote];
			[remotesItem addChild:item];
			item = nil;
		}
		[rootItem addChild:remotesItem];
	}
	
	if([[gitd submodules] count] > 0) {
		NSMutableArray * subs = [gitd submodules];
		subsItem = [[GTSourceListItem alloc] init];
		[subsItem setIsGroupItem:true];
		[subsItem setName:@"submodules" andLabel:@"submodules"];
		NSMutableDictionary * sub;
		NSString * name;
		//NSString * fullspec;
		short c = 0;
		for(sub in subs) {
			name=[sub objectForKey:@"name"];
			//fullspec=[sub objectForKey:@"spec"];
			item=[[[GTSourceListItem alloc] init] autorelease];
			[item setIndex:c];
			[item setName:name andLabel:name];
			[item setData:sub];
			[subsItem addChild:item];
			item=nil;
			c++;
		}
		[rootItem addChild:subsItem];
	}
	
	if([[gitd savedStashes] count] > 0) {
		NSMutableArray * stashes = [gitd savedStashes];
		stashItem = [[GTSourceListItem alloc] init];
		[stashItem setIsGroupItem:true];
		[stashItem setName:@"stash" andLabel:@"stash"];
		NSMutableDictionary * stash;
		NSString * name;
		short c = 0;
		for(stash in stashes) {
			name = [stash objectForKey:@"name"];
			item = [[[GTSourceListItem alloc] init] autorelease];
			[item setIndex:c];
			[item setName:name andLabel:name];
			[item setData:stash];
			[stashItem addChild:item];
			c++;
			item=nil;
		}
		[rootItem addChild:stashItem];
	}
	
	[sourceListView reloadData];
	if(branchesItem and (wasBranchesExpanded || missingDefaultsExpandState)) [sourceListView expandItem:branchesItem expandChildren:true];
	if(remotesItem and (wasRemotesExpanded || missingDefaultsExpandState)) [sourceListView expandItem:remotesItem expandChildren:true];
	if(tagsItem and (wasTagsExpanded || missingDefaultsExpandState)) [sourceListView expandItem:tagsItem expandChildren:true];
	if(stashItem and (wasStashExpanded || missingDefaultsExpandState)) [sourceListView expandItem:stashItem expandChildren:true];
	if(subsItem and (wasSubmodulesExpanded || missingDefaultsExpandState)) [sourceListView expandItem:subsItem expandChildren:true];
	if(remoteBranchesItem and (wasRemoteBranchesExpanded || missingDefaultsExpandState)) [sourceListView expandItem:remoteBranchesItem expandChildren:true];
	
	//[sourceListView expandItem:nil expandChildren:true];
	item=[sourceListView itemAtRow:[selected firstIndex]];
	if(![item isGroupItem]) {
		wasJustUpdated=true;
		[sourceListView selectRowIndexes:selected byExtendingSelection:false];
		wasJustUpdated=false;
	} else [sourceListView deselectAll:nil];
	
	item=nil;
	missingDefaultsExpandState=false;
	[selected release];
}

- (void) removeObservers {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResizeNotification object:[gd gtwindow]];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTSourceListView\n");
	#endif
	if(rootItem) {
		[rootItem releaseTree];
		GDRelease(rootItem);
	}
	if(branchesItem) {
		wasBranchesExpanded = [sourceListView isItemExpanded:branchesItem];
		GDRelease(branchesItem);
	}
	if(tagsItem) {
		wasTagsExpanded = [sourceListView isItemExpanded:tagsItem];
		GDRelease(tagsItem);
	}
	if(subsItem) {
		wasSubmodulesExpanded = [sourceListView isItemExpanded:subsItem];
		GDRelease(subsItem);
	}
	if(stashItem) {
		wasStashExpanded = [sourceListView isItemExpanded:stashItem];
		GDRelease(stashItem);
	}
	if(remotesItem) {
		wasRemotesExpanded = [sourceListView isItemExpanded:remotesItem];
		GDRelease(remotesItem);
	}
	if(remoteBranchesItem) {
		wasRemoteBranchesExpanded = [sourceListView isItemExpanded:remoteBranchesItem];
		GDRelease(remoteBranchesItem);
	}
	GDRelease(_tmpItemForExport);
	GDRelease(gitProjectPath);
	[super dealloc];
}

@end
