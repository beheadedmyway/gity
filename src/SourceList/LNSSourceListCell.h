//copyright aaronsmith 2009

#import <Cocoa/Cocoa.h>
#import <GDKit/GDKit.h>
#import "GTSourceListItem.h"
#import "GTSourceListView.h"

@interface LNSSourceListCell : NSTextFieldCell {
	GTSourceListItem *	objectValue;
	NSRect firstRect;
}

@property (retain,nonatomic) GTSourceListItem * objectValue;

- (void) clearFirstRect;

@end
