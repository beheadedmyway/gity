//
//  GTQuickLookItem.h
//  gitty
//
//  Created by brandon on 12/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>
#import <Quartz/Quartz.h>

@interface GTQuickLookItem : NSObject <QLPreviewItem> {
	NSString *pathItem;
}

- (id)initWithPath:(NSString *)path;

@end
