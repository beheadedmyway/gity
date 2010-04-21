//copyright 2009 aaronsmith

#import "GDBaseView.h"
#import "GDDocument.h"
#import "GDApplicationController.h"

@implementation GDBaseView
@synthesize gd;
@synthesize externalNibController;

- (void) awakeFromNib{}
- (void) setGDRefs{}
- (void) lazyInit{}

- (void) lazyInitWithGD:(id) _gd {
	if(![_gd isKindOfClass:[GDDocument class]] and ![_gd isKindOfClass:[GDApplicationController class]]) {
		NSLog(@"GDKit Error ([GDBaseView lazyInitWithGD:]): The {_gd} property was not a GDDocument or a GDApplicationController");
		return;
	}
	gd=_gd;
	[self setGDRefs];
	[self lazyInit];
}

- (void) showInView:(NSView *) view {
	[view addSubview:self];
}

- (void) showMaximizedInView:(NSView *) view {
	NSRect newFrame=[view frame];
	[self setFrame:newFrame];
	[view addSubview:self];
}

- (void) showInView:(NSView *) view withAdjustments:(NSRect) _adjust {
	NSRect newFrame=[view frame];
	newFrame.size.width+=_adjust.size.width;
	newFrame.size.width+=_adjust.size.height;
	newFrame.origin.x+=_adjust.origin.x;
	newFrame.origin.y+=_adjust.origin.y;
	[self setFrame:newFrame];
	[view addSubview:self];
}

- (void) dealloc {
	#ifdef GDKIT_PRINT_DEALLOCS
	printf("dealloc GDBaseView\n");
	#endif
	[super dealloc];
}

@end
