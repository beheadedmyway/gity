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

#import "GTInsetLabelView.h"

@implementation GTInsetLabelView
@synthesize topLabel;
@synthesize bottomLabel;
@synthesize setsFrameSizeOnLabelUpdate;

- (void) awakeFromNib {
	[super awakeFromNib];
	setsFrameSizeOnLabelUpdate=true;
}

- (id) initWithFrame:(NSRect) frameRect {
	self=[super initWithFrame:frameRect];
	setsFrameSizeOnLabelUpdate=true;
	return self;
}

- (void) setTopLabel:(NSAttributedString *) _label {
	GDRelease(topLabel);
	topLabel=[_label retain];
	if(setsFrameSizeOnLabelUpdate) {
		NSRect fra=[self frame];
		fra.size.width=[topLabel size].width + 1;
		fra.size.height=[topLabel size].height + 1; //accounts for inset pixel
		[self setFrame:fra];
	}
	if(bottomLabel) [self setNeedsDisplay:true];
}

- (void) setBottomLabel:(NSAttributedString *) _label {
	GDRelease(bottomLabel);
	bottomLabel=[_label retain];
	if(setsFrameSizeOnLabelUpdate) {
		NSRect fra=[self frame];
		fra.size.width=[bottomLabel size].width + 1;
		fra.size.height=[bottomLabel size].height + 1; //accounts for inset pixel
		[self setFrame:fra];
	}
	if(topLabel) [self setNeedsDisplay:true];
}

- (void) drawRect:(NSRect) rect {
	if(topLabel is nil or bottomLabel is nil) {
		NSLog(@"ERROR: Either topLabel or bottomLabel in GTInsetLabelView was nil");
		[super drawRect:rect];
		return;
	}
	NSPoint target=rect.origin;
	target.x += 1;
	NSPoint insetTarget=rect.origin;
	insetTarget.x += 1;
	insetTarget.y-=1;
	[topLabel drawAtPoint:target];
	[bottomLabel drawAtPoint:insetTarget];
	[super drawRect:rect];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTInsetLabelView\n");
	#endif
	GDRelease(topLabel);
	GDRelease(bottomLabel);
	setsFrameSizeOnLabelUpdate=false;
	[super dealloc];
}

@end
