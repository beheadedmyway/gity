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
#import "GTBaseView.h"
#import "GTContextMenuController.h"
#import "GTGitCommandExecutor.h"
#import "GTGitDataStore.h"
#import "GTMainMenuHelper.h"
#import "GTStatusController.h"

@class GittyDocument;
@class GTDocumentController;
@class GTOperationsController;
@class GTModalController;

@interface GTGittyView : GTBaseView {	
	GTContextMenuController * contextMenus;
	GTGitCommandExecutor * git;
	GTGitDataStore * gitd;
	GTMainMenuHelper * mainMenuHelper;
	GTModalController * modals;
	GTOperationsController * operations;
	GTStatusController * status;
	GTWindow * gtwindow;
}

- (void) hide;
- (void) setGDRefs;
- (void) show;
- (void) showInView:(NSView *) _view;
- (void) showInView:(NSView *) _view withAdjustments:(NSRect) _adjust;
- (NSPoint) getTL;
- (NSPoint) getTR;

@end
