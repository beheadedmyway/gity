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

#import "GTContextMenuController.h"
#import "GittyDocument.h"
#import "GTDocumentController.h"
#import "GTDiffBarDiffStateView.h"
#import "GTSplitContentView.h"
#import "GTSourceListView.h"
#import "GTDiffBarDiffStateView.h"
#import "GTActiveBranchView.h"

@implementation GTContextMenuController
@synthesize actionsMenu;
@synthesize activeBranchActionsMenu;
@synthesize branchActionsMenu;
@synthesize leftDiffSelectorMenu;
@synthesize remoteBranchesMenu;
@synthesize remotesMenu;
@synthesize rightDiffSelectorMenu;
@synthesize stashMenu;
@synthesize submodulesMenu;
@synthesize tagsMenu;

- (id) initWithGD:(GittyDocument *) _gd {
	self=[super initWithGD:_gd];
	[self initActiveBranchMenuItems];
	[self initActiveBranchMenu];
	[self initBranchActionItems];
	[self initBranchActionsMenu];
	[self initStashItems];
	[self initStashMenu];
	[self initRemotesItems];
	[self initRemotesMenu];
	[self initTagsItems];
	[self initTagsMenu];
	[self initActionsMenuItems];
	[self initActionsMenu];
	[self initSubmodulesMenuItems];
	[self initSubmodulesMenu];
	[self initLeftDiffSelectorMenuItems];
	[self initLeftDiffSelectorMenu];
	[self initRightDiffSelectorMenuItems];
	[self initRightDiffSelectorMenu];
	[self initRemoteBranchesItems];
	[self initRemoteBranchesMenu];
	return self;
}

- (void) setRefs {
	[super setRefs];
	sourceListView=[gd sourceListView];
	splitContentView=[gd splitContentView];
	diffView=[gd diffView];
	diffStateView=[[[gd diffView] diffBarView] diffStateView];
	activeBranchView=[gd activeBranchView];
}

- (void) updateActionsMenuDelegate {
	[actionsMenu setDelegate:[[sourceListView sourceListMenuView] actionsMenuDelegate]];
}

- (void) invalidate {
	[self invalidateActiveBranchViewMenus];
	[self invalidateBranchesSourceListMenus];
	[self invalidateSourceListActionsMenu];
	[self invalidateTagsSourceListMenu];
}

- (void) initLeftDiffSelectorMenu {
	leftDiffSelectorMenu = [[NSMenu alloc] init];
	[leftDiffSelectorMenu setDelegate:diffStateView];
	[leftDiffSelectorMenu addItem:leftDiffPWD];
	[leftDiffSelectorMenu addItem:leftDiffStage];
	[leftDiffSelectorMenu addItem:leftDiffHEAD];
	[leftDiffSelectorMenu addItem:leftDiffCommit];
}

- (void) initLeftDiffSelectorMenuItems {
	leftDiffPWD = [[NSMenuItem alloc] init];
	[leftDiffPWD setTitle:@"Working"];
	[leftDiffPWD setTarget:diffStateView];
	[leftDiffPWD setAction:@selector(leftDiffSelectorPWDSelected:)];
	
	leftDiffStage = [[NSMenuItem alloc] init];
	[leftDiffStage setTitle:@"Stage"];
	[leftDiffStage setTarget:diffStateView];
	[leftDiffStage setAction:@selector(leftDiffSelectorStageSelected:)];
	
	leftDiffHEAD = [[NSMenuItem alloc] init];
	[leftDiffHEAD setTitle:@"Head"];
	[leftDiffHEAD setTarget:diffStateView];
	[leftDiffHEAD setAction:@selector(leftDiffSelectorHEADSelected:)];
	
	leftDiffCommit = [[NSMenuItem alloc] init];
	[leftDiffCommit setTitle:@"Commit..."];
	[leftDiffCommit setTarget:diffStateView];
	[leftDiffCommit setAction:@selector(leftDiffSelectorCommitSelected:)];
}

- (void) initRightDiffSelectorMenu {
	rightDiffSelectorMenu = [[NSMenu alloc] init];
	[rightDiffSelectorMenu setDelegate:diffStateView];
	[rightDiffSelectorMenu addItem:rightDiffPWD];
	[rightDiffSelectorMenu addItem:rightDiffStage];
	[rightDiffSelectorMenu addItem:rightDiffHEAD];
	[rightDiffSelectorMenu addItem:rightDiffCommit];
}

- (void) initRightDiffSelectorMenuItems {
	rightDiffPWD = [[NSMenuItem alloc] init];
	[rightDiffPWD setTitle:@"Working"];
	[rightDiffPWD setTarget:diffStateView];
	[rightDiffPWD setAction:@selector(rightDiffSelectorPWDSelected:)];
	
	rightDiffStage = [[NSMenuItem alloc] init];
	[rightDiffStage setTitle:@"Stage"];
	[rightDiffStage setTarget:diffStateView];
	[rightDiffStage setAction:@selector(rightDiffSelectorStageSelected:)];
	
	rightDiffHEAD = [[NSMenuItem alloc] init];
	[rightDiffHEAD setTitle:@"Head"];
	[rightDiffHEAD setTarget:diffStateView];
	[rightDiffHEAD setAction:@selector(rightDiffSelectorHEADSelected:)];
	
	rightDiffCommit = [[NSMenuItem alloc] init];
	[rightDiffCommit setTitle:@"Commit..."];
	[rightDiffCommit setTarget:diffStateView];
	[rightDiffCommit setAction:@selector(rightDiffSelectorCommitSelected:)];
}

