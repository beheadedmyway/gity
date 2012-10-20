// Copyright Aaron Smith 2009
// 
// This file is part of Gity.
// 
// Gity is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// Gity is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with Gity. If not, see <http://www.gnu.org/licenses/>.

#import "GTBaseExternalNibController.h"
#import "GittyDocument.h"

static NSPoint tl;
static NSPoint tr;

@implementation GTBaseExternalNibController
@synthesize gd;
@synthesize window;

- (void) initButtons {}
- (void) loadNibs {}
- (void) reset {}

- (void) awakeFromNib {
	if(!tl.x) tl=NSMakePoint(8,10);
	if(!tr.x) tr=NSMakePoint(10,8);
	[window setDelegate:self];
}

- (id) initWithGD:(GittyDocument *) _gd {
	self=[self init];
	gd=_gd;
	[self setRefs];
	return self;
}

- (void) lazyInitWithGD:(GittyDocument *) _gd {
	gd=_gd;
	[self setRefs];
}

- (void) setRefs {
	operations=[gd operations];
	gitd=[gd gitd];
	modals=[gd modals];
	git=[gd git];
}

- (NSPoint) getTL {
	return tl;
}

- (NSPoint) getTR {
	return tr;
}

- (void) onEscapeKey:(id) sender {
	[self cancel:nil];
}

- (void) onEscapeKey {
	[self cancel:nil];
}

- (void) show {
	[self loadNibs];
	[self reset];
	[self initButtons];
	[window makeKeyAndOrderFront:nil];
}

- (void) showAsSheet {
	[self loadNibs];
	[self reset];
	[self initButtons];
	[[NSApplication sharedApplication] beginSheet:window modalForWindow:[gd gtwindow] modalDelegate:self didEndSelector:@selector(sheetEnded) contextInfo:nil];
}

- (void) showAsSheetWithCallback:(id) _target action:(SEL) _action {
	target=_target;
	action=_action;
	[self showAsSheet];
}

- (void) sheetEnded {
	[self disposeNibs];
}

- (void) cancel:(id) sender {
	if(working) {
		NSBeep();
		return;
	}
	[self disposeNibs];
}

- (void) onok:(id) sender {
	if(working) {
		NSBeep();
		return;
	}
}

- (void) disposeNibs {
	if(!available) return;
	available=false;
	working=false;
	if(window) {
		if([window isSheet]) [[NSApplication sharedApplication] endSheet:window];
		[window orderOut:nil];
		[window release];
	}
	if(ok)[ok release];
	if(cancel)[cancel release];
	ok=nil;
	cancel=nil;
	window=nil;
}

- (void) dealloc {
	gd=nil;
	target=nil;
	action=nil;
	available=false;
	window=nil;
	if(ok)[ok release];
	if(cancel)[cancel release];
	ok=nil;
	cancel=nil;
	[super dealloc];
}

@end
