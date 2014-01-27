//copyright 2009 aaronsmith

#import "GDDocument.h"

@implementation GDDocument
@synthesize model;
@synthesize mainMenu;
@synthesize modals;
@synthesize operations;
@synthesize sounds;
@synthesize views;
@synthesize wins;
@synthesize drawers;
@synthesize contexts;

- (void) awakeFromNib {
	if(awokeFromNib)return;
	awokeFromNib=true;
	documentHasBeenActive=false;
	if(model) {
		NSLog(@"GDKit Error (GDDocument): The {model} property cannot be set from a nib");
		model=nil;
	}
	if(operations) {
		NSLog(@"GDKit Error (GDDocument): The {operations} property cannot be set from a nib");
		operations=nil;
	}
	if(mainMenu) {
		NSLog(@"GDKit Error (GDDocument): The {mainMenu} property cannot be set from a nib");
		mainMenu=nil;
	}
	if(modals) {
		NSLog(@"GDKit Error (GDDocument): The {modals} property cannot be set from a nib");
		modals=nil;
	}
	if(sounds) {
		NSLog(@"GDKit Error (GDDocument): The {sounds} property cannot be set from a nib");
		sounds=nil;
	}
}

- (void) initModel {}
- (void) initViews {}
- (void) initWindows {}
- (void) initControllers {}
- (void) startDocument {}

- (void) lazyInitWithModel:(id) _model mainMenu:(id) _mainMenu modals:(id) _modals operations:(id) _operations windows:(id) _windows drawers:(id) _drawers views:(id) _views sounds:(id) _sounds contexts:(id) _contexts {
	if(drawers and drawers neq _drawers)GDRelease(drawers);
	if(drawers is nil and _drawers neq nil)drawers=_drawers;
	if(views and views neq _views)GDRelease(views);
	if(views is nil and _views neq nil)views=_views;
	if(model and model neq _model)GDRelease(model);
	if(model is nil and _model neq nil)model=_model;
	if(modals and modals neq _modals)GDRelease(modals);
	if(modals is nil and _modals neq nil)modals=_modals;
	if(sounds and sounds neq _sounds)GDRelease(sounds);
	if(sounds is nil and _sounds neq nil)sounds=_sounds;
	if(operations and operations neq _operations)GDRelease(operations);
	if(operations is nil and _operations neq nil)operations=_operations;
	if(mainMenu and mainMenu neq _mainMenu)GDRelease(mainMenu);
	if(mainMenu is nil and _mainMenu neq nil)mainMenu=_mainMenu;
	if(wins and wins neq _windows)GDRelease(wins);
	if(wins is nil and _windows neq nil)wins=_windows;
	if(contexts and contexts neq _contexts)GDRelease(contexts);
	if(contexts is nil and _contexts neq nil)contexts=_contexts;
	if(drawers neq nil)[drawers performSelector:@selector(lazyInitWithGD:) withObject:self];
	if(views neq nil)[views performSelector:@selector(lazyInitWithGD:) withObject:self];
	if(model neq nil)[model performSelector:@selector(lazyInitWithGD:) withObject:self];
	if(modals neq nil)[modals performSelector:@selector(lazyInitWithGD:) withObject:self];
	if(operations neq nil)[operations performSelector:@selector(lazyInitWithGD:) withObject:self];
	if(mainMenu neq nil)[mainMenu performSelector:@selector(lazyInitWithGD:) withObject:self];
	if(wins neq nil)[wins performSelector:@selector(lazyInitWithGD:) withObject:self];
	if(contexts neq nil)[contexts performSelector:@selector(lazyInitWithGD:) withObject:self];
}

- (void) windowControllerDidLoadNib:(NSWindowController *) aController {
	[super windowControllerDidLoadNib:aController];
	[self initDocument];
}

- (void) windowDidBecomeMain:(NSNotification *) notification {
	if(documentHasBeenActive and mainMenu)[mainMenu invalidate];
	if(!documentHasBeenActive)documentHasBeenActive=true;
}

- (void) initDocument {
	[self initModel];
	[self initControllers];
	[self initWindows];
	[self initViews];
	[self startDocument];
}

- (void) dealloc {
	#ifdef GDKIT_PRINT_DEALLOCS
	printf("dealloc GDDocument\n");
	#endif
	GDRelease(drawers);
	GDRelease(views);
	GDRelease(model);
	GDRelease(modals);
	GDRelease(sounds);
	GDRelease(operations);
	GDRelease(mainMenu);
	GDRelease(wins);
	GDRelease(contexts);
	awokeFromNib=false;
	documentHasBeenActive=false;
}

@end
