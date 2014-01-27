//copyright 2009 aaronsmith

#import "GDBaseObject.h"
#import "GDDocument.h"
#import "GDApplicationController.h"

@implementation GDBaseObject
@synthesize gd;
@synthesize externalNibController;

- (void) awakeFromNib{}
- (void) setGDRefs{}
- (void) lazyInit{}

- (id) init {
	self=[super init];
	#ifdef GDKIT_METHOD_CALLS
	printf("[GDBaseObject init]\n");
	#endif
	return self;
}

- (id) initWithGD:(id) _gd {
	self=[self init];
	if(![_gd isKindOfClass:[GDDocument class]] and ![_gd isKindOfClass:[GDApplicationController class]]) {
		NSLog(@"GDKit Error ([GDBaseObject initWithGD:]): The {_gd} property was not a GDDocument or a GDApplicationController");
		return nil;
	}
	#ifdef GDKIT_METHOD_CALLS
	printf("[GDBaseObject initWithGDDocument:]\n");
	#endif
	gd=_gd;
	[self setGDRefs];
	[self lazyInit];
	return self;
}

- (void) lazyInitWithGD:(id) _gd {
	if(![_gd isKindOfClass:[GDDocument class]] and ![_gd isKindOfClass:[GDApplicationController class]]) {
		NSLog(@"GDKit Error ([GDBaseObject lazyInitWithGD:]): The {_gd} property was not a GDDocument or a GDApplicationController");
		return;
	}
	#ifdef GDKIT_METHOD_CALLS
	printf("[GDBaseObject lazyInitWithGDDocument:]\n");
	#endif
	gd=_gd;
	[self setGDRefs];
	[self lazyInit];
}

- (void) dealloc {
	#ifdef GDKIT_METHOD_CALLS
	printf("[GDBaseObject dealloc]\n");
	#endif
	#ifdef GDKIT_PRINT_DEALLOCS
	printf("dealloc GDBaseObject\n");
	#endif
}

@end
