//copyright 2009 aaronsmith

#import "GDExternalNibController.h"
#import "GDDocument.h"
#import "GDApplicationController.h"
#import "GDWindowController.h"

@implementation GDExternalNibController
@synthesize windows;
@synthesize callback;
@synthesize nibName;
@synthesize disposesNibsOnWindowClose;
@synthesize disposesNibsOnEscapeKey;

- (void) reset {}

- (void) windowWillClose:(NSNotification *) notification {
	if(isSheet) return;
	if(disposesNibsOnWindowClose) [self disposeNibs];
}

- (id) initWithGD:(id) _gd andNibName:(NSString *) _nibName {
	self = [super init];
	[super lazyInitWithGD:_gd];
	[self setNibName:_nibName];
	return self;
}

- (void) lazyInitWithGD:(id) _gd andNibName:(NSString *) _nibName {
	[super lazyInitWithGD:_gd];
	[self setNibName:_nibName];
}

- (void) lazyInitWithGD:(id) _gd andNibName:(NSString *) _nibName andCallback:(GDCallback *) _callback {
	[super lazyInitWithGD:_gd];
	[self setNibName:_nibName andCallback:_callback];
}

- (id) initWithGD:(id) _gd andNibName:(NSString *) _nibName andCallback:(GDCallback *) _callback {
	self=[super init];
	[super lazyInitWithGD:_gd];
	[self setNibName:_nibName andCallback:_callback];
	return self;
}

- (void) setNibName:(NSString *) _nibName andCallback:(GDCallback *) _callback {
	[self setNibName:_nibName];
	[self setCallback:_callback];
}

- (void) loadNibs {
	if(available)return;
	NSAssert(!(nibName is nil), @"An external nib controller tried to load nibs but the nibName property isn't set");
	[NSBundle loadNibNamed:nibName owner:self];
	available=true;
}

- (void) prepare {
	[self loadNibs];
}

- (void) show {
	if(!isSheet and available and windows and [windows mainWindow] and [[windows mainWindow] isVisible]) return;
	if(available && isSheet) {
		switchingToWindow=true;
		[self resetSwitchFlags];
	}
	isSheet=false;
	[self closeWindows];
	[self loadNibs];
	[self reset];
	[[windows mainWindow] makeKeyAndOrderFront:nil];
}

- (void) showAsSheetForWindow:(NSWindow *) _window {
	if(isSheet) return;
	if(available and !isSheet) {
		switchingToSheet=true;
		[self resetSwitchFlags];
	}
	isSheet=true;
	[self closeWindows];
	[self loadNibs];
	[self reset];
	[[NSApplication sharedApplication] beginSheet:[windows mainWindow] modalForWindow:_window modalDelegate:self didEndSelector:@selector(sheetEnded) contextInfo:nil];
}

- (void) setDisposesNibsOnEscapeKey:(BOOL) _disposeOnEscape andDisposesNibsOnWindowClose:(BOOL) _disposeOnWinClose {
	[self setDisposesNibsOnEscapeKey:_disposeOnEscape];
	[self setDisposesNibsOnWindowClose:_disposeOnWinClose];
}

- (void) sheetEnded {
	isSheet=false;
	if(disposesNibsOnWindowClose)[self disposeNibs];
}

- (void) onEscapeKey:(id) sender {
	if(disposesNibsOnEscapeKey)[self close:nil];
}

- (void) close:(id) sender {
	[self disposeNibs];
}

- (void) closeWindows {
	if(windows and [windows mainWindow]) {
		if([[windows mainWindow] isSheet]) [[NSApplication sharedApplication] endSheet:[windows mainWindow]];
		[[windows mainWindow] orderOut:nil];
	}
}

- (void) resetSwitchFlags {
	[NSTimer scheduledTimerWithTimeInterval:.4 target:self selector:@selector(_resetSwitchFlags) userInfo:nil repeats:false];
}

- (void) _resetSwitchFlags {
	switchingToSheet=false;
	switchingToWindow=false;
}

- (void) disposeNibs {
	if(!available || switchingToWindow || switchingToSheet) return;
	available=false;
	[self closeWindows];
	GDRelease(windows);
}

- (void) dealloc {
	#ifdef GDKIT_PRINT_DEALLOCS
	printf("dealloc GDExternalNibController\n");
	#endif
	GDRelease(nibName);
	GDRelease(callback);
	GDRelease(windows);
	available=false;
	isSheet=false;
	switchingToWindow=false;
	switchingToSheet=false;
	[super dealloc];
}

@end