- (void) invalidateRightDiffSelectorMenu {
	/*[rightDiffSelectorMenu removeAllItems];
	GTDiffBarDiffStateView * dv = [[[gd diffView] diffBarView] diffStateView];
	if([dv isLeftSelectorOnWorking]) {
		[rightDiffSelectorMenu addItem:rightDiffStage];
		[rightDiffSelectorMenu addItem:rightDiffHEAD];
		[rightDiffSelectorMenu addItem:rightDiffCommit];
	}
	if([dv isLeftSelectorOnStage]) {
		[rightDiffSelectorMenu addItem:rightDiffHEAD];
		[rightDiffSelectorMenu addItem:rightDiffCommit];
	}
	if([dv isLeftSelectorOnHead]) {
		[rightDiffSelectorMenu addItem:rightDiffCommit];
	}*/
}

- (void) invalidateLeftDiffSelector {
}

- (void) initRemoteBranchesMenu {
	remoteBranchesMenu = [[NSMenu alloc] init];
	[remoteBranchesMenu addItem:rbFetchItem];
	[remoteBranchesMenu addItem:rbMergeItem];
	[remoteBranchesMenu addItem:rbHistoryItem];
}

- (void) initRemoteBranchesItems {
	rbFetchItem=[[NSMenuItem alloc] init];
	[rbFetchItem setTitle:@"Fetch"];
	[rbFetchItem setTarget:sourceListView];
	[rbFetchItem setAction:@selector(remoteBranchFetch:)];
	[rbFetchItem setKeyEquivalent:@""];
	[rbFetchItem setKeyEquivalentModifierMask:(NSShiftKeyMask | NSControlKeyMask)];
	
	rbMergeItem=[[NSMenuItem alloc] init];
	[rbMergeItem setTitle:@"Merge"];
	[rbMergeItem setTarget:sourceListView];
	[rbMergeItem setAction:@selector(remoteBranchMerge:)];
	[rbMergeItem setKeyEquivalent:@"m"];
	[rbMergeItem setKeyEquivalentModifierMask:(NSShiftKeyMask | NSCommandKeyMask)];
	
	rbHistoryItem = [[NSMenuItem alloc] init];
	[rbHistoryItem setTitle:@"History"];
	[rbHistoryItem setTarget:sourceListView];
	[rbHistoryItem setAction:@selector(loadHistoryFromRef:)];
}

- (NSMenu *) remoteBranchesMenu {
	if([gitd isHeadDetatched]) [rbMergeItem setEnabled:false];
	else [rbMergeItem setTitle:[@"Merge into " stringByAppendingString:[gitd activeBranchName]]];
	return remoteBranchesMenu;
}

- (void) invalidateActiveBranchViewMenus {
	[gitAddItem setEnabled:true];
	[gitDestageItem setEnabled:true];
	[gitAddAndCommitItem setEnabled:true];
	[gitRemoveItem setEnabled:true];
	[gitDiscardChangesItem setEnabled:true];
	if([gd isCurrentViewActiveBranchView]) {
		[openInFinder setEnabled:false];
		[openContainerInFinder setEnabled:false];
		[moveToTrash setEnabled:true];
		[gitIgnoreItem setEnabled:false];
		[gitIgnoreContainer setEnabled:false];
		[gitIgnoreExension setEnabled:false];
		if([activeBranchView selectedFilesCount] == 1) {
			[gitIgnoreExension setEnabled:true];
			NSString * ext = [activeBranchView getSelectedFileExtension];
			if(![ext isEqual:@""]) [gitIgnoreExension setTitle:[NSString stringWithFormat:@"Ignore Files With Extension (.%@)",ext]];
			else [gitIgnoreExension setEnabled:false];
			if([activeBranchView isSelectedFileAConflictedFile]) [gitMergeTool setEnabled:true];
			else [gitMergeTool setEnabled:false];
			[openInFinder setEnabled:true];
			[openContainerInFinder setEnabled:true];
			[gitIgnoreItem setEnabled:true];
			[gitIgnoreContainer setEnabled:true];
		}
	}
	if([gitd isHeadDetatched]) {
		[gitAddItem setEnabled:false];
		[gitDestageItem setEnabled:false];
		[gitAddAndCommitItem setEnabled:false];
		[gitRemoveItem setEnabled:false];
		[gitDiscardChangesItem setEnabled:false];
	}
}

- (void) invalidateSourceListActionsMenu {
	NSMutableArray * remotes = [gitd remoteNames];
	if([gitd isDirty]) {
		[newStash setEnabled:true];
		[branchReset setEnabled:true];
		[branchDiscardNonStagedChanges setEnabled:true];
	} else {
		[newStash setEnabled:false];
		[branchReset setEnabled:false];
		[branchDiscardNonStagedChanges setEnabled:false];
	}
	
	if([remotes count] < 1) {
		[newTrackingBranch setEnabled:false];
		[fetchTags setEnabled:false];
	} else {
		[newTrackingBranch setEnabled:true];
		[fetchTags setEnabled:true];
	}
	
	if([gitd isHeadDetatched]) {
		[newBranch setEnabled:false];
		[newTag setEnabled:false];
		[newSubmodule setEnabled:false];
		[newEmptyBranch setEnabled:false];
		[newStash setEnabled:false];
		[branchReset setEnabled:false];
		[branchDiscardNonStagedChanges setEnabled:false];
	} else {
		[newBranch setEnabled:true];
		[newTag setEnabled:true];
		[newSubmodule setEnabled:true];
		[newEmptyBranch setEnabled:true];
	}
}

