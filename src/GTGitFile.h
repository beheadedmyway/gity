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
#import "defs.h"

typedef enum {
	kUntracked = 1,
	kModified = 2,
	kDeleted = 3,
	kConflicted = 4,
	kStageAdded = 5,
	kStageModified = 6,
	kStageDeleted = 7,
	kStageConflicted = 8,
	kNoStatus = 9
} GTFileStatusType;

@interface GTGitFile : NSObject <NSCopying> {
	int type;
	NSString * filename;
}

@property (copy,nonatomic) NSString * filename;
@property (assign,nonatomic) int type;

+ (NSMutableArray *) createArrayOfItemsFromArray:(NSArray *) _array ofStatusType:(int) _type;
- (id) initAsStageAddedFile:(NSString *) _filename;
- (id) initAsStageModifiedFile:(NSString *) _filename;
- (id) initAsStageDeletedFile:(NSString *) _filename;
- (id) initAsStageConflictedFile:(NSString *) _filename;
- (id) initAsUntrackedFile:(NSString *) _filename;
- (id) initAsModifiedFile:(NSString *) _filename;
- (id) initAsDeletedFile:(NSString *) _filename;
- (id) initAsConflictedFile:(NSString *) _filename;
- (BOOL) isMatchedByRegex:(id) aRegex;
- (BOOL) hasNoStatus;
- (BOOL) isStageAddedFile;
- (BOOL) isStageModifiedFile;
- (BOOL) isStageDeletedFile;
- (BOOL) isStageConflictedFile;
- (BOOL) isStaged;
- (BOOL) isUntrackedFile;
- (BOOL) isModifiedFile;
- (BOOL) isDeletedFile;
- (BOOL) isConflictedFile;
- (BOOL) isNoneStatus;
- (NSInteger) sortAscending:(id) _otherItem;
- (NSString *) stringDescriptionForType:(int) type;
- (NSString *) statusImageFilename;
- (NSString *) selectedStatusImageFilename;
- (NSString *) shortFilename;

@end
