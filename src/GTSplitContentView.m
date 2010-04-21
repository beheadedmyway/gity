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

#import "GTSplitContentView.h"
#import "GittyDocument.h"

@implementation GTSplitContentView

- (void) lazyInitWithGD:(GittyDocument *) _gd {
	[super lazyInitWithGD:_gd];
	[self setDelegate:self];
}

- (CGFloat) splitView:(NSSplitView *) splitView constrainMaxCoordinate:(CGFloat) proposedMax ofSubviewAt:(NSInteger) dividerIndex {
	return 275;
}

- (CGFloat) splitView:(NSSplitView *) splitView constrainMinCoordinate:(CGFloat) proposedMin ofSubviewAt:(NSInteger) dividerIndex {
	return 150;
}

- (void) splitView:(NSSplitView *) sender resizeSubviewsWithOldSize:(NSSize) oldSize {
	//I initially found this here: [h]ttp://snipplr.com/view/2452/resize-nssplitview-nicely
	//I've modified most of this to do what I want.
	NSView *left = [[sender subviews] objectAtIndex:0];
	NSView *right = [[sender subviews] objectAtIndex:1];
	float dividerThickness=[sender dividerThickness];
	NSRect newFrame = [sender frame];
	NSRect leftFrame = [left frame];
	NSRect rightFrame = [right frame];
	leftFrame.size.height = newFrame.size.height;
	leftFrame.origin = NSMakePoint(0,0);
	rightFrame.size.width = newFrame.size.width - leftFrame.size.width - dividerThickness;
    rightFrame.size.height = newFrame.size.height;
    rightFrame.origin.x = leftFrame.size.width + dividerThickness;
	[left setFrame:leftFrame];
    [right setFrame:rightFrame];
}

- (void) show {
	NSView * cv = [gtwindow contentView];
	NSRect cvr = [cv frame];
	NSRect nf = NSMakeRect(0,22,cvr.size.width,cvr.size.height-22);
	[self setFrame:nf];
	[[gtwindow contentView] addSubview:self];
	NSRect f = [[self leftView] frame];
	NSRect lvf = NSMakeRect(f.origin.x,f.origin.y,175,f.size.height);
	[[self leftView] setFrame:lvf];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTSplitContentView\n");
	#endif
	[super dealloc];
}

@end
