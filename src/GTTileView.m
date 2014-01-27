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

#import "GTTileView.h"

@implementation GTTileView
@synthesize tileImage;

- (void) awakeFromNib {
	[self setTileImage:[NSImage	imageNamed:@"diagonalStripes2.png"]];
}

- (void) drawRect:(NSRect) dirtyRect {
	[NSGraphicsContext saveGraphicsState];
	NSGraphicsContext * context = [NSGraphicsContext currentContext];
	if([self tileImage]) {
		CGContextRef cgcontext = (CGContextRef)[context graphicsPort];
		CGImageRef image = [tileImage CGImageForProposedRect:NULL context:context hints:nil];
		CGRect imageRect;
		imageRect.origin=CGPointMake(0.0,0.0);
		imageRect.size=CGSizeMake([tileImage size].width,[tileImage size].width);
		CGContextClipToRect(cgcontext,CGRectMake(0.0, 0.0,dirtyRect.size.width,dirtyRect.size.height));
		CGContextDrawTiledImage(cgcontext,imageRect,image);
	} else {
		NSLog(@"NO TILE IMAGE");
	}
	[NSGraphicsContext restoreGraphicsState];
	[super drawRect:dirtyRect];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTTileView\n");
	#endif
	GDRelease(tileImage);
}

@end
