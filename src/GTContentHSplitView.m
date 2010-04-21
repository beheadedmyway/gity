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

#import "GTContentHSplitView.h"

@implementation GTContentHSplitView

- (void) lazyInitWithGD:(GittyDocument *)_gd {
	[super lazyInitWithGD:_gd];
	[self setDelegate:self];
}

- (void) splitView:(NSSplitView *) sender resizeSubviewsWithOldSize:(NSSize) oldSize {
	NSView * top = [[sender subviews] objectAtIndex:0];
	NSView * bottom = [[sender subviews] objectAtIndex:1];
	float dividerThickness=[sender dividerThickness];
	NSRect newFrame = [sender frame];
	NSRect topFrame = [top frame];
	NSRect bottomFrame = [bottom frame];
	topFrame.size.width	= newFrame.size.width;
	topFrame.origin = NSMakePoint(0,0);
	bottomFrame.size.width = newFrame.size.width;
	bottomFrame.size.height = newFrame.size.height - topFrame.size.height - dividerThickness;
	bottomFrame.origin.y = topFrame.size.height + dividerThickness;
	[top setFrame:topFrame];
	[bottom setFrame:bottomFrame];
}

- (CGFloat) splitView:(NSSplitView *) splitView constrainMaxCoordinate:(CGFloat) proposedMax ofSubviewAt:(NSInteger) dividerIndex {
	return [self frame].size.height-100;
}

- (CGFloat) splitView:(NSSplitView *) splitView constrainMinCoordinate:(CGFloat) proposedMin ofSubviewAt:(NSInteger) dividerIndex {
	return 96;
}

@end
