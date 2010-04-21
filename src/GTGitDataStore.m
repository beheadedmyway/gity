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

#import "GTGitDataStore.h"
#import "GittyDocument.h"
#import "GTDocumentController.h"

@implementation GTGitDataStore
@synthesize refs;
@synthesize diffTemplate;
@synthesize historyCommits;
@synthesize currentAbbreviatedSha;
@synthesize	isHeadDetatched;
@synthesize looseObjects;
@synthesize activeBranchName;
@synthesize allFiles;
@synthesize modifiedFiles;
@synthesize untrackedFiles;
@synthesize deletedFiles;
@synthesize stagedFiles;
@synthesize branchNames;
@synthesize remotes;
@synthesize tagNames;
@synthesize ignorePatterns;
@synthesize untrackedFilesCount;
@synthesize stagedFilesCount;
@synthesize deletedFilesCount;
@synthesize modifiedFilesCount;
@synthesize stageAddedFiles;
@synthesize stageDeletedFiles;
@synthesize stageModifiedFiles;
@synthesize stageRenamedFiles;
@synthesize stagedAddedFilesCount;
@synthesize stagedModifiedFilesCount;
@synthesize stagedDeletedFilesCount;
@synthesize remoteTrackingBranches;
@synthesize savedStashes;
@synthesize defaultRemotes;
@synthesize configs;
@synthesize globalConfigs;
@synthesize remoteBranchNames;
@synthesize remoteTagNames;
@synthesize unmergedFiles;
@synthesize unmergedFilesCount;
@synthesize commitsAhead;
@synthesize submodules;
@synthesize submoduleNames;

- (id) initWithGD:(GittyDocument *) _gd {
	self = [super initWithGD:_gd];
	refsCache = [[NSMutableDictionary alloc] init];
	[self setCommitsAhead:@"0"];
	return self;
}

- (BOOL) isDirty {
	if([self untrackedFilesCount] > 0 || [self deletedFilesCount] > 0|| [self stagedFilesCount] > 0||
	   [self modifiedFilesCount] > 0 || [self stagedAddedFilesCount] > 0 || [self stagedDeletedFilesCount] > 0 ||
	   [self stagedModifiedFilesCount] > 0) return true;
	return false;
}

- (BOOL) isDirtyExcludingStage {
	if([self untrackedFilesCount] > 0 || [self deletedFilesCount] > 0 || [self modifiedFilesCount] > 0) return true;
	return false;
}

- (BOOL) isConflicted {
	return ([self unmergedFilesCount] > 0);
}

- (BOOL) isFileStaged:(NSString *) file {
	return ([stagedFiles containsObject:file]);
}

- (BOOL) isFileSubmodule:(NSString *) file {
	return [submodules containsObject:file];
}

- (BOOL) isFileStagedSubmodule:(NSString *) file {
	return false;
}

- (BOOL) isFileModifiedInStage:(NSString *) file {
	BOOL c = [stageModifiedFiles containsObject:file];
	return c;
}

- (BOOL) isFileAddedInStage:(NSString *) file {
	BOOL c = [stageAddedFiles containsObject:file];
	return c;
}

- (BOOL) isFileDeletedInStage:(NSString *) file {
	BOOL c = [stageDeletedFiles containsObject:file];
	return c;
}

- (BOOL) isFileModified:(NSString *) file {
	BOOL c = [modifiedFiles containsObject:file];
	if(!c) return c;
	return (c);
}

- (BOOL) isFileDeleted:(NSString *) file {
	BOOL c = [deletedFiles containsObject:file];
	if(!c) return c;
	return (c);
}

- (BOOL) isFileUntracked:(NSString *) file {
	return [untrackedFiles containsObject:file];
}

- (BOOL) isFileConflicted:(NSString *) file {
	return [unmergedFiles containsObject:file];
}

- (NSMutableArray *) stagedFiles {
	NSMutableArray * files = [[NSMutableArray alloc] init];
	if([stageAddedFiles count] > 0) [files addObjectsFromArray:stageAddedFiles];
	if([stageModifiedFiles count] > 0) [files addObjectsFromArray:stageModifiedFiles];
	if([stageDeletedFiles count] > 0) [files addObjectsFromArray:stageDeletedFiles];
	return [files autorelease];
}

