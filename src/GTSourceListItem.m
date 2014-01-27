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

#import "GTSourceListItem.h"

@implementation GTSourceListItem
@synthesize name;
@synthesize label;
@synthesize isGroupItem;
@synthesize parent;
@synthesize index;
@synthesize data;
@synthesize image;
@synthesize items;

- (id) init {
	self=[super init];
	children=[[NSMutableArray alloc] init];
	return self;
}

- (NSInteger) xdepth {
	if(parent == nil) return 0;
	GTSourceListItem * p = parent;
	NSInteger d = 0;
	while(p != nil) {
		p = [p parent];
		if(p!=nil) d++;
	}
	return d;
}

- (void) setName:(NSString *) _name andLabel:(NSString *) _label {
	[self setName:_name];
	[self setLabel:_label];
}

- (BOOL) isChildOfBranches {
	if(parent == nil || [parent name] == nil) return false;
	return [[parent name] isEqual:@"branches"];
}

- (BOOL) isChildOfTags {
	if(parent == nil || [parent name] == nil) return false;
	return [[parent name] isEqual:@"tags"];
}

- (BOOL) isChildOfRemoteBranches {
	if(parent == nil || [parent name] == nil) return false;
	return [[parent name] isEqual:@"remote_branches"];
}

- (BOOL) isChildOfStashes {
	if(parent == nil || [parent name] == nil) return false;
	return [[parent name] isEqual:@"stash"];
}

- (BOOL) isChildOfRemotes {
	if(parent == nil || [parent name] == nil) return false;
	return [[parent name] isEqual:@"remotes"];
}

- (BOOL) isChildOfSubmodules {
	if(parent == nil || [parent name]==nil) return false;
	return [[parent name] isEqual:@"submodules"];
}

- (void) addChild:(GTSourceListItem *) child {
	[children addObject:child];
	[child setParent:self];
}

- (void) removeChild:(GTSourceListItem *) child {
	[children removeObject:child];
	[child setParent:nil];
}

- (void) setChildren:(NSMutableArray *) _children {
	if(children	!= _children) {
		children = _children;
	}
}

- (void) releaseTree {
	//[children release];
	GTSourceListItem * i;
	for(i in children) {
		[i releaseTree];
	}
	GDRelease(children);
	GDRelease(parent);
}

- (BOOL) isGroupItem {
	return isGroupItem;
}

- (NSUInteger) numChildren {
	return [children count];
}

- (GTSourceListItem *) itemAtIndex:(NSUInteger) _index {
	return [children objectAtIndex:_index];
}

- (NSArray *)items
{
	return [NSArray arrayWithArray:children];
}

- (NSString *) description {
	return [@"[GTSourceListItem: " stringByAppendingString:[name stringByAppendingString:@"]"]];
}

- (NSImage *)image {
	NSImage *result = nil;
	if ([self isChildOfRemotes])
		result = [NSImage imageNamed:@"network.png"];
	else
	if ([self isChildOfTags])
		result = [NSImage imageNamed:@"tag.png"];
	else
	if ([self isChildOfBranches])
		result = [NSImage imageNamed:@"branches.png"];
	else
	if ([self isChildOfRemoteBranches])
		result = [NSImage imageNamed:@"branches.png"];
	else
	if ([self isChildOfSubmodules])
		result = [NSImage imageNamed:@"submodule.png"];
	else
	if ([self isChildOfStashes])
		result = [NSImage imageNamed:@"stashes.png"];
		
	if (result)
		[result setFlipped:YES];
	
	return result;
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTSourceListItem\n");
	#endif
	GDRelease(parent);
	GDRelease(children);
	GDRelease(name);
	GDRelease(label);
	GDRelease(data);
	isGroupItem=false;
	index=0;
}

@end
