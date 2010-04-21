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

#import "GTSourceListMenuView.h"
#import "GittyDocument.h"

@implementation GTSourceListMenuView
@synthesize actionsMenuDelegate;

- (void) lazyInitWithGD:(GittyDocument *) _gd {
	[super lazyInitWithGD:_gd];
	action=[[GTScaledButtonControl alloc] initWithFrame:NSMakeRect(0,0,17,11)];
	[action setIcon:[NSImage imageNamed:@"sourceListAction.png"]];
	[action setIconOver:[NSImage imageNamed:@"sourceListActionOver.png"]];
	[action setIconPosition:NSMakePoint(0,0)];
	[self addSubview:action];
	[self updateDelegateForMenu];
}

- (void) updateDelegateForMenu {
	actionsMenuDelegate=[[GTActionsMenuDelegate alloc] init];
	[actionsMenuDelegate setSourceListMenuView:self];
	[contextMenus updateActionsMenuDelegate];
}

- (void) reset {
	[action resetSources];
}

- (void) mouseDown:(NSEvent *) event {
	[contextMenus invalidateSourceListActionsMenu];
	[NSMenu popUpContextMenu:[[gd contextMenus] actionsMenu] withEvent:event forView:[gd sourceListView]];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTSourceListMenuView\n");
	#endif
	[action removeFromSuperview];
	GDRelease(action);
	GDRelease(actionsMenuDelegate);
	[super dealloc];
}

@end
