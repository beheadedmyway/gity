//copyright 2009 aaronsmith

#import "GDBaseWindow.h"
#import "GDDocument.h"
#import "GDApplicationController.h"

@implementation GDBaseWindow
@synthesize gd;
@synthesize externalNibController;

- (void) awakeFromNib{}
- (void) setGDRefs{}
- (void) lazyInit{}

- (void) lazyInitWithGD:(id) _gd {
	if(![_gd isKindOfClass:[GDDocument class]] and ![_gd isKindOfClass:[GDApplicationController class]]) {
		NSLog(@"GDKit Error ([GDBaseWindow lazyInitWithGD:]): The {_gd} property was not a GDDocument or a GDApplicationController");
		return;
	}
	gd=_gd;
	[self setGDRefs];
	[self lazyInit];
}

- (void) keyDown:(NSEvent *) theEvent {
	if([self delegate] and [[self delegate] respondsToSelector:@selector(onEscapeKey:)]) {
		[GDResponderHelper ifIsEscapeKey:theEvent sendAction:@selector(onEscapeKey:) toTarget:[self delegate]];
		[super keyDown:theEvent];
		return;
	}
	if([self respondsToSelector:@selector(onEscapeKey:)]) [GDResponderHelper ifIsEscapeKey:theEvent sendAction:@selector(onEscapeKey:) toTarget:[self self]];
	[super keyDown:theEvent];
}

- (void) dealloc {
	#ifdef GDKIT_PRINT_DEALLOCS
	printf("dealloc GDBaseWindow\n");
	#endif
	[super dealloc];
}

@end