- (void) invalidateBranchesSourceListMenus {
	NSMutableArray * remotes = [gitd remoteNames];
	NSString * remote;
	NSMenuItem * item;
	
	[pushToMenu removeAllItems];
	for(remote in remotes) {
		item = [[NSMenuItem alloc] init];
		[item setTitle:remote];
		[pushToMenu addItem:item];
		[item setTarget:sourceListView];
		[item setAction:@selector(gitPushTo:)];
		[item release];
		item = nil;
	}
	
	[pullFromMenu removeAllItems];
	for(remote in remotes) {
		item = [[NSMenuItem alloc] init];
		[item setTitle:remote];
		[pullFromMenu addItem:item];
		[item setTarget:sourceListView];
		[item setAction:@selector(gitPullFrom:)];
		[item release];
		item = nil;
	}
	
	[branchDeleteAtMenu removeAllItems];
	for(remote in remotes) {
		item = [[NSMenuItem alloc] init];
		[item setTitle:remote];
		[branchDeleteAtMenu addItem:item];
		[item setTarget:sourceListView];
		[item setAction:@selector(branchDeleteAt:)];
		[item release];
		item = nil;
	}
	
	NSString * branch = [sourceListView selectedItemLowercaseName];
	NSString * dr = [gitd defaultRemoteForBranch:branch];
	[defaultRemoteMenu removeAllItems];
	for(remote in remotes) {
		item = [[NSMenuItem alloc] init];
		[item setTitle:remote];
		if([dr isEqual:remote]) [item setState:NSOnState];
		[defaultRemoteMenu addItem:item];
		[item setTarget:sourceListView];
		[item setAction:@selector(updateDefaultRemote:)];
		[item release];
		item = nil;
	}
	
	if([sourceListView isSelectedItemActiveBranch]) {
		[branchCheckout setEnabled:false];
		[branchMerge setEnabled:false];
		[branchDelete setEnabled:false];
		[terminalItem setEnabled:true];
	} else {
		[branchCheckout setEnabled:true];
		[branchMerge setEnabled:true];
		[branchDelete setEnabled:true];
		[terminalItem setEnabled:false];
	}
	
	if([remotes count] < 1) {
		[self disablePushAndPull];
		[self disableDeleteAt];
	} else {
		[self enablePushAndPull];
		[self enableDeleteAt];
	}
	
	if([sourceListView isSelectedItemActiveBranch]) {
		[branchDeleteAtItem setEnabled:false];
	} else {
		[branchDeleteAtItem setEnabled:true];
	}
	
	if([remotes count] < 1) {
		[branchDeleteAtItem setEnabled:false];
		[tagsDeleteAtItem setEnabled:false];
	}
	
	if([gitd isHeadDetatched]) {
		[branchMerge setEnabled:false];
		[pushItem setEnabled:false];
		[pullItem setEnabled:false];
		[rebasePull setEnabled:false];
		[branchDelete setEnabled:false];
		[branchDeleteAtItem setEnabled:false];
	}
}

- (void) invalidateTagsSourceListMenu {
	NSMutableArray * remotes = [gitd remoteNames];
	NSString * remote;
	NSMenuItem * item;
	
	[tagsPushToMenu removeAllItems];
	for(remote in remotes) {
		item = [[[NSMenuItem alloc] init] autorelease];
		[item setTitle:remote];
		[item setTarget:sourceListView];
		[item setAction:@selector(gitPushTagTo:)];
		[tagsPushToMenu addItem:item];
		item = nil;
	}
	
	[tagsDeleteAtMenu removeAllItems];
	for(remote in remotes) {
		item = [[[NSMenuItem alloc] init] autorelease];
		[item setTitle:remote];
		[item setTarget:sourceListView];
		[item setAction:@selector(tagDeleteAt:)];
		[tagsDeleteAtMenu addItem:item];
		item = nil;
	}
	
	if([remotes count] < 1) [tagsPush setEnabled:false];
}

- (void) disablePushAndPull {
	[pushTo setEnabled:false];
	[pushItem setEnabled:false];
	[pullItem setEnabled:false];
	[pullFrom setEnabled:false];
	[defaultRemote setEnabled:false];
	[rebasePull setEnabled:false];
}

- (void) enablePushAndPull {
	[pushTo setEnabled:true];
	[pushItem setEnabled:true];
	[pullItem setEnabled:true];
	[pullFrom setEnabled:true];
	[defaultRemote setEnabled:true];
	[rebasePull setEnabled:true];
}

- (void) enableDeleteAt {
	[branchDeleteAtItem setEnabled:true];
}

- (void) disableDeleteAt {
	[branchDeleteAtItem setEnabled:false];
}

- (NSMenu *) branchActionsMenu {
	[branchActionsMenu removeAllItems];
	[branchActionsMenu setAutoenablesItems:false];
	if([gitd activeBranchName]) [branchMerge setTitle:[@"Merge" stringByAppendingFormat:@" into %@",[gitd activeBranchName]]];
	if([sourceListView isSelectedItemActiveBranch]) {
		[branchActionsMenu addItem:branchCheckout];
		[branchActionsMenu addItem:branchMerge];
		[branchActionsMenu addItem:[NSMenuItem separatorItem]];
		[branchActionsMenu addItem:pushItem];
		[branchActionsMenu addItem:pushTo];
		[branchActionsMenu addItem:[NSMenuItem separatorItem]];
		[branchActionsMenu addItem:pullItem];
		[branchActionsMenu addItem:rebasePull];
		[branchActionsMenu addItem:pullFrom];
		[branchActionsMenu addItem:[NSMenuItem separatorItem]];
		[branchActionsMenu addItem:defaultRemote];
		[branchActionsMenu addItem:[NSMenuItem separatorItem]];
		[branchActionsMenu addItem:branchHistoryItem];
		[branchActionsMenu addItem:[NSMenuItem separatorItem]];
		[branchActionsMenu addItem:branchNewBranchFromThis];
		[branchActionsMenu addItem:branchTagFromHead];
		[branchActionsMenu addItem:[NSMenuItem separatorItem]];
		[branchActionsMenu addItem:branchExportZip];
		[branchActionsMenu addItem:branchExportTar];
		[branchActionsMenu addItem:[NSMenuItem separatorItem]];
		[branchActionsMenu addItem:terminalItem];
		[branchActionsMenu addItem:[NSMenuItem separatorItem]];
		[branchActionsMenu addItem:branchDelete];
		[branchActionsMenu addItem:branchDeleteAtItem];
		[branchActionsMenu update];
	} else {
		[branchActionsMenu addItem:branchCheckout];
		[branchActionsMenu addItem:branchMerge];
		[branchActionsMenu addItem:[NSMenuItem separatorItem]];
		[branchActionsMenu addItem:pushItem];
		[branchActionsMenu addItem:pushTo];
		/*[branchActionsMenu addItem:[NSMenuItem separatorItem]];
		[branchActionsMenu addItem:pullItem];
		[branchActionsMenu addItem:rebasePull];
		[branchActionsMenu addItem:pullFrom];*/
		[branchActionsMenu addItem:[NSMenuItem separatorItem]];
		[branchActionsMenu addItem:defaultRemote];
		[branchActionsMenu addItem:[NSMenuItem separatorItem]];
		[branchActionsMenu addItem:branchHistoryItem];
		[branchActionsMenu addItem:[NSMenuItem separatorItem]];
		[branchActionsMenu addItem:branchNewBranchFromThis];
		[branchActionsMenu addItem:branchTagFromHead];
		[branchActionsMenu addItem:[NSMenuItem separatorItem]];
		[branchActionsMenu addItem:branchExportZip];
		[branchActionsMenu addItem:branchExportTar];
		[branchActionsMenu addItem:[NSMenuItem separatorItem]];
		[branchActionsMenu addItem:terminalItem];
		[branchActionsMenu addItem:[NSMenuItem separatorItem]];
		[branchActionsMenu addItem:branchDelete];
		[branchActionsMenu addItem:branchDeleteAtItem];
		[branchActionsMenu update];
	}
	return branchActionsMenu;
}