- (NSInteger) stagedAddedFilesCount {
	if(stageAddedFiles is nil) return 0;
	return [stageAddedFiles count];
}

- (NSInteger) stagedDeletedFilesCount {
	if(stageDeletedFiles is nil) return 0;
	return [stageDeletedFiles count];
}

- (NSInteger) stagedModifiedFilesCount {
	if(stageModifiedFiles is nil) return 0;
	return [stageModifiedFiles count];
}

- (NSInteger) deletedFilesCount {
	if(deletedFiles is nil) return 0;
	return [deletedFiles count];
}

- (NSInteger) untrackedFilesCount {
	if(untrackedFiles is nil) return 0;
	return [untrackedFiles count];
}

- (NSInteger) modifiedFilesCount {
	if(modifiedFiles is nil) return 0;
	return [modifiedFiles count];
}

- (NSInteger) remotesCount {
	if(remotes is nil) return 0;
	return [remotes count];
}

- (NSInteger) unmergedFilesCount {
	if(unmergedFiles is nil) return 0;
	return [unmergedFiles count];
}

- (NSMutableArray *) remoteNames {
	NSMutableArray * a = [NSMutableArray array];
	if(remotes is nil) return a;
	NSDictionary * remote;
	for(remote in remotes) [a addObject:[remote objectForKey:@"name"]];
	return a;
}

- (NSInteger) stagedFilesCount {
	NSInteger t = 0;
	if([stageAddedFiles count] > 0) t += [stageAddedFiles count];
	if([stageModifiedFiles count] > 0) t += [stageModifiedFiles count];
	if([stageDeletedFiles count] > 0) t += [stageDeletedFiles count];
	return t;
}

- (BOOL) isDefaultRemote:(NSString *) remote forBranch:(NSString *) branch {
	return [[defaultRemotes objectForKey:branch] isEqual:branch];
}

- (BOOL) hasDefaultRemoteForBranch:(NSString *) branch {
	return !([defaultRemotes objectForKey:branch]==nil);
}

- (NSString *) defaultRemoteForBranch:(NSString *) branch {
	return [defaultRemotes objectForKey:branch];
}

- (void) setDefaultRemote:(NSString *) remote forBranch:(NSString *) branch {
	if(defaultRemotes is nil) [self setDefaultRemotes:[NSMutableDictionary dictionary]];
	[defaultRemotes setObject:remote forKey:branch];
}

- (BOOL) hasRemote:(NSString *) _remoteName {
	NSMutableArray * rn = [self remoteNames];
	NSString * n;
	for(n in rn) if([n isEqual:_remoteName]) return true;
	return false;
}

- (NSMutableArray *) getRefsForSHA:(NSString *) _sha {
	//NSMutableArray * cached = [refsCache objectForKey:_sha];
	//if(cached) return cached;
	NSString * key;
	NSMutableArray * frefs = [[NSMutableArray alloc] init];
	for(key in refs) {
		if([[refs objectForKey:key] isEqual:_sha]) [frefs addObject:key];
	}
	//if([refs count]>0)[refsCache setObject:frefs forKey:_sha];
	[frefs autorelease];
	return frefs;
}

- (void) loadDiffTemplate {
	NSString * path = [[NSBundle mainBundle] pathForResource:@"cancelDown" ofType:@"png" inDirectory:nil];
	NSFileHandle * fh = [NSFileHandle fileHandleForReadingAtPath:path];
	NSData * content = [fh readDataToEndOfFile];
	diffTemplate = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTGitDataStore\n");
	#endif
	[activeBranchName release];
	[allFiles release];
	[modifiedFiles release];
	[untrackedFiles release];
	[deletedFiles release];
	[stagedFiles release];
	[stageAddedFiles release];
	[stageDeletedFiles release];
	[stageModifiedFiles release];
	[stageRenamedFiles release];
	[branchNames release];
	[tagNames release];
	[ignorePatterns release];
	[remotes release];
	[remoteTrackingBranches release];
	[savedStashes release];
	[defaultRemotes release];
	[configs release];
	[globalConfigs release];
	[remoteBranchNames release];
	[submodules release];
	[unmergedFiles release];
	[historyCommits release];
	GDRelease(refsCache);
	GDRelease(refs);
	gd=nil;
	[super dealloc];
}

@end
