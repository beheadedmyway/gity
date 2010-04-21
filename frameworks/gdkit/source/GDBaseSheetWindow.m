//copyright 2009 aaronsmith

#import "GDBaseSheetWindow.h"
#import "GDDocument.h"
#import "GDApplicationController.h"

@implementation GDBaseSheetWindow

- (void) onEscapeKey:(id) sender {
	if([self isSheet]) [[NSApplication sharedApplication] endSheet:self];
	[self orderOut:self];
}

- (void) dealloc {
	#ifdef GDKIT_PRINT_DEALLOCS
	printf("dealloc GDBaseSheetWindow\n");
	#endif
	[super dealloc];
}

@end