- (void) initSubmodulesMenu {
	submodulesMenu=[[NSMenu alloc] init];
	
	[submodulesMenu addItem:subsPull];
	[submodulesMenu addItem:subsUpdate];
	[submodulesMenu addItem:subsSync];
	[submodulesMenu addItem:subsDelete];
	[submodulesMenu addItem:[NSMenuItem separatorItem]];
	[submodulesMenu addItem:subsOpenWithGitty];
}

- (void) initSubmodulesMenuItems {
	subsUpdate = [[NSMenuItem alloc] init];
	[subsUpdate setTitle:@"Update"];
	[subsUpdate setTarget:sourceListView];
	[subsUpdate setAction:@selector(gitSubmoduleUpdate:)];
	
	subsSync = [[NSMenuItem alloc] init];
	[subsSync setTitle:@"Sync"];
	[subsSync setTarget:sourceListView];
	[subsSync setAction:@selector(gitSubmoduleSync:)];
	
	subsPush = [[NSMenuItem alloc] init];
	[subsPush setTitle:@"Push"];
	[subsPush setTarget:sourceListView];
	[subsPush setAction:@selector(gitSubmodulePush:)];
	
	subsPull = [[NSMenuItem alloc] init];
	[subsPull setTitle:@"Pull"];
	[subsPull setTarget:sourceListView];
	[subsPull setAction:@selector(gitSubmodulePull:)];
	
	subsOpenWithGitty = [[NSMenuItem alloc] init];
	[subsOpenWithGitty setTitle:@"Open With Gity"];
	[subsOpenWithGitty setTarget:sourceListView];
	[subsOpenWithGitty setAction:@selector(openSubmoduleWithGity:)];
	
	subsDelete = [[NSMenuItem alloc] init];
	[subsDelete setTitle:@"Delete"];
	[subsDelete setTarget:sourceListView];
	[subsDelete setAction:@selector(gitDeleteSub:)];
}

- (void) initActionsMenu {
	actionsMenu = [[NSMenu alloc] init];
	[actionsMenu setAutoenablesItems:false];
	[actionsMenu addItem:newBranch];
	[actionsMenu addItem:newEmptyBranch];
	[actionsMenu addItem:newTrackingBranch];
	[actionsMenu addItem:[NSMenuItem separatorItem]];
	[actionsMenu addItem:newTag];
	[actionsMenu addItem:fetchTags];
	[actionsMenu addItem:[NSMenuItem separatorItem]];
	[actionsMenu addItem:newRemoteActionsItem];
	[actionsMenu addItem:[NSMenuItem separatorItem]];
	[actionsMenu addItem:newSubmodule];
	[actionsMenu addItem:[NSMenuItem separatorItem]];
	[actionsMenu addItem:newStash];
	[actionsMenu addItem:branchDiscardNonStagedChanges];
	[actionsMenu addItem:branchReset];
}

