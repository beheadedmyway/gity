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

#import <Cocoa/Cocoa.h>
#import "defs.h"

@interface GTScaledButtonControl : NSControl {
	id __unsafe_unretained target;
	SEL action;
	BOOL sendsOnUp;
	BOOL mover;
	BOOL mdown;
	BOOL pushedDown;
	BOOL isPushButton;
	BOOL isPlainImageButton;
	NSImage * __weak sourceImage;
	NSImage * __weak sourceIcon;
	NSAttributedString * __weak sourceTitle;
	NSTrackingRectTag trackingTag;
	NSPoint attributedTitlePosition;
	NSAttributedString * attributedTitleDown;
	NSAttributedString * attributedTitleOver;
	NSAttributedString * attributedTitle;
	NSImage * iconDown;
	NSImage * iconOver;
	NSImage * icon;
	NSPoint iconPosition;
	NSImage * scaledImage;
	NSImage * scaledDownImage;
	NSImage * scaledOverImage;
}

@property (unsafe_unretained,nonatomic) id target;
@property (assign,nonatomic) SEL action;
@property (assign,nonatomic) BOOL isPushButton;
@property (strong,nonatomic) NSImage * scaledImage;
@property (strong,nonatomic) NSImage * scaledOverImage;
@property (strong,nonatomic) NSImage * scaledDownImage;
@property (strong,nonatomic) NSImage * icon;
@property (strong,nonatomic) NSImage * iconOver;
@property (strong,nonatomic) NSImage * iconDown;
@property (assign,nonatomic) NSPoint iconPosition;
@property (strong,nonatomic) NSAttributedString * attributedTitle;
@property (strong,nonatomic) NSAttributedString * attributedTitleOver;
@property (strong,nonatomic) NSAttributedString * attributedTitleDown;
@property (assign,nonatomic) NSPoint attributedTitlePosition;
@property (weak,nonatomic) NSImage * sourceImage;
@property (weak,nonatomic) NSAttributedString * sourceTitle;
@property (weak,nonatomic) NSImage * sourceIcon;
@property (assign,nonatomic) BOOL isPlainImageButton;

- (void) sendsActionOnMouseUp:(BOOL) sends;
- (void) pushDown;
- (void) pushUp;
- (void) reset;
- (void) resetSources;
- (BOOL) isDown;

@end
