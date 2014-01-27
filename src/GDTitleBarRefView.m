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

#import "GDTitleBarRefView.h"

@implementation GDTitleBarRefView

- (void) lazyInitWithGD:(GittyDocument *) _gd {
	[super initWithGD:_gd];
	[self initMenus];
	hasSetIcon=false;
	[self initButton];
}

- (void) initMenus {
	refMenu = [[NSMenu alloc] init];
	tagsMenuItem = [[NSMenuItem alloc] init];
	branchesMenuItem = [[NSMenuItem alloc] init];
	remoteBranchesMenuItem = [[NSMenuItem alloc] init];
	[tagsMenuItem setTitle:@"Tags"];
	[branchesMenuItem setTitle:@"Branches"];
	[remoteBranchesMenuItem setTitle:@"Remote Branches"];
	[refMenu addItem:branchesMenuItem];
	[refMenu addItem:remoteBranchesMenuItem];
	[refMenu addItem:tagsMenuItem];
}

- (void) initButton {
	NSPoint tl = NSMakePoint(7,8);
	NSPoint br = NSMakePoint(8,7);
	dropDown = [[GTScale9Control alloc] initWithFrame:NSMakeRect(0,0,100,20)];
	[dropDown setTopLeftPoint:tl];
	[dropDown setBottomRightPoint:br];
	[dropDown setScaledImage:[NSImage imageNamed:@"stateDropDownNormal.png"]];
	[dropDown setScaledOverImage:[NSImage imageNamed:@"stateDropDownOver.png"]];
	NSLog(@"initButton %@ %@", dropDown, [NSImage imageNamed:@"stateDropDownNormal.png"]);
	[self addSubview:dropDown];
}

/*- (void) updateButtonWithTitle:(NSString *) _title {
	NSRect sf = [self frame];
	//update title.
	int nw;
	[dropDown setFrame:NSMakeRect(sf.origin.x,sf.origin.y,nw,sf.size.height)];
	//[self updateIconPosition];
}*/ // appears to be unused.
	 
- (void) updateIconPosition {
	if(!hasSetIcon) {
		[dropDown setIcon:[NSImage imageNamed:@"stateDropDownArrowNormal.png"]];
		[dropDown setIconOver:[NSImage imageNamed:@"stateDropDownArrowOver.png"]];
	}
	NSSize ds = [dropDown frame].size;
	[dropDown setIconPosition:NSMakePoint(ds.width-8,8)];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GDTitleBarRefView\n");
	#endif
	GDRelease(tagsMenuItem);
	GDRelease(branchesMenuItem);
	GDRelease(remoteBranchesMenuItem);
	GDRelease(refMenu);
}

@end