- (void) initActionsMenuItems {
	newBranch = [[NSMenuItem alloc] init];
	[newBranch setTitle:@"New Branch..."];
	[newBranch setKeyEquivalent:@"b"];
	[newBranch setKeyEquivalentModifierMask:(NSShiftKeyMask | NSCommandKeyMask)];
	[newBranch setTarget:gd];
	[newBranch setAction:@selector(gitNewBranchFromActiveBranch:)];
	
	newTag = [[NSMenuItem alloc] init];
	[newTag setTitle:@"New Tag..."];
	[newTag setKeyEquivalent:@"t"];
	[newTag setKeyEquivalentModifierMask:(NSShiftKeyMask | NSCommandKeyMask)];
	[newTag setTarget:gd];
	[newTag setAction:@selector(gitNewTagFromActiveBranch:)];
	
	newRemoteActionsItem = [[NSMenuItem alloc] init];
	[newRemoteActionsItem setTitle:@"New Remote..."];
	[newRemoteActionsItem setTarget:gd];
	[newRemoteActionsItem setAction:@selector(gitNewRemote:)];
	[newRemoteActionsItem setKeyEquivalent:@"r"];
	[newRemoteActionsItem setKeyEquivalentModifierMask:(NSShiftKeyMask | NSCommandKeyMask)];
	
	newBranchFromCommit = [[NSMenuItem alloc] init];
	[newBranchFromCommit setTitle:@"New Branch From Commit..."];
	[newBranchFromCommit setKeyEquivalent:@"b"];
	[newBranchFromCommit setKeyEquivalentModifierMask:(NSAlternateKeyMask)];
	[newBranchFromCommit setEnabled:false];
	
	newTagFromCommit = [[NSMenuItem alloc] init];
	[newTagFromCommit setTitle:@"New Tag From Commit..."];
	[newTagFromCommit setKeyEquivalent:@"t"];
	[newTagFromCommit setKeyEquivalentModifierMask:NSAlternateKeyMask];
	[newTagFromCommit setEnabled:false];
	
	newTrackingBranch = [[NSMenuItem alloc] init];
	[newTrackingBranch setTitle:@"New Tracking Branch..."];
	[newTrackingBranch setTarget:gd];
	[newTrackingBranch setAction:@selector(newRemoteTrackingBranch:)];
	[newTrackingBranch setKeyEquivalent:@"w"];
	[newTrackingBranch setKeyEquivalentModifierMask:(NSCommandKeyMask | NSShiftKeyMask)];
	
	newStash = [[NSMenuItem alloc] init];
	[newStash setTitle:@"Stash Local Changes..."];
	[newStash setTarget:gd];
	[newStash setAction:@selector(gitStashLocalChanges:)];
	
	newEmptyBranch = [[NSMenuItem alloc] init];
	[newEmptyBranch setTitle:@"New Empty Branch..."];
	[newEmptyBranch setTarget:gd];
	[newEmptyBranch setAction:@selector(gitNewEmptyBranch:)];
	[newEmptyBranch setKeyEquivalent:@"y"];
	[newEmptyBranch setKeyEquivalentModifierMask:(NSCommandKeyMask | NSShiftKeyMask)];
	
	exportArchiveCommit = [[NSMenuItem alloc] init];
	[exportArchiveCommit setTitle:@"Export Archive From Commit..."];
	[exportArchiveCommit setKeyEquivalent:@"k"];
	[exportArchiveCommit setKeyEquivalentModifierMask:NSAlternateKeyMask];
	[exportArchiveCommit setEnabled:false];
	
	fetchTags = [[NSMenuItem alloc] init];
	[fetchTags setTitle:@"Fetch Tags..."];
	[fetchTags setKeyEquivalent:@"t"];
	[fetchTags setKeyEquivalentModifierMask:(NSShiftKeyMask | NSAlternateKeyMask)];
	[fetchTags setTarget:gd];
	[fetchTags setAction:@selector(gitFetchTags:)];
	
	branchReset = [[NSMenuItem alloc] init];
	[branchReset setTitle:@"Hard Reset to Head"];
	[branchReset setAction:@selector(branchHardReset:)];
	[branchReset setTarget:sourceListView];
	
	branchDiscardNonStagedChanges = [[NSMenuItem alloc] init];
	[branchDiscardNonStagedChanges setTitle:@"Discard Non-Staged Changes"];
	[branchDiscardNonStagedChanges setAction:@selector(branchDiscardNonStagedChanges:)];
	[branchDiscardNonStagedChanges setTarget:sourceListView];
	
	newSubmodule = [[NSMenuItem alloc] init];
	[newSubmodule setTitle:@"New Submodule..."];
	[newSubmodule setTarget:gd];
	[newSubmodule setAction:@selector(gitNewSubmodule:)];
	[newSubmodule setKeyEquivalent:@"s"];
	[newSubmodule setKeyEquivalentModifierMask:(NSShiftKeyMask | NSCommandKeyMask)];
}

- (void) initTagsMenu {
	tagsMenu = [[NSMenu alloc] init];
	[tagsDeleteAtItem setSubmenu:tagsDeleteAtMenu];
	[tagsMenu addItem:tagsPush];
	[tagsMenu addItem:[NSMenuItem separatorItem]];
	[tagsMenu addItem:tagHistoryItem];
	[tagsMenu addItem:[NSMenuItem separatorItem]];
	[tagsMenu addItem:exportZip];
	[tagsMenu addItem:exportTar];
	[tagsMenu addItem:[NSMenuItem separatorItem]];
	[tagsMenu addItem:tagsDelete];
	[tagsMenu addItem:tagsDeleteAtItem];
	[tagsMenu setAutoenablesItems:false];
}

- (void) initTagsItems {
	tagsPushToMenu = [[NSMenu alloc] init];
	tagsDeleteAtMenu = [[NSMenu alloc] init];
	[tagsDeleteAtMenu setAutoenablesItems:false];
	
	tagsDelete = [[NSMenuItem alloc] init];
	[tagsDelete setTitle:@"Delete"];
	[tagsDelete setTarget:sourceListView];
	[tagsDelete setAction:@selector(tagDelete:)];
	
	exportZip = [[NSMenuItem alloc] init];
	[exportZip setTitle:@"Export ZIP..."];
	[exportZip setTarget:sourceListView];
	[exportZip setAction:@selector(gitExportZip)];
	
	exportTar = [[NSMenuItem alloc] init];
	[exportTar setTitle:@"Export TAR..."];
	[exportTar setTarget:sourceListView];
	[exportTar setAction:@selector(gitExportTar)];
	
	tagsPush = [[NSMenuItem alloc] init];
	[tagsPush setTitle:@"Push To"];
	[tagsPush setSubmenu:tagsPushToMenu];
	
	tagsDeleteAtItem = [[NSMenuItem alloc] init];
	[tagsDeleteAtItem setTitle:@"Delete At"];
	
	tagHistoryItem = [[NSMenuItem alloc] init];
	[tagHistoryItem setTitle:@"History"];
	[tagHistoryItem setTarget:sourceListView];
	[tagHistoryItem setAction:@selector(loadHistoryFromRef:)];
}

