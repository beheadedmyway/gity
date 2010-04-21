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

#import "GTMainMenuHelper.h"
#import "GittyDocument.h"
#import "GTDocumentController.h"

@implementation GTMainMenuHelper

- (id) initWithGD:(GittyDocument *) _gd {
	if(self = [super initWithGD:_gd]) {
		updatedAutoEnables=false;
		[self initMainMenuRefs];
	}
	return self;
}

+ (void) updateRegistrationItem:(BOOL) isRunningWithValidLicense {
	NSMenu * mm = [[NSApplication sharedApplication] mainMenu];
	NSMenu * gm = [[mm itemAtIndex:0] submenu];
	if(isRunningWithValidLicense) [gm removeItemAtIndex:2];
}

+ (void) disableRegistrationItem {
	NSMenu * mm = [[NSApplication sharedApplication] mainMenu];
	NSMenu * gm = [[mm itemAtIndex:0] submenu];
	[gm setAutoenablesItems:false];
	NSMenuItem * reg = [gm itemAtIndex:2];
	[reg setEnabled:false];
}

- (void) setRefs {
	[super setRefs];
	diffView=[gd diffView];
	statusBarView=[gd statusBarView];
	activeBranchView=[gd activeBranchView];
}

- (void) initMainMenuRefs {
	mainMenu = [[NSApplication sharedApplication] mainMenu];
	viewMenu = [[mainMenu itemWithTag:3] submenu];
	actionsMenu = [[mainMenu itemWithTag:4] submenu];
	statusMenu = [[mainMenu itemWithTag:5] submenu];
	repoMenu = [[mainMenu itemWithTag:6] submenu];
}

- (void) updateAutoEnableItems {
	if(updatedAutoEnables)return;
	updatedAutoEnables=true;
	[statusMenu setAutoenablesItems:false];
	[viewMenu setAutoenablesItems:false];
	[actionsMenu setAutoenablesItems:false];
	[repoMenu setAutoenablesItems:false];
	[repoMenu update];
	[statusMenu update];
	[viewMenu update];
	[actionsMenu update];
}

- (void) invalidate {
	[self invalidateViewMenu];
	[self invalidateActionsMenu];
	[self invalidateStatusMenu];
	[self invalidateRepoMenu];
}

- (void) invalidateViewMenu {
	[[viewMenu itemWithTag:0] setEnabled:true];
	[[viewMenu itemWithTag:1] setEnabled:true];
	[[viewMenu itemWithTag:2] setEnabled:true];
	[[viewMenu itemWithTag:3] setEnabled:true];
	[[viewMenu itemWithTag:4] setEnabled:true];
	
	if([gd isCurrentViewActiveBranchView]) {
		if([[diffView diffContentView] webView] is nil) {
			[[viewMenu itemWithTag:5] setEnabled:false];
			[[viewMenu itemWithTag:6] setEnabled:false];
		}
		
		if([[diffView diffContentView] webView]) {
			[[viewMenu itemWithTag:5] setEnabled:true];
			[[viewMenu itemWithTag:6] setEnabled:true];
		}
	}
	
	if([gd isCurrentViewHistoryView]) {
		if([[[gd historyDetailsContainerView] detailsView] webView] is nil) {
			[[viewMenu itemWithTag:5] setEnabled:false];
			[[viewMenu itemWithTag:6] setEnabled:false];
		}
		
		if([[[gd historyDetailsContainerView] detailsView] webView]) {
			[[viewMenu itemWithTag:5] setEnabled:true];
			[[viewMenu itemWithTag:6] setEnabled:true];
		}
	}
	
	if([gitd isHeadDetatched]) {
		//[[viewMenu itemWithTag:4] setEnabled:false];
		[[viewMenu itemWithTag:5] setEnabled:false];
		[[viewMenu itemWithTag:6] setEnabled:false];
	}
}

