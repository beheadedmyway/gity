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

#import "GTGitFile.h"

@implementation GTGitFile
@synthesize filename;
@synthesize type;

- (GTGitFile *) copyWithZone:(NSZone *) zone {
	GTGitFile * cp = [[GTGitFile alloc] init];
	cp.type = type;
	cp.filename = [[filename copyWithZone:zone] autorelease];
	return cp;
}

- (id) initWithFilename:(NSString *) _filename {
	self=[super init];
	[self setFilename:_filename];
	return self;
}

- (BOOL) isMatchedByRegex:(id) aRegex {
	return [filename isMatchedByRegex:aRegex];
}

- (NSInteger) sortAscending:(id) _otherItem {
	GTGitFile * f = (GTGitFile*) _otherItem;
	return [filename caseInsensitiveCompare:[f filename]];
}

- (NSString *) shortFilename {
	return filename;
}

- (NSString *) pathComponentAtIndex:(NSUInteger)index isPath:(BOOL *)isPath
{
	NSArray *items = [filename pathComponents];
	if (isPath)
		*isPath = ([items count] - 1 != index);
	if (index > [items count] - 1)
		return nil;
	return [[[items objectAtIndex:index] copy] autorelease];
}

- (id) initWithFilename:(NSString *) _filename andType:(int) _type {
	self=[self initWithFilename:_filename];
	type=_type;
	return self;
}

- (id) initAsStageAddedFile:(NSString *) _filename {
	self=[self initWithFilename:_filename];
	type=kStageAdded;
	return self;
}

- (id) initAsStageModifiedFile:(NSString *) _filename {
	self=[self initWithFilename:_filename];
	type=kStageModified;
	return self;
}

- (id) initAsStageDeletedFile:(NSString *) _filename {
	self=[self initWithFilename:_filename];
	type=kStageDeleted;
	return self;
}

- (id) initAsStageConflictedFile:(NSString *) _filename {
	self=[self initWithFilename:_filename];
	type=kStageConflicted;
	return self;
}

- (id) initAsUntrackedFile:(NSString *) _filename {
	self=[self initWithFilename:_filename];
	type=kUntracked;
	return self;
}

- (id) initAsModifiedFile:(NSString *) _filename {
	self=[self initWithFilename:_filename];
	type=kModified;
	return self;
}

- (id) initAsDeletedFile:(NSString *) _filename {
	self=[self initWithFilename:_filename];
	type=kDeleted;
	return self;
}

- (id) initAsConflictedFile:(NSString *) _filename {
	self=[self initWithFilename:_filename];
	type=kConflicted;
	return self;
}

+ (NSMutableArray *) createArrayOfItemsFromArray:(NSArray *) _array ofStatusType:(int) _type {
	NSMutableArray * a = [[NSMutableArray alloc] init];
	NSString * filen;
	GTGitFile * gf;
	for (filen in _array) {
		gf=[[GTGitFile alloc] initWithFilename:filen andType:_type];
		[a addObject:gf];
		[gf release];
		gf=nil;
	}
	return [a autorelease];
}

- (BOOL) hasNoStatus {
	return (type == kNoStatus);
}

- (BOOL) isStageAddedFile {
	return (type == kStageAdded);
}

- (BOOL) isStageModifiedFile {
	return (type == kStageModified);
}

- (BOOL) isStageDeletedFile {
	return (type == kStageDeleted);
}

- (BOOL) isStageConflictedFile {
	return (type == kStageConflicted);
}

- (BOOL) isStaged {
	return ([self isStageDeletedFile] || [self isStageAddedFile] || [self isStageModifiedFile]);
}

- (BOOL) isUntrackedFile {
	return (type == kUntracked);
}

- (BOOL) isModifiedFile {
	return (type == kModified);
}

- (BOOL) isDeletedFile {
	return (type==kDeleted);
}

- (BOOL) isConflictedFile {
	return (type == kConflicted);
}

- (BOOL) isNoneStatus {
	return (type == kNoStatus);
}

- (NSString *) stringDescriptionForType:(int) _type {
	switch (_type) {
		case kStageAdded:
			return @"Added in Stage";
			break;
		case kStageDeleted:
			return @"Deleted in Stage";
			break;
		case kStageModified:
			return @"Modified in Stage";
			break;
		case kStageConflicted:
			return @"Conflicted in Stage";
			break;
		case kUntracked:
			return @"Untracked";
			break;
		case kModified:
			return @"Modified";
			break;
		case kDeleted:
			return @"Deleted";
			break;
		case kConflicted:
			return @"Conflicted";
			break;
		case kNoStatus:
			return @"No Status";
			break;
		default:
			break;
	}
	return nil;
}