- (void) initRemotesMenu {
	remotesMenu = [[NSMenu alloc] init];
	[remotesMenu addItem:remotesDelete];
	[remotesMenu setAutoenablesItems:false];
}

- (void) initRemotesItems {
	remotesDelete = [[NSMenuItem alloc] init];
	[remotesDelete setTitle:@"Delete"];
	[remotesDelete setTarget:sourceListView];
	[remotesDelete setAction:@selector(remoteDelete:)];
}

- (void) initStashMenu {
	stashMenu = [[NSMenu alloc] init];
	[stashMenu addItem:stashApply];
	[stashMenu addItem:stashPop];
	[stashMenu addItem:stashDrop];
	[stashMenu setAutoenablesItems:false];
}

- (void) initStashItems {
	stashApply = [[NSMenuItem alloc] init];
	[stashApply setTitle:@"Apply (But Don't Delete)"];
	[stashApply setTarget:sourceListView];
	[stashApply setAction:@selector(stashApply:)];
	
	stashPop = [[NSMenuItem alloc] init];
	[stashPop setTitle:@"Pop (Apply and Delete)"];
	[stashPop setTarget:sourceListView];
	[stashPop setAction:@selector(stashPop:)];
	
	stashDrop = [[NSMenuItem alloc] init];
	[stashDrop setTitle:@"Delete"];
	[stashDrop setTarget:sourceListView];
	[stashDrop setAction:@selector(stashDelete:)];
}

- (void) initBranchActionsMenu {
	branchActionsMenu = [[NSMenu alloc] init];
	[branchActionsMenu setDelegate:sourceListView];
	[defaultRemote setSubmenu:defaultRemoteMenu];
	[branchDeleteAtItem setSubmenu:branchDeleteAtMenu];
	[branchActionsMenu addItem:branchCheckout];
	[branchActionsMenu addItem:branchMerge];
	[branchActionsMenu addItem:[NSMenuItem separatorItem]];
	[branchActionsMenu addItem:pushItem];
	[branchActionsMenu addItem:pushTo];
	[branchActionsMenu addItem:[NSMenuItem separatorItem]];
	[branchActionsMenu addItem:pullItem];
	[branchActionsMenu addItem:pullItemAlternate];
	[branchActionsMenu addItem:pullFrom];
	[branchActionsMenu addItem:[NSMenuItem separatorItem]];
	[branchActionsMenu addItem:defaultRemote];
	[branchActionsMenu addItem:[NSMenuItem separatorItem]];
	[branchActionsMenu addItem:branchHistoryItem];
	[branchActionsMenu addItem:[NSMenuItem separatorItem]];
	[branchActionsMenu addItem:branchNewBranchFromThis];
	[branchActionsMenu addItem:branchTagFromHead];
	[branchActionsMenu addItem:[NSMenuItem separatorItem]];
	[branchActionsMenu addItem:branchExportZip];
	[branchActionsMenu addItem:branchExportTar];
	[branchActionsMenu addItem:[NSMenuItem separatorItem]];
	[branchActionsMenu addItem:terminalItem];
	[branchActionsMenu addItem:[NSMenuItem separatorItem]];
	[branchActionsMenu addItem:branchDelete];
	[branchActionsMenu addItem:branchDeleteAtItem];
}

