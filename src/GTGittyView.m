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

#import "GTGittyView.h"
#import "GittyDocument.h"
#import "GTDocumentController.h"

static NSFileManager * fileManager;
static NSPoint tl;
static NSPoint tr;

@implementation GTGittyView

- (void) awakeFromNib {
	if(fileManager is nil)fileManager=[NSFileManager defaultManager];
	if(!tl.x) tl=NSMakePoint(8,10);
	if(!tr.x) tr=NSMakePoint(10,8);
}

- (void) lazyInitWithGD:(GittyDocument *) _gd {
	[super lazyInitWithGD:_gd];
	[self setGDRefs];
}

- (NSPoint) getTL {
	return tl;
}

- (NSPoint) getTR {
	return tr;
}

- (void) setGDRefs {
	git=[gd git];
	gitd=[gd gitd];
	status=[gd status];
	contextMenus=[gd contextMenus];
	mainMenuHelper=[gd mainMenuHelper];
	operations=[gd operations];
	modals=[gd modals];
	gtwindow=[gd gtwindow];
}

- (void) show {
	[[[gtwindow contentView] superview] addSubview:self];
}

- (void) showInView:(NSView *) _view {
	NSRect rvf=[_view frame];
	NSRect nf=NSMakeRect(0,0,floor(rvf.size.width),floor(rvf.size.height));
	[self setFrame:nf];
	[_view addSubview:self];
}

- (void) showInView:(NSView *) _view withAdjustments:(NSRect) _adjust {
	NSRect rvf=[_view frame];
	NSRect nf=NSMakeRect(0+floor(_adjust.origin.x),0+floor(_adjust.origin.y),floor(rvf.size.width)+floor(_adjust.size.width),floor(rvf.size.height)+floor(_adjust.size.height));
	[self setFrame:nf];
	[_view addSubview:self];
}

- (void) hide {
	[self removeFromSuperview];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTGittyView\n");
	#endif
	git=nil;
	gitd=nil;
	status=nil;
	contextMenus=nil;
	gtwindow=nil;
	modals=nil;
	operations=nil;
	mainMenuHelper=nil;
	[super dealloc];
}

@end
