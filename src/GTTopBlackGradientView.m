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

#import "GTTopBlackGradientView.h"

@implementation GTTopBlackGradientView

- (void) awakeFromNib {
	NSColor * color1 = [NSColor colorWithDeviceRed:0.133 green:0.133 blue:0.133 alpha:1.0];
	NSColor * color2 = [NSColor colorWithDeviceRed:0.235 green:0.235 blue:0.235 alpha:1.0];
	NSArray * colors = [NSArray arrayWithObjects:color1,color2,nil];
	NSGradient * grad = [[[NSGradient alloc] initWithColors:colors] autorelease];
	[self setGradient:grad];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTTopBlackGradientView\n");
	#endif
	[super dealloc];
}

@end

@implementation GTTopErrorGradientView

- (void) awakeFromNib {
	NSColor * color1 = [NSColor colorWithDeviceRed:0.333 green:0.133 blue:0.133 alpha:1.0];
	NSColor * color2 = [NSColor colorWithDeviceRed:0.535 green:0.235 blue:0.235 alpha:1.0];
	NSArray * colors = [NSArray arrayWithObjects:color1,color2,nil];
	NSGradient * grad = [[[NSGradient alloc] initWithColors:colors] autorelease];
	[self setGradient:grad];
}

- (void) dealloc {
#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTTopBlackGradientView\n");
#endif
	[super dealloc];
}

@end