- (void) initBranchActionItems {
	pushToMenu = [[NSMenu alloc] init];
	pullFromMenu = [[NSMenu alloc] init];
	defaultRemoteMenu = [[NSMenu alloc] init];
	branchDeleteAtMenu = [[NSMenu alloc] init];
	[branchDeleteAtMenu setAutoenablesItems:false];
	[defaultRemoteMenu setAutoenablesItems:false];
	
	pushItem = [[NSMenuItem alloc] init];
	[pushItem setTitle:@"Push"];
	[pushItem setAction:@selector(gitPush:)];
	[pushItem setTarget:sourceListView];
	[pushItem setKeyEquivalent:@""];
	[pushItem setKeyEquivalentModifierMask:(NSShiftKeyMask | NSCommandKeyMask)];
	
	pushTo = [[NSMenuItem alloc] init];
	[pushTo setTitle:@"Push To"];
	[pushTo setSubmenu:pushToMenu];
	
	pullItem = [[NSMenuItem alloc] init];
	[pullItem setTitle:@"Pull"];
	[pullItem setAction:@selector(gitPull:)];
	[pullItem setTarget:sourceListView];
	[pullItem setKeyEquivalent:@""];
	[pullItem setKeyEquivalentModifierMask:(NSShiftKeyMask | NSCommandKeyMask)];
	
	rebasePull = [[NSMenuItem alloc] init];
	[rebasePull setTitle:@"Pull With Rebase"];
	[rebasePull setAction:@selector(gitRebaseFrom:)];
	[rebasePull setTarget:sourceListView];
	[rebasePull setKeyEquivalent:@""];
	[rebasePull setKeyEquivalentModifierMask:(NSShiftKeyMask | NSCommandKeyMask | NSAlternateKeyMask)];
	
	pullItemAlternate = [[NSMenuItem alloc] init];
	[pullItemAlternate setTitle:@"Rebase"];
	[pullItemAlternate setAction:@selector(gitPull:)];
	[pullItemAlternate setTarget:sourceListView];
	[pullItemAlternate setKeyEquivalent:@""];
	[pullItemAlternate setKeyEquivalentModifierMask:(NSShiftKeyMask | NSCommandKeyMask | NSAlternateKeyMask)];
	[pullItemAlternate setAlternate:true];
	
	pullFrom = [[NSMenuItem alloc] init];
	[pullFrom setTitle:@"Pull From"];
	[pullFrom setSubmenu:pullFromMenu];
	
	branchDelete = [[NSMenuItem alloc] init];
	[branchDelete setTitle:@"Delete"];
	[branchDelete setAction:@selector(branchDelete:)];
	[branchDelete setTarget:sourceListView];
	
	branchRename = [[NSMenuItem alloc] init];
	[branchRename setTitle:@"Rename"];
	[branchRename setAction:@selector(branchRename:)];
	[branchRename setTarget:sourceListView];
	
	branchCheckout = [[NSMenuItem alloc] init];
	[branchCheckout setTitle:@"Checkout"];
	[branchCheckout setAction:@selector(branchCheckout:)];
	[branchCheckout setTarget:sourceListView];
	
	branchMerge = [[NSMenuItem alloc] init];
	[branchMerge setTitle:@"Merge"];
	[branchMerge setAction:@selector(branchMerge:)];
	[branchMerge setTarget:sourceListView];
	
	branchNewBranchFromThis = [[NSMenuItem alloc] init];
	[branchNewBranchFromThis setTitle:@"New Branch From Here..."];
	[branchNewBranchFromThis setTarget:sourceListView];
	[branchNewBranchFromThis setAction:@selector(branchNewBranchFromHere:)];
	
	branchTagFromHead = [[NSMenuItem alloc] init];
	[branchTagFromHead setTitle:@"New Tag From Here..."];
	[branchTagFromHead setTarget:sourceListView];
	[branchTagFromHead setAction:@selector(branchNewTag:)];
	
	branchExportZip = [[NSMenuItem alloc] init];
	[branchExportZip setTitle:@"Export ZIP..."];
	[branchExportZip setTarget:sourceListView];
	[branchExportZip setAction:@selector(gitExportZip)];
	
	branchExportTar = [[NSMenuItem alloc] init];
	[branchExportTar setTitle:@"Export TAR..."];
	[branchExportTar setTarget:sourceListView];
	[branchExportTar setAction:@selector(gitExportTar)];
	
	defaultRemote = [[NSMenuItem alloc] init];
	[defaultRemote setTitle:@"Default Remote"];
	[defaultRemote setSubmenu:defaultRemoteMenu];
	
	branchDeleteAtItem = [[NSMenuItem alloc] init];
	[branchDeleteAtItem setTitle:@"Delete At"];
	
	branchHistoryItem = [[NSMenuItem alloc] init];
	[branchHistoryItem setTitle:@"History"];
	[branchHistoryItem setTarget:sourceListView];
	[branchHistoryItem setAction:@selector(loadHistoryFromRef:)];
	
	terminalItem = [[NSMenuItem alloc] init];
	[terminalItem setTitle:@"Open With Terminal"];
	[terminalItem setAction:@selector(openInTerminal:)];
	[terminalItem setTarget:nil];
	
}

- (void) initActiveBranchMenu {
	activeBranchActionsMenu = [[NSMenu alloc] init];
	[activeBranchActionsMenu setAutoenablesItems:false];
	[activeBranchActionsMenu addItem:gitAddItem];
	[activeBranchActionsMenu addItem:gitAddAndCommitItem];
	[activeBranchActionsMenu addItem:gitDestageItem];
	[activeBranchActionsMenu addItem:gitDiscardChangesItem];
	[activeBranchActionsMenu addItem:gitRemoveItem];
	[activeBranchActionsMenu addItem:[NSMenuItem separatorItem]];
	[activeBranchActionsMenu addItem:gitMergeTool];
	[activeBranchActionsMenu addItem:[NSMenuItem separatorItem]];
	[activeBranchActionsMenu addItem:gitIgnoreItem];
	[activeBranchActionsMenu addItem:gitIgnoreExension];
	[activeBranchActionsMenu addItem:gitIgnoreContainer];
	[activeBranchActionsMenu addItem:[NSMenuItem separatorItem]];
	[activeBranchActionsMenu addItem:openFile];
	[activeBranchActionsMenu addItem:quickLook];
	[activeBranchActionsMenu addItem:openInFinder];
	[activeBranchActionsMenu addItem:openContainerInFinder];
	[activeBranchActionsMenu addItem:[NSMenuItem separatorItem]];
	[activeBranchActionsMenu addItem:moveToTrash];
	[activeBranchActionsMenu setDelegate:self];
}

