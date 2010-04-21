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

#import "GTScale3Control.h"

@implementation GTScale3Control
@synthesize vertical;
@synthesize edgeSize;

- (void) drawRect:(NSRect) rect {
	if(rect.size.width == 1) return;
	if(![self sourceImage]) [self setSourceImage:[self scaledImage]];
	if(![self sourceImage]) {
		[super drawRect:rect];
		return;
	}
	
	NSRect leftRect;
	NSRect centerRect;
	NSRect rightRect;
	NSRect topRect;
	NSRect bottomRect;
	NSSize ss = [[self sourceImage] size];
	
	if(![self vertical]) {
		leftRect = NSMakeRect(0,0,edgeSize.width,ss.height);
		centerRect = NSMakeRect(edgeSize.width,0,ss.width-edgeSize.width*2,ss.height);
		rightRect = NSMakeRect(leftRect.size.width+centerRect.size.width,0,edgeSize.width,ss.height);
		
		NSImage * leftSlice = [[NSImage alloc] initWithSize:leftRect.size];
		NSRect leftTargetRect = NSMakeRect(0,0,leftRect.size.width,leftRect.size.height);
		[leftSlice lockFocus];
		[[self sourceImage] drawInRect:leftTargetRect fromRect:leftRect operation:NSCompositeCopy fraction:1.0];
		[leftSlice unlockFocus];
		
		NSImage * centerSlice = [[NSImage alloc] initWithSize:centerRect.size];
		NSRect centerTargetRect = NSMakeRect(0,0,centerRect.size.width,centerRect.size.height);
		[centerSlice lockFocus];
		[[self sourceImage] drawInRect:centerTargetRect fromRect:centerRect operation:NSCompositeCopy fraction:1.0];
		[centerSlice unlockFocus];
		
		NSImage * rightSlice = [[NSImage alloc] initWithSize:rightRect.size];
		NSRect rightTargetRect = NSMakeRect(0,0,rightRect.size.width,rightRect.size.height);
		[rightSlice lockFocus];
		[[self sourceImage] drawInRect:rightTargetRect fromRect:rightRect operation:NSCompositeCopy fraction:1.0];
		[rightSlice unlockFocus];
		
		NSDrawThreePartImage(NSMakeRect(0,0,[self bounds].size.width,[self frame].size.height),leftSlice,centerSlice,rightSlice,false,NSCompositeSourceOver,1.0,[self isFlipped]);
		
		[leftSlice release];
		[centerSlice release];
		[rightSlice release];
	} else {
		NSLog(@"VERTICAL NOT IMPLEMENTED IN SCALE 3 CONTROL");
		return;
		topRect = NSMakeRect(0,0,ss.width,edgeSize.height);
		centerRect = NSMakeRect(0,edgeSize.height,ss.width,ss.height-edgeSize.height*2);
		bottomRect = NSMakeRect(0,edgeSize.height+centerRect.size.height,ss.width,edgeSize.height);
		
		NSImage * topSlice = [[NSImage alloc] initWithSize:topRect.size];
		[topSlice lockFocus];
		[[self sourceImage] drawInRect:topRect fromRect:topRect operation:NSCompositeCopy fraction:1.0];
		[topSlice unlockFocus];
		
		NSImage * centerSlice = [[NSImage alloc] initWithSize:centerRect.size];
		[centerSlice lockFocus];
		[[self sourceImage] drawInRect:centerRect fromRect:centerRect operation:NSCompositeCopy fraction:1.0];
		[centerSlice unlockFocus];
		
		NSImage * bottomSlice = [[NSImage alloc] initWithSize:bottomRect.size];
		[bottomSlice lockFocus];
		[[self sourceImage] drawInRect:bottomRect fromRect:bottomRect operation:NSCompositeCopy fraction:1.0];
		[bottomSlice unlockFocus];
		
		NSDrawThreePartImage(rect,topSlice,centerSlice,bottomSlice,true,NSCompositeSourceOver,1.0,[self isFlipped]);
		
		[topSlice release];
		[centerSlice release];
		[bottomSlice release];
	}
	[super drawRect:rect];
}

- (void) dealloc {
	vertical = false;
	edgeSize.width = 0;
	edgeSize.height = 0;
	[super dealloc];
}

@end
