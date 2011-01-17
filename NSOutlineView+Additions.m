//
//  NSOutlineView+Additions.m
//  gitty
//
//  Created by brandon on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSOutlineView+Additions.h"


@implementation NSOutlineView(Additions)

- (void)expandParentsOfItem:(id)item 
{
    while (item != nil)
	{
        id parent = [self parentForItem: item];
        if (![self isExpandable: parent])
            break;
        if (![self isItemExpanded: parent])
            [self expandItem: parent];
        item = parent;
    }
}

- (void)selectItem:(id)item 
{
    NSInteger itemIndex = [self rowForItem:item];
    if (itemIndex < 0)
	{
        [self expandParentsOfItem: item];
        itemIndex = [self rowForItem:item];
        if (itemIndex < 0)
            return;
    }
	
    [self selectRowIndexes:[NSIndexSet indexSetWithIndex:itemIndex] byExtendingSelection:NO];
}

@end
