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

#import "GTScaledButtonControl.h"

@implementation GTScaledButtonControl
@synthesize scaledImage;
@synthesize scaledOverImage;
@synthesize scaledDownImage;
@synthesize icon;
@synthesize iconOver;
@synthesize iconDown;
@synthesize iconPosition;
@synthesize attributedTitle;
@synthesize attributedTitleOver;
@synthesize attributedTitleDown;
@synthesize attributedTitlePosition;
@synthesize target;
@synthesize action;
@synthesize isPushButton;
@synthesize sourceImage;
@synthesize sourceTitle;
@synthesize sourceIcon;
@synthesize isPlainImageButton;

- (void) reset {
	mdown=false;
	mover=false;
	pushedDown=false;
	[self setNeedsDisplay:true];
}

- (void) resetSources {
	[self setSourceIcon:nil];
	[self setSourceImage:nil];
	[self setSourceTitle:nil];
	[self reset];
}

- (void) pushDown {
	pushedDown=true;
	[self setSourceImage:[self scaledDownImage]];
	[self setNeedsDisplay:true];
}

- (void) pushUp {
	pushedDown=false;
	if(mover)[self setSourceImage:[self scaledOverImage]];
	else [self setSourceImage:[self scaledImage]];
	[self setNeedsDisplay:true];
}

- (void) setAttributedTitle:(NSAttributedString *) title {
	if(attributedTitle neq title) {
		attributedTitle = title;
	}
	[self setSourceTitle:nil];
}

- (void) setAttributedTitleDown:(NSAttributedString *) title {
	if(attributedTitleDown neq title) {
		attributedTitleDown = title;
	}
	[self setSourceTitle:nil];
}

- (void) setAttributedTitleOver:(NSAttributedString *) title {
	if(attributedTitleOver neq title) {
		attributedTitleOver = title;
	}
	[self setSourceTitle:nil];
}

- (void) setIcon:(NSImage *) _icon {
	if(icon neq _icon) {
		icon = _icon;
	}
	[self setSourceIcon:nil];
}

- (void) setIconOver:(NSImage *) _icon {
	if(iconOver neq _icon) {
		iconOver = _icon;
	}
	[self setSourceIcon:nil];
}

- (void) setIconDown:(NSImage *) _icon {
	if(iconDown neq _icon) {
		iconDown = _icon;
	}
	[self setSourceIcon:nil];
}

- (void) setScaledImage:(NSImage *) _image {
	if(scaledImage neq _image) {
		scaledImage = _image;
	}
	[self setSourceImage:nil];
}

- (void) setScaledOverImage:(NSImage *) _image {
	if(scaledOverImage neq _image) {
		scaledOverImage = _image;
	}
	[self setSourceImage:nil];
}

- (void) setScaledDownImage:(NSImage *) _image {
	if(scaledDownImage neq _image) {
		scaledDownImage = _image;
	}
	[self setSourceImage:nil];
}

- (BOOL) isEventInViewBounds:(NSEvent *)event
{
	NSPoint eventLocation = [event locationInWindow];
	NSPoint localPoint = [self convertPoint:eventLocation fromView:nil];
	if (NSPointInRect(localPoint, [self bounds]))
		return TRUE;
	return FALSE;
}

- (void) viewDidMoveToWindow {
	trackingTag = [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];
}

- (void) updateTrackingAreas {
	trackingTag = [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];
	[super updateTrackingAreas];
}

- (void) sendsActionOnMouseUp:(BOOL) sends {
	sendsOnUp = sends;
}

- (BOOL) autoresizesSubviews {
	return YES;
}

- (void) removeFromSuperview {
	mdown=false;
	mover=false;
	if([self isPushButton] && pushedDown) {
		[super removeFromSuperview];
		return;
	}
	[self setSourceImage:[self scaledImage]];
	[self setSourceIcon:[self icon]];
	[self setSourceTitle:[self attributedTitle]];
	[self removeTrackingRect:trackingTag];
	[self setNeedsDisplay:true];
	[super removeFromSuperview];
}

