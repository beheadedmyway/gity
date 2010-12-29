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
#import <RegexKit/RegexKit.h>
#import <GDKit/GDKit.h>
#import "defs.h"
#import "GTDiffView.h"
#import "GTGitCommandExecutor.h"
#import "GTGitFile.h"
#import "GTGittyView.h"
#import "GDNSString+Additions.h"
#import "GTNotificationsHelper.h"
#import "GTSplitContentView.h"
#import "GTStatusBarView.h"
#import "GTStatusController.h"

@class GTDocumentController;
@class GittyDocument;

@interface GTActiveBranchView : GTGittyView <NSTableViewDelegate,NSTableViewDataSource,NSOutlineViewDelegate,NSOutlineViewDataSource,NSMenuDelegate> {
	BOOL hasSetTableProperties;
	NSString * lastSearchTerm;
	NSMutableArray * files;
	NSMutableDictionary * fileDirectory;
	NSMutableArray * filesCopy;
	IBOutlet NSTableView * tableView;
	IBOutlet NSOutlineView * outlineView;
	IBOutlet NSScrollView * outlineContainer;
	GTStatusBarView * statusBarView;
	GTSplitContentView * splitContentView;
	GTDiffView * diffView;
	BOOL useOutline;
	NSMutableArray *expandedItems;
	NSUInteger activeState;
}

@property (retain, nonatomic) NSMutableDictionary *fileDirectory;
@property (retain, nonatomic) NSMutableArray * files;
@property (assign, nonatomic) BOOL useOutline;

- (void) activateTableView;
- (void) clearSearch;
- (void) deleteAtRow;
- (void) search:(NSString *) term;
- (void) update;
- (void) updateFromStatusBarView;
- (BOOL) isClickedRowIncludedInSelection;
- (BOOL) isSelectedFileAConflictedFile;
- (NSArray *) selectedGitFiles;
- (NSIndexSet *) getSelectedIndexSet;
- (NSInteger) selectedFilesCount;
- (NSString *) getSelectedFileExtension;
- (NSString *) selectedFileShortName;
- (NSMutableArray *) allFiles;
- (NSMutableArray *) selectedFiles;
- (NSMutableArray *) filesForAdd;
- (NSMutableArray *) filesForRemove;
- (NSMutableArray *) filesForDelete;
- (NSMutableArray *) filesForDiscard;
- (GTGitFile *) selectedGitFile;

@end
