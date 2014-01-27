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
#import <GDKit/GDKit.h>
#import "defs.h"

#define kGTDiffModifierStage 1

@interface GTGitDiff : NSObject {
	BOOL isCommitDiff;
	NSInteger diffMode;
	NSInteger contextValue;
	NSString * diffContent;
	NSMutableArray * filePaths;
	NSString * left;
	NSString * right;
}

@property (strong) NSString * diffContent;
@property (strong,nonatomic) NSMutableArray * filePaths;
@property (assign,nonatomic) NSInteger contextValue;
@property (copy,nonatomic) NSString * left;
@property (copy,nonatomic) NSString * right;
@property (assign,nonatomic) BOOL isCommitDiff;

- (void) appendPath:(NSString *) _path;
- (void) headVSWorkingTree;
- (void) headVSStage;
- (void) stageVSWorkingTree;
- (void) workingTreeChanges;
- (void) stagedChanges;
- (BOOL) isStagedChangesMode;
- (BOOL) isWorkingTreeChangesMode;
- (BOOL) isStageVSWorkingTreeMode;
- (NSInteger) filePathsCount;
- (NSString *) diffModeAsString;
- (NSString *) contextValueAsString;

@end
