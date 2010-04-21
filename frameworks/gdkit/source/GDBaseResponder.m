//copyright 2009 aaronsmith

#import "GDBaseResponder.h"
#import "GDDocument.h"
#import "GDApplicationController.h"

@implementation GDBaseResponder

- (void) awakeFromNib{}
- (void) setGDRefs{}
- (void) lazyInit{}
- (void) onEscapeKey:(id)sender{}

- (id) init {
	self=[super init];
	return self;
}

- (void) keyDown:(NSEvent *) theEvent {
	[GDResponderHelper ifIsEscapeKey:theEvent sendAction:@selector(onEscapeKey:) toTarget:self];
	[super keyDown:theEvent];
}

- (void) lazyInitWithGD:(id) _gd {
	if(![_gd isKindOfClass:[GDDocument class]] and ![_gd isKindOfClass:[GDApplicationController class]]) {
		NSLog(@"GDKit Error ([GDBaseResponder lazyInitWithGD:]): The {_gd} property was not a GDDocument or a GDApplicationController");
		return;
	}
	gd=_gd;
	[self setGDRefs];
	[self lazyInit];
}

- (void) dealloc {
	#ifdef GDKIT_PRINT_DEALLOCS
	printf("dealloc GDBaseResponder\n");
	#endif
	[super dealloc];
}

@end