- (NSString *) statusImageFilename {
	switch (type) {
		case kStageAdded:
			return @"statusAddedInStage.png";
			break;
		case kStageDeleted:
			return @"statusRemovedInStage.png";
			break;
		case kStageModified:
			return @"statusModifiedInStage.png";
			break;
		case kStageConflicted:
			return @"";
			break;
		case kUntracked:
			return @"statusUntrackedNormal.png";
			break;
		case kModified:
			return @"statusModifiedNormal.png";
			break;
		case kDeleted:
			return @"statusRemovedNormal.png";
			break;
		case kConflicted:
			return @"fileStatusConflictedNormal.png";
			break;
		case kNoStatus:
			return @"statusNone.png";
			break;
		default:
			break;
	}
	return nil;
}

- (NSString *) selectedStatusImageFilename {
	switch (type) {
		case kStageAdded:
			return @"statusAddedInStageHighlighted.png";
			break;
		case kStageDeleted:
			return @"statusRemovedInStageHighlighted.png";
			break;
		case kStageModified:
			return @"statusModifiedInStageHighlighted.png";
			break;
		case kStageConflicted:
			return @"";
			break;
		case kUntracked:
			return @"statusUntrackedNormalHighlighted.png";
			break;
		case kModified:
			return @"statusModifiedNormalHighlighted.png";
			break;
		case kDeleted:
			return @"statusRemovedNormalHighlighted.png";
			break;
		case kConflicted:
			return @"fileStatusConflictedHighlighted.png";
			break;
		case kNoStatus:
			return @"statusNoneHighlighted.png";
			break;
		default:
			break;
	}
	return nil;
}

- (NSString *) description {
	return [NSString stringWithFormat:@"<GTGitFile. filename:%@ type:%@ imageFilename:%@",filename,[self stringDescriptionForType:type],[self statusImageFilename]];
}

- (void) dealloc {
	#ifdef GT_PRINT_EXTENDED_DEALLOCS
	printf("DEALLOC GTGitFile\n");
	#endif
	GDRelease(filename);
	[super dealloc];
}

@end


/*
if([[gd statusBarView] shouldShowStagedFiles]) {
if([gitd isFileAddedInStage:file]) {
if(selected) img = [NSImage imageNamed:@"statusAddedInStageHighlighted.png"];
else img = [NSImage imageNamed:@"statusAddedInStage.png"];
}
if([gitd isFileModifiedInStage:file]) {
if(selected) img = [NSImage imageNamed:@"statusModifiedInStageHighlighted.png"];
else img = [NSImage imageNamed:@"statusModifiedInStage.png"];
}
if([gitd isFileDeletedInStage:file]) {
if(selected) img = [NSImage imageNamed:@"statusRemovedInStageHighlighted.png"];
else img = [NSImage imageNamed:@"statusRemovedInStage.png"];
}
}
if(img is nil and [gitd isFileModified:file]) {
if(selected) img = [NSImage imageNamed:@"statusModifiedNormalHighlighted.png"];
else img = [NSImage imageNamed:@"statusModifiedNormal.png"];
}
if(img is nil and [gitd isFileDeleted:file]) {
if(selected) img = [NSImage imageNamed:@"statusRemovedNormalHighlighted.png"];
else img = [NSImage imageNamed:@"statusRemovedNormal.png"];
}
if(img is nil and [gitd isFileUntracked:file]) {
if(selected) img = [NSImage imageNamed:@"statusUntrackedNormalHighlighted.png"];
else img = [NSImage imageNamed:@"statusUntrackedNormal.png"];
}
if(img is nil and [gitd isFileConflicted:file]) {
if(selected) img = [NSImage imageNamed:@"fileStatusConflictedHighlighted.png"];
else img = [NSImage imageNamed:@"fileStatusConflictedNormal.png"];
}
//NSLog(@"IMAGE: %@",img);
if(img == nil) {
if(selected) img = [NSImage imageNamed:@"statusNoneHighlighted.png"];
else img = [NSImage imageNamed:@"statusNone.png"];
}
*/