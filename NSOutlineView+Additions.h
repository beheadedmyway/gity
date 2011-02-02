//
//  NSOutlineView+Additions.h
//  gitty
//
//  Created by brandon on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSOutlineView(Additions)

- (void)expandParentsOfItem:(id)item;
- (void)selectItem:(id)item;

@end