- (void) mouseDown:(NSEvent *) theEvent {
	mdown=true;
	pushedDown = !pushedDown;
	sourceImage = [self scaledDownImage];
	if([self iconDown]) [self setSourceIcon:[self iconDown]];
	if([self attributedTitleDown]) [self setSourceTitle:[self attributedTitleDown]];
	[self setNeedsDisplay:TRUE];
	if(!sendsOnUp)[[self target] performSelector:action withObject:self];
	[super mouseDown:theEvent];
}

- (void) mouseUp:(NSEvent *) theEvent {
	if (![self isEventInViewBounds:theEvent])
		return;
	if([self isPushButton] && pushedDown) return;
	mdown=false;
	if([self icon]) [self setSourceIcon:[self icon]];
	if(mover && [self scaledOverImage]) [self setSourceImage:[self scaledOverImage]];
	else [self setSourceImage:[self scaledImage]];
	if(mover && [self attributedTitleOver]) [self setSourceTitle:[self attributedTitleOver]];
	else [self setSourceTitle:[self attributedTitle]];
	[self setNeedsDisplay:TRUE];
	if(sendsOnUp)[[self target] performSelector:action withObject:self];
	[super mouseUp:theEvent];
}

- (void) mouseEntered:(NSEvent *) theEvent {
	if([self isPushButton] && pushedDown) return;
	mover=true;
	[self setSourceImage:[self scaledOverImage]];
	if([self iconOver]) [self setSourceIcon:[self iconOver]];
	if([self attributedTitleOver]) [self setSourceTitle:[self attributedTitleOver]];
	[self setNeedsDisplay:TRUE];
	[super mouseEntered:theEvent];
}

- (void) mouseExited:(NSEvent *) theEvent {
	mover=false;
	mdown=false;
	if([self isPushButton] && pushedDown) return;
	[self setSourceImage:[self scaledImage]];
	[self setSourceIcon:[self icon]];
	[self setSourceTitle:[self attributedTitle]];
	[self setNeedsDisplay:TRUE];
	[super mouseExited:theEvent];
}

- (void) performClick:(id) sender {
	[self mouseDown:nil];
	[self mouseUp:nil];
}

- (BOOL) isDown {
	if([self isPushButton] && pushedDown) return true;
	return false;
}

- (void) drawRect:(NSRect) rect {
	[super drawRect:rect];
	if(![self sourceIcon]) [self setSourceIcon:[self icon]];
	if(![self iconPosition].x) [self setIconPosition:NSMakePoint(0,0)];
	if([self sourceIcon]) [[self sourceIcon] drawAtPoint:[self iconPosition] fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
	if(![self sourceTitle]) [self setSourceTitle:[self attributedTitle]];
	if([self isPushButton] && pushedDown && attributedTitleDown) [self setSourceTitle:[self attributedTitleDown]];
	if(!attributedTitlePosition.x) attributedTitlePosition = NSMakePoint(0,0);
	if([self sourceTitle]) [[self sourceTitle] drawAtPoint:[self attributedTitlePosition]];
	if([self isPlainImageButton]) { //draw image components like normal images.
		if([self sourceImage]) {
			NSSize ims = [[self sourceImage] size];
			[[self sourceImage] drawInRect:NSMakeRect(0,0,ims.width,ims.height) fromRect:rect operation:NSCompositeSourceOver fraction:1];
		}
	}
}

- (void) dealloc {
	[self setSourceImage:nil];
	[self setScaledImage:nil];
	[self setScaledOverImage:nil];
	[self setScaledDownImage:nil];
	[self setSourceIcon:nil];
	[self setIconOver:nil];
	[self setIconDown:nil];
	[self setSourceTitle:nil];
	[self setAttributedTitleOver:nil];
	[self setAttributedTitleDown:nil];
	[self setIsPushButton:false];
	[self setTarget:nil];
	[self setAction:nil];
	sendsOnUp = false;
	mover = false;
	mdown = false;
	pushedDown = false;
	isPushButton = false;
}

@end
