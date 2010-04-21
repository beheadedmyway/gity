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

@interface GTSourceListItem : NSObject {
	BOOL isGroupItem;
	id data;
	NSInteger index;
	NSString * name;
	NSString * label;
	NSMutableArray * children;
	GTSourceListItem * parent;
}

@property (copy,nonatomic) id data;
@property (copy,nonatomic) NSString * name;
@property (copy,nonatomic) NSString * label;
@property (retain,nonatomic) GTSourceListItem * parent;
@property (assign,nonatomic) BOOL isGroupItem;
@property (assign,nonatomic) NSInteger index;

- (void) addChild:(GTSourceListItem *) child;
- (void) removeChild:(GTSourceListItem *) child;
- (void) setChildren:(NSMutableArray *) _children;
- (void) setName:(NSString *) name andLabel:(NSString *) label;
- (void) releaseTree;
- (BOOL) isGroupItem;
- (BOOL) isChildOfBranches;
- (BOOL) isChildOfStashes;
- (BOOL) isChildOfRemotes;
- (BOOL) isChildOfTags;
- (BOOL) isChildOfRemoteBranches;
- (BOOL) isChildOfSubmodules;
- (NSUInteger) numChildren;
- (NSInteger) xdepth;
- (GTSourceListItem *) itemAtIndex:(NSUInteger) index;

@end