- (void) invalidateRepoMenu {
	[[repoMenu itemWithTag:20] setEnabled:true];
	[[repoMenu itemWithTag:21] setEnabled:true];
	[[repoMenu itemWithTag:22] setEnabled:true];
	[[repoMenu itemWithTag:23] setEnabled:true];
	[[repoMenu itemWithTag:24] setEnabled:true];
	[[repoMenu itemWithTag:25] setEnabled:true];
	[[repoMenu itemWithTag:26] setEnabled:true];
	[[repoMenu itemWithTag:27] setEnabled:true];
	[[repoMenu itemWithTag:28] setEnabled:true];
	
	if([gitd isDirty]) {
		[[repoMenu itemWithTag:7] setEnabled:true];
		[[repoMenu itemWithTag:8] setEnabled:true];
		[[repoMenu itemWithTag:9] setEnabled:true];
	} else {
		[[repoMenu itemWithTag:7] setEnabled:false];
		[[repoMenu itemWithTag:8] setEnabled:false];
		[[repoMenu itemWithTag:9] setEnabled:false];
	}
	
	NSMutableArray * remotes = [gitd remoteNames];
	if([remotes count] < 1) {
		[[repoMenu itemWithTag:1] setEnabled:false];
		[[repoMenu itemWithTag:6] setEnabled:false];
	} else {
		[[repoMenu itemWithTag:1] setEnabled:true];
		[[repoMenu itemWithTag:6] setEnabled:true];
	}
	NSMutableArray * subs = [gitd submodules];
	if([subs count] < 1) {
		[[repoMenu itemWithTag:10] setEnabled:false];
		[[repoMenu itemWithTag:11] setEnabled:false];
	} else {
		[[repoMenu itemWithTag:10] setEnabled:true];
		[[repoMenu itemWithTag:11] setEnabled:true];
	}
	if([gitd isHeadDetatched]) {
		[[repoMenu itemWithTag:20] setEnabled:false];
		[[repoMenu itemWithTag:21] setEnabled:false];
		[[repoMenu itemWithTag:22] setEnabled:false];
		[[repoMenu itemWithTag:24] setEnabled:false];
		[[repoMenu itemWithTag:25] setEnabled:false];
		[[repoMenu itemWithTag:26] setEnabled:false];
		[[repoMenu itemWithTag:27] setEnabled:false];
		[[repoMenu itemWithTag:28] setEnabled:false];
	}
	
	if([remotes count] < 1) {
		[[repoMenu itemWithTag:30] setEnabled:false];
		[[repoMenu itemWithTag:31] setEnabled:false];
		[[repoMenu itemWithTag:32] setEnabled:false];
		[[repoMenu itemWithTag:33] setEnabled:false];
	} else {
		[[repoMenu itemWithTag:30] setEnabled:true];
		[[repoMenu itemWithTag:31] setEnabled:true];
		[[repoMenu itemWithTag:32] setEnabled:true];
		[[repoMenu itemWithTag:33] setEnabled:true];
	}
}

- (void) invalidateActionsMenu {
	if([gd isCurrentViewActiveBranchView]) {
		if([activeBranchView selectedFilesCount] < 1) {
		} else {
		}
		if([gitd stagedFilesCount] < 1) [[actionsMenu itemWithTag:kMainMenuCommitTag] setEnabled:false];
		else [[actionsMenu itemWithTag:kMainMenuCommitTag] setEnabled:true];
		[[actionsMenu itemWithTag:kMainMenuAddItem] setEnabled:true];
		[[actionsMenu itemWithTag:kMainMenuDestageItem] setEnabled:true];
		[[actionsMenu itemWithTag:kMainMenuDiscardItem] setEnabled:true];
		[[actionsMenu itemWithTag:kMainMenuRemoveItem] setEnabled:true];
		[[actionsMenu itemWithTag:5] setEnabled:true];
		if([activeBranchView selectedFilesCount] == 1 && [activeBranchView isSelectedFileAConflictedFile]) {
			[[actionsMenu itemWithTag:6] setEnabled:true];
		} else {
			[[actionsMenu itemWithTag:6] setEnabled:false];
		}
	} else {
		[[actionsMenu itemWithTag:kMainMenuAddItem] setEnabled:false];
		[[actionsMenu itemWithTag:kMainMenuDestageItem] setEnabled:false];
		[[actionsMenu itemWithTag:kMainMenuDiscardItem] setEnabled:false];
		[[actionsMenu itemWithTag:kMainMenuRemoveItem] setEnabled:false];
		[[actionsMenu itemWithTag:5] setEnabled:false];
		[[actionsMenu itemWithTag:6] setEnabled:false];
	}
	if([activeBranchView selectedFilesCount] < 1) {
		[[actionsMenu itemWithTag:kMainMenuAddItem] setEnabled:false];
		[[actionsMenu itemWithTag:kMainMenuDestageItem] setEnabled:false];
		[[actionsMenu itemWithTag:kMainMenuDiscardItem] setEnabled:false];
		[[actionsMenu itemWithTag:kMainMenuRemoveItem] setEnabled:false];
		[[actionsMenu itemWithTag:5] setEnabled:false];
		[[actionsMenu itemWithTag:6] setEnabled:false];
	}
	
	if([gitd isHeadDetatched]) {
		[[actionsMenu itemWithTag:5] setEnabled:false];
		[[actionsMenu itemWithTag:kMainMenuAddItem] setEnabled:false];
		[[actionsMenu itemWithTag:kMainMenuDestageItem] setEnabled:false];
		[[actionsMenu itemWithTag:kMainMenuDiscardItem] setEnabled:false];
		[[actionsMenu itemWithTag:kMainMenuRemoveItem] setEnabled:false];
		[[actionsMenu itemWithTag:7] setEnabled:false];
		[[actionsMenu itemWithTag:8] setEnabled:false];
		[[actionsMenu itemWithTag:9] setEnabled:false];
	}
}