- (void) initActiveBranchMenuItems {
	gitIgnoreContainer = [[NSMenuItem alloc] init];
	[gitIgnoreContainer setTitle:@"Ignore Containing Directory"];
	[gitIgnoreContainer setTarget:gd];
	[gitIgnoreContainer setAction:@selector(gitIgnoreDir:)];
	
	gitAddItem = [[NSMenuItem alloc] init];
	[gitAddItem setTitle:@"Add"];
	[gitAddItem setTarget:gd];
	[gitAddItem setAction:@selector(gitAdd:)];
	[gitAddItem setKeyEquivalentModifierMask:(NSAlternateKeyMask)];
	[gitAddItem setKeyEquivalent:@"a"];
	
	gitAddAndCommitItem = [[NSMenuItem alloc] init];
	[gitAddAndCommitItem setTitle:@"Add & Commit"];
	[gitAddAndCommitItem setTarget:gd];
	[gitAddAndCommitItem setAction:@selector(gitAddAndCommit:)];
	[gitAddAndCommitItem setKeyEquivalentModifierMask:(NSAlternateKeyMask)];
	[gitAddAndCommitItem setKeyEquivalent:@"x"];
	
	gitDestageItem = [[NSMenuItem alloc] init];
	[gitDestageItem setTitle:@"Destage"];
	[gitDestageItem setTarget:gd];
	[gitDestageItem setAction:@selector(gitDestage:)];
	[gitDestageItem setKeyEquivalentModifierMask:(NSAlternateKeyMask)];
	[gitDestageItem setKeyEquivalent:@"d"];
	
	gitRemoveItem = [[NSMenuItem alloc] init];
	[gitRemoveItem setTitle:@"Remove"];
	[gitRemoveItem setTarget:gd];
	[gitRemoveItem setAction:@selector(gitRemove:)];
	[gitRemoveItem setKeyEquivalentModifierMask:(NSAlternateKeyMask)];
	[gitRemoveItem setKeyEquivalent:@"r"];
	
	gitDiscardChangesItem = [[NSMenuItem alloc] init];
	[gitDiscardChangesItem setTitle:@"Discard Changes"];
	[gitDiscardChangesItem setTarget:gd];
	[gitDiscardChangesItem setAction:@selector(gitDiscardChanges:)];
	[gitDiscardChangesItem setKeyEquivalentModifierMask:(NSAlternateKeyMask)];
	[gitDiscardChangesItem setKeyEquivalent:@"g"];
	
	gitIgnoreItem = [[NSMenuItem alloc] init];
	[gitIgnoreItem setTitle:@"Ignore"];
	[gitIgnoreItem setTarget:gd];
	[gitIgnoreItem setAction:@selector(gitIgnore:)];
	
	openFile = [[NSMenuItem alloc] init];
	[openFile setTitle:@"Open File"];
	[openFile setTarget:gd];
	[openFile setAction:@selector(openFile:)];
	
	quickLook = [[NSMenuItem alloc] init];
	[quickLook setTitle:@"Quick Look"];
	[quickLook setTarget:gd];
	[quickLook setAction:@selector(quickLook:)];
	[quickLook setKeyEquivalentModifierMask:0];
	[quickLook setKeyEquivalent:@" "];
	
	openInFinder = [[NSMenuItem alloc] init];
	[openInFinder setTitle:@"Reveal in Finder"];
	[openInFinder setTarget:gd];
	[openInFinder setAction:@selector(openInFinder:)];
	
	openContainerInFinder = [[NSMenuItem alloc] init];
	[openContainerInFinder setTitle:@"Show Containing Folder in Finder"];
	[openContainerInFinder setTarget:gd];
	[openContainerInFinder setAction:@selector(openContainingFolder:)];
	
	moveToTrash = [[NSMenuItem alloc] init];
	[moveToTrash setTitle:@"Move to Trash"];
	[moveToTrash setTarget:gd];
	[moveToTrash setAction:@selector(moveToTrash:)];
	
	gitIgnoreExension = [[NSMenuItem alloc] init];
	[gitIgnoreExension setTitle:@"Ignore Files With Extension"];
	[gitIgnoreExension setTarget:gd];
	[gitIgnoreExension setAction:@selector(gitIgnoreExtension:)];
	
	gitMergeTool = [[NSMenuItem alloc] init];
	[gitMergeTool setTitle:@"Resolve Conflicts With FileMerge..."];
	[gitMergeTool setTarget:gd];
	[gitMergeTool setAction:@selector(resolveConflictsWithFileMerge:)];
	[gitMergeTool setKeyEquivalentModifierMask:(NSAlternateKeyMask)];
	[gitMergeTool setKeyEquivalent:@"m"];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTContextMenuController\n");
	#endif
	
	[gitAddItem release];
	[gitIgnoreExension release];
	[gitDestageItem release];
	[gitDiscardChangesItem release];
	[gitRemoveItem release];
	[gitIgnoreItem release];
	[gitIgnoreContainer release];
	[moveToTrash release];
	[openInFinder release];
	[openContainerInFinder release];
	[activeBranchActionsMenu release];
	[pushItem release];
	[pullItem release];
	[pushTo release];
	[pullFrom release];
	[branchDelete release];
	[branchRename release];
	[branchCheckout release];
	[branchMerge release];
	[branchNewBranchFromThis release];
	[branchReset release];
	[branchDiscardNonStagedChanges release];
	[branchTagFromHead release];
	[branchExportZip release];
	[branchExportTar release];
	[defaultRemote release];
	[branchActionsMenu release];
	[pushToMenu release];
	[pullFromMenu release];
	[defaultRemoteMenu release];
	[stashPop release];
	[stashDrop release];
	[stashApply release];
	[stashMenu release];
	[remotesMenu release];
	[remotesDelete release];
	[tagsDelete release];
	[exportZip release];
	[exportTar release];
	[tagsPush release];
	[tagsMenu release];
	[tagsPushToMenu release];
	[newRemoteActionsItem release];
	[newStash release];
	[newBranch release];
	[newBranchFrom release];
	[newTag release];
	[newTagFrom release];
	[newEmptyBranch release];
	[exportArchiveCommit release];
	[newBranchFromCommit release];
	[newTagFromCommit release];
	[newTrackingBranch release];
	[fetchTags release];
	[actionsMenu release];
	[branchDeleteAtItem release];
	[branchDeleteAtMenu release];
	[tagsDeleteAtMenu release];	
	[tagsDeleteAtItem release];
	[newSubmodule release];
	[rebasePull release];
	[pullItemAlternate release];
	[subsOpenWithGitty release];
	[subsPull release];
	[subsPush release];
	[subsSync release];
	[subsUpdate release];
	[submodulesMenu release];
	[subsDelete release];
	[gitMergeTool release];
	[leftDiffPWD release];
	[leftDiffCommit release];
	[leftDiffHEAD release];
	[leftDiffStage release];
	[leftDiffSelectorMenu release];
	[rightDiffPWD release];
	[rightDiffCommit release];
	[rightDiffHEAD release];
	[rightDiffStage release];
	[rightDiffSelectorMenu release];
	[gitAddAndCommitItem release];
	[remoteBranchesMenu release];
	[rbFetchItem release];
	[rbMergeItem release];
	[tagHistoryItem release];
	[branchHistoryItem release];
	[rbHistoryItem release];
	[terminalItem release];
	
	sourceListView=nil;
	splitContentView=nil;
	diffView=nil;
	diffStateView=nil;
	activeBranchView=nil;
	gd=nil;
	[super dealloc];
}

@end
