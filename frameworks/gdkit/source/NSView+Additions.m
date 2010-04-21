//copyright 2009 aaronsmith

#import "NSView+Additions.h"

@implementation NSView (GDAdditions)

- (void) setAutoresizingBit:(unsigned int) bitMask toValue:(BOOL) set {
	if(set) [self setAutoresizingMask:([self autoresizingMask]|bitMask)];
	else [self setAutoresizingMask:([self autoresizingMask]&~bitMask)];
}

- (void) fixLeftEdge:(BOOL) fixed {
	[self setAutoresizingBit:NSViewMinXMargin toValue:!fixed];
}

- (void) fixRightEdge:(BOOL) fixed {
	[self setAutoresizingBit:NSViewMaxXMargin toValue:!fixed];
}

- (void) fixTopEdge:(BOOL) fixed {
	[self setAutoresizingBit:NSViewMinYMargin toValue:!fixed];
}

- (void) fixBottomEdge:(BOOL) fixed {
	[self setAutoresizingBit:NSViewMaxYMargin toValue:!fixed];
}

- (void) fixWidth:(BOOL) fixed {
	[self setAutoresizingBit:NSViewWidthSizable toValue:!fixed];
}

- (void) fixHeight:(BOOL) fixed {
	[self setAutoresizingBit:NSViewHeightSizable toValue:!fixed];
}

@end
