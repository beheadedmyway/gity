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

#import "GTLineView.h"

@implementation GTLineView
@synthesize lineColor;
@synthesize isVertical;

- (void) drawRect:(NSRect) dirtyRect {
	if(lineColor is nil) {
		[super drawRect:dirtyRect];
		return;
	}
	[NSGraphicsContext saveGraphicsState];
	[lineColor setFill];
	if(isVertical) [NSBezierPath fillRect:NSMakeRect(dirtyRect.origin.x,dirtyRect.origin.y,1,dirtyRect.size.height)];
	else [NSBezierPath fillRect:NSMakeRect(dirtyRect.origin.x,dirtyRect.origin.y,dirtyRect.size.width,1)];
	[NSGraphicsContext restoreGraphicsState];
	[super drawRect:dirtyRect];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTLineView\n");
	#endif
	GDRelease(lineColor);
	isVertical=false;
	[super dealloc];
}

@end