- (void) invalidateStatusMenu {
	if([gd isCurrentViewActiveBranchView]) {
		if(![statusBarView isDirty]) [[statusMenu itemWithTag:kMainMenuAllFilesItem] setEnabled:false];
		else [[statusMenu itemWithTag:kMainMenuAllFilesItem] setEnabled:true];
		if([gitd untrackedFilesCount] < 1) [[statusMenu itemWithTag:kMainMenuToggleUntrackedItem] setEnabled:false];
		else [[statusMenu itemWithTag:kMainMenuToggleUntrackedItem] setEnabled:true];
		if([gitd deletedFilesCount] < 1) [[statusMenu itemWithTag:kMainMenuToggleDeletedItem] setEnabled:false];
		else [[statusMenu itemWithTag:kMainMenuToggleDeletedItem] setEnabled:true];
		if([gitd modifiedFilesCount] < 1) [[statusMenu itemWithTag:kMainMenuToggleModifiedItem] setEnabled:false];
		else [[statusMenu itemWithTag:kMainMenuToggleModifiedItem] setEnabled:true];
		if([gitd stagedFilesCount] < 1) [[statusMenu itemWithTag:kMainMenuToggleStagedItem] setEnabled:false];
		else [[statusMenu itemWithTag:kMainMenuToggleStagedItem] setEnabled:true];
		[[statusMenu itemWithTag:kMainMenuRefreshItem] setEnabled:true];
	} else {
		[[statusMenu itemWithTag:kMainMenuAllFilesItem] setEnabled:false];
		[[statusMenu itemWithTag:kMainMenuToggleUntrackedItem] setEnabled:false];
		[[statusMenu itemWithTag:kMainMenuToggleDeletedItem] setEnabled:false];
		[[statusMenu itemWithTag:kMainMenuToggleModifiedItem] setEnabled:false];
		[[statusMenu itemWithTag:kMainMenuToggleStagedItem] setEnabled:false];
		[[statusMenu itemWithTag:kMainMenuRefreshItem] setEnabled:false];
	}
	if([gd isCurrentViewConfigView]) {
		[[statusMenu itemWithTag:kMainMenuRefreshItem] setEnabled:true];
	}
	if([gitd isConflicted]) {
		[[statusMenu itemWithTag:5] setEnabled:true];
	} else {
		[[statusMenu itemWithTag:5] setEnabled:false];
	}
	if([gd isCurrentViewActiveBranchView]) {
		if(![statusBarView isDirty]) [[statusMenu itemWithTag:kMainMenuAllFilesItem] setEnabled:false];
		else [[statusMenu itemWithTag:kMainMenuAllFilesItem] setEnabled:true];
	}
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTMainMenuHelper\n");
	#endif
	updatedAutoEnables=false;
	gd=nil;
	mainMenu=nil;
	viewMenu=nil;
	actionsMenu=nil;
	statusMenu=nil;
	[super dealloc];
}

@end
