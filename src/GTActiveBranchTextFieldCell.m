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

#import "GTActiveBranchTextFieldCell.h"

@implementation GTActiveBranchTextFieldCell

@synthesize file;

- (void) drawInteriorWithFrame:(NSRect) cellFrame inView:(NSView *) controlView {
	cellFrame.origin.x += 5;
	cellFrame.origin.y += 2;
	// file type image
	NSImage *iconImage = nil;
	if (file)
		iconImage = [[NSWorkspace sharedWorkspace] iconForFileType:[file.filename pathExtension]];
	else
		iconImage = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericFolderIcon)];
	
	[iconImage setFlipped:YES];
	
	NSRect destRect = NSMakeRect(cellFrame.origin.x, cellFrame.origin.y - 1, 16, 16);
	NSRect srcRect = NSMakeRect(0, 0, [iconImage size].height, [iconImage size].height);
	[iconImage drawInRect:destRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0];

	cellFrame.origin.x += cellFrame.size.height + 5;
	cellFrame.size.height -= 2;
	// lets do this.
	[super drawInteriorWithFrame:cellFrame inView:controlView];
}

- (void)dealloc
{
	[super dealloc];
}
@end
