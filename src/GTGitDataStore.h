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
#import "defs.h"
#import "GTBaseObject.h"

@class GittyDocument;
@class GTDocumentController;

@interface GTGitDataStore : GTBaseObject {
	BOOL isHeadDetatched;
	NSInteger untrackedFilesCount;
	NSInteger deletedFilesCount;
	NSInteger stagedFilesCount;
	NSInteger modifiedFilesCount;
	NSInteger stagedAddedFilesCount;
	NSInteger stagedDeletedFilesCount;
	NSInteger stagedModifiedFilesCount;
	NSInteger unmergedFilesCount;
	NSInteger looseObjects;
	NSString * activeBranchName;
	NSString * commitsAhead;
	NSString * currentAbbreviatedSha;
	NSString * diffTemplate;
	NSMutableArray * unmergedFiles;
	NSMutableArray * allFiles;
	NSMutableArray * modifiedFiles;
	NSMutableArray * untrackedFiles;
	NSMutableArray * deletedFiles;
	NSMutableArray * stagedFiles;
	NSMutableArray * stageAddedFiles;
	NSMutableArray * stageDeletedFiles;
	NSMutableArray * stageModifiedFiles;
	NSMutableArray * stageRenamedFiles;
	NSMutableArray * branchNames;
	NSMutableArray * tagNames;
	NSMutableArray * ignorePatterns;
	NSMutableArray * remotes;
	NSMutableArray * savedStashes;
	NSMutableArray * configs;
	NSMutableArray * globalConfigs;
	NSMutableArray * remoteBranchNames;
	NSMutableArray * remoteTagNames;
	NSMutableArray * submodules;
	NSMutableArray * submoduleNames;
	NSMutableArray * remoteTrackingBranches;
	NSMutableArray * historyCommits;
	NSMutableDictionary * defaultRemotes;
	NSMutableDictionary * refs;
	NSMutableDictionary * refsCache;
}

@property (copy,nonatomic) NSString * currentAbbreviatedSha;
@property (assign,nonatomic) BOOL isHeadDetatched;
@property (assign,nonatomic) NSInteger looseObjects;
@property (readonly) NSInteger untrackedFilesCount;
@property (readonly) NSInteger modifiedFilesCount;
@property (readonly) NSInteger stagedFilesCount;
@property (readonly) NSInteger deletedFilesCount;
@property (readonly) NSInteger stagedAddedFilesCount;
@property (readonly) NSInteger stagedDeletedFilesCount;
@property (readonly) NSInteger stagedModifiedFilesCount;
@property (readonly) NSInteger remotesCount;
@property (readonly) NSInteger unmergedFilesCount;
@property (copy) NSString * activeBranchName;
@property (copy) NSString * commitsAhead;
@property (copy,nonatomic) NSString * diffTemplate;
@property (retain) NSMutableArray * unmergedFiles;
@property (retain) NSMutableArray * allFiles;
@property (retain) NSMutableArray * modifiedFiles;
@property (retain) NSMutableArray * untrackedFiles;
@property (retain) NSMutableArray * deletedFiles;
@property (retain) NSMutableArray * stagedFiles;
@property (retain) NSMutableArray * stageAddedFiles;
@property (retain) NSMutableArray * stageDeletedFiles;
@property (retain) NSMutableArray * stageModifiedFiles;
@property (retain) NSMutableArray * stageRenamedFiles;
@property (retain) NSMutableArray * branchNames;
@property (retain) NSMutableArray * tagNames;
@property (retain) NSMutableArray * submodules;
@property (retain) NSMutableArray * ignorePatterns;
@property (retain) NSMutableArray * remotes;
@property (retain) NSMutableArray * remoteTrackingBranches;
@property (retain) NSMutableArray * savedStashes;
@property (retain) NSMutableDictionary * defaultRemotes;
@property (retain) NSMutableArray * configs;
@property (retain) NSMutableArray * globalConfigs;
@property (retain) NSMutableArray * remoteBranchNames;
@property (retain) NSMutableArray * remoteTagNames;
@property (retain) NSMutableArray * submoduleNames;
@property (retain) NSMutableArray * historyCommits;
@property (retain) NSMutableDictionary * refs;

- (void) setDefaultRemote:(NSString *) remote forBranch:(NSString *) branch;
- (void) loadDiffTemplate;
- (BOOL) hasDefaultRemoteForBranch:(NSString *) branch;
- (BOOL) isDefaultRemote:(NSString *) remote forBranch:(NSString *) branch;
- (BOOL) isFileStaged:(NSString *) file;
- (BOOL) isFileModified:(NSString *) file;
- (BOOL) isFileDeleted:(NSString *) file;
- (BOOL) isFileUntracked:(NSString *) file;
- (BOOL) isFileConflicted:(NSString *) file;
- (BOOL) isFileModifiedInStage:(NSString *) file;
- (BOOL) isFileAddedInStage:(NSString *) file;
- (BOOL) isFileDeletedInStage:(NSString *) file;
- (BOOL) isFileSubmodule:(NSString *) file;
- (BOOL) isDirty;
- (BOOL) isDirtyExcludingStage;
- (BOOL) isConflicted;
- (BOOL) hasRemote:(NSString *) _remoteName;
- (NSString *) defaultRemoteForBranch:(NSString *) branch;
- (NSMutableArray *) remoteNames;
- (NSMutableArray *) getRefsForSHA:(NSString *) _sha;

@end
