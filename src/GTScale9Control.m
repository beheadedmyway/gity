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

#import "GTScale9Control.h"

@implementation GTScale9Control
@synthesize topLeftPoint;
@synthesize bottomRightPoint;

- (void) drawRect:(NSRect) rect {
	if(![self scaledImage]) return;
	if(![self sourceImage]) [self setSourceImage:[self scaledImage]];
	if(![self sourceImage]) return;
	
	NSSize sourceSize = [[self sourceImage] size];
	//Top left
	NSRect topLeftTileRect = NSMakeRect(0, 0, topLeftPoint.x, sourceSize.height - topLeftPoint.y);
	NSRect topLeftCutRect = NSMakeRect(0, topLeftPoint.y, topLeftTileRect.size.width, topLeftTileRect.size.height);
	//TopRight
	NSRect topRightTileRect = NSMakeRect(0,0, sourceSize.width - bottomRightPoint.x, topLeftTileRect.size.height);
	NSRect topRightCutRect = NSMakeRect(sourceSize.width - topRightTileRect.size.width, topLeftPoint.y, topRightTileRect.size.width, topRightTileRect.size.height);
	//Top
	NSRect topTileRect = NSMakeRect(0, 0, sourceSize.width - topLeftTileRect.size.width - topRightTileRect.size.width, topLeftTileRect.size.height);
	NSRect topCutRect = NSMakeRect(topLeftPoint.x, topLeftPoint.y, topTileRect.size.width, topTileRect.size.height);
	//Bottom Left
	NSRect bottomLeftTileRect = NSMakeRect(0, 0, topLeftCutRect.size.width, bottomRightPoint.y);
	NSRect bottomLeftCutRect = NSMakeRect(0, 0, bottomLeftTileRect.size.width, bottomLeftTileRect.size.height);
	//Bottom Right
	NSRect bottomRightTileRect = NSMakeRect(0,0, topRightCutRect.size.width, bottomLeftTileRect.size.height);
	NSRect bottomRightCutRect = NSMakeRect(topRightCutRect.origin.x, 0, bottomRightTileRect.size.width , bottomRightTileRect.size.height );
	//Bottom
	NSRect bottomTileRect = NSMakeRect(0,0, topTileRect.size.width, bottomLeftTileRect.size.height);
	NSRect bottomCutRect = NSMakeRect(topCutRect.origin.x, 0, bottomTileRect.size.width, bottomTileRect.size.height);
	//left
	NSRect leftTileRect = NSMakeRect(0, 0, bottomLeftTileRect.size.width, sourceSize.height - topTileRect.size.height - bottomTileRect.size.height);
	NSRect leftCutRect = NSMakeRect(0, bottomRightPoint.y, leftTileRect.size.width, leftTileRect.size.height);
	//right
	NSRect rightTileRect = NSMakeRect(0, 0, topRightCutRect.size.width, leftCutRect.size.height);
	NSRect rightCutRect = NSMakeRect(bottomRightPoint.x, bottomRightPoint.y, rightTileRect.size.width, rightTileRect.size.height);
	//center
	NSRect centerTileRect = NSMakeRect(0, 0, topTileRect.size.width, leftTileRect.size.height);
	NSRect centerCutRect = NSMakeRect(topCutRect.origin.x, bottomRightPoint.y, centerTileRect.size.width, centerTileRect.size.height);
	
	NSImage *topLeft = [[NSImage alloc] initWithSize:topLeftTileRect.size];
	[topLeft lockFocus];
	[[self sourceImage] drawInRect:topLeftTileRect fromRect:topLeftCutRect operation:NSCompositeCopy fraction:1.0];
	[topLeft unlockFocus];
	
	NSImage *top = [[NSImage alloc] initWithSize:topTileRect.size];
	[top lockFocus];
	[[self sourceImage] drawInRect:topTileRect fromRect:topCutRect operation:NSCompositeCopy fraction:1.0];
	[top unlockFocus];
	
	NSImage *topRight = [[NSImage alloc] initWithSize:topRightTileRect.size];
	[topRight lockFocus];
	[[self sourceImage] drawInRect:topRightTileRect fromRect:topRightCutRect operation:NSCompositeSourceOver fraction:1.0];
	[topRight unlockFocus];
	
	//setup center section, left, right
	NSImage *left = [[NSImage alloc] initWithSize:leftTileRect.size];
	[left lockFocus];
	[[self sourceImage] drawInRect:leftTileRect fromRect:leftCutRect operation:NSCompositeCopy fraction:1.0];
	[left unlockFocus];
	
	NSImage *center = [[NSImage alloc] initWithSize:centerTileRect.size];
	[center lockFocus];
	[[self sourceImage] drawInRect:centerTileRect fromRect:centerCutRect operation:NSCompositeCopy fraction:1.0];
	[center unlockFocus];
	
	NSImage *right = [[NSImage alloc] initWithSize:rightTileRect.size];
	[right lockFocus];
	[[self sourceImage] drawInRect:rightTileRect fromRect:rightCutRect operation:NSCompositeCopy fraction:1.0];
	[right unlockFocus];
	
	NSImage *bottomLeft = [[NSImage alloc] initWithSize:bottomLeftTileRect.size];
	[bottomLeft lockFocus];
	[[self sourceImage] drawInRect:bottomLeftTileRect fromRect:bottomLeftCutRect operation:NSCompositeCopy fraction:1.0];
	[bottomLeft unlockFocus];
	
	NSImage *bottom = [[NSImage alloc] initWithSize:bottomTileRect.size];
	[bottom lockFocus];
	[[self sourceImage] drawInRect:bottomTileRect fromRect:bottomCutRect operation:NSCompositeCopy fraction:1.0];
	[bottom unlockFocus];
	
	NSImage *bottomRight = [[NSImage alloc] initWithSize:bottomRightTileRect.size];
	[bottomRight lockFocus];
	[[self sourceImage] drawInRect:bottomRightTileRect fromRect:bottomRightCutRect operation:NSCompositeCopy fraction:1.0];
	[bottomRight unlockFocus];
	
	NSDrawNinePartImage(NSMakeRect(0,0,[self bounds].size.width,[self frame].size.height),topLeft,top,topRight,left,center,right,bottomLeft,bottom,bottomRight,NSCompositeSourceAtop,1.0,NO);
	
	
	[super drawRect:rect];
}

- (void) dealloc {
	topLeftPoint.x = 0;
	topLeftPoint.y = 0;
	bottomRightPoint.y = 0;
	bottomRightPoint.y = 0;
}

@end
