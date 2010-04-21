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
#import "GTBaseObject.h"

@class GittyDocument;
@class GTDocumentController;
@class GTDiffView;
@class GTActiveBranchView;
@class GTStatusBarView;

#define kMainMenuAddItem 0
#define kMainMenuDestageItem 1
#define kMainMenuDiscardItem 2
#define kMainMenuRemoveItem 3
#define kMainMenuCommitTag 4

#define kMainMenuAllFilesItem 0
#define kMainMenuToggleUntrackedItem 1
#define kMainMenuToggleDeletedItem 2
#define kMainMenuToggleModifiedItem 3
#define kMainMenuToggleStagedItem 4
#define kMainMenuRefreshItem 5

@interface GTMainMenuHelper : GTBaseObject {
	BOOL updatedAutoEnables;
	NSMenu * mainMenu;
	NSMenu * viewMenu;
	NSMenu * actionsMenu;
	NSMenu * statusMenu;
	NSMenu * repoMenu;
	GTDiffView * diffView;
	GTActiveBranchView * activeBranchView;
	GTStatusBarView * statusBarView;
}

+ (void) updateRegistrationItem:(BOOL) isRunningWithValidLicense;
+ (void) disableRegistrationItem;
- (void) initMainMenuRefs;
- (void) invalidate;
- (void) invalidateViewMenu;
- (void) invalidateActionsMenu;
- (void) invalidateStatusMenu;
- (void) invalidateRepoMenu;
- (void) updateAutoEnableItems;

@end
