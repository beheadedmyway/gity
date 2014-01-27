//copyright aaronsmith 2009

#import <Cocoa/Cocoa.h>
@class GittyDocument;

typedef enum {
	kSourceList_iTunesAppearance,//gradient selection backgrounds
	kSourceList_NumbersAppearance//flat selection backgrounds
} AppearanceKind;

@interface LNSSourceListView : NSOutlineView {
	AppearanceKind	appearance;
	GittyDocument * __weak gd;
}

@property (assign,nonatomic) AppearanceKind appearance;
@property (weak,nonatomic) GittyDocument * gd;

@end
