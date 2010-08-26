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

#import "GTWindow.h"

@implementation GTWindow

- (id) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)windowStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation {
	[super initWithContentRect:contentRect styleMask:windowStyle backing:bufferingType defer:deferCreation];
	[self setAcceptsMouseMovedEvents:TRUE];
	return self;
}

- (void) awakeFromNib {
	[super awakeFromNib];
	[self setContentBorderThickness:22 forEdge:NSMinYEdge];
}

- (void) keyDown:(NSEvent *) theEvent {
	if([theEvent keyCode] == 53) {
		if([[self delegate] respondsToSelector:@selector(onEscapeKey)]) {
			[[self delegate] performSelector:@selector(onEscapeKey)];
		}
		else if([self respondsToSelector:@selector(onEscapeKey)]) {
			[self performSelector:@selector(onEscapeKey)];
		}
	}
	[super keyDown:theEvent];
}

- (BOOL) acceptsFirstResponder {
	return YES;
}

- (BOOL) canBecomeKeyWindow {
    return YES;
}

@end
