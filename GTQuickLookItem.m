//
//  GTQuickLookItem.m
//  gitty
//
//  Created by brandon on 12/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GTQuickLookItem.h"


@implementation GTQuickLookItem

- (id)initWithPath:(NSString *)path
{
	self = [super init];
	
	pathItem = path;
	
	return self;
}


- (NSURL *)previewItemURL
{
	return [NSURL fileURLWithPath:pathItem];
}


@end
