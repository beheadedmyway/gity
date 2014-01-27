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

#import "GTSearchControl.h"
#import "GittyDocument.h"

@implementation GTSearchControl

- (id) initWithFrame:(NSRect) frame {
	if(self = [super initWithFrame:frame]) {
		[self initControls];
	}
	return self;
}

- (void) initControls {
	searchControlRect = NSMakeRect(0,0,178,21);
	searchControl = [[GTScale9Control alloc] initWithFrame:searchControlRect];
	[searchControl setScaledImage:[NSImage imageNamed:@"searchBG.png"]];
	[searchControl setScaledOverImage:[NSImage imageNamed:@"searchBGOver.png"]];
	[searchControl setTopLeftPoint:NSMakePoint(6,8)];
	[searchControl setBottomRightPoint:NSMakePoint(8,6)];
	[searchControl setIcon:[NSImage imageNamed:@"magnifier.png"]];
	[searchControl setIconPosition:NSMakePoint(6,3)];
	
	searchField = [[NSTextField alloc] initWithFrame:NSMakeRect(20,1,156,17)];
	[searchField setFocusRingType:NSFocusRingTypeNone];
	[searchField setBordered:false];
	[searchField setBackgroundColor:[NSColor clearColor]];
	[searchField setBezeled:false];
	[searchField setDrawsBackground:false];
	[searchField setDelegate:self];
	
	[self addSubview:searchControl];
	[self addSubview:searchField];
}

- (void) controlTextDidChange:(id) sender {
	[gd search:[searchField stringValue]];
}

- (void) dealloc {
	searchControlRect = NSMakeRect(0,0,0,0);
	drawn=false;
}

@end
