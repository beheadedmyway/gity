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

#import "GTSplitView.h"
#import "GittyDocument.h"

@implementation GTSplitView

- (void) lazyInitWithGD:(GittyDocument *) _gd {
	gd=_gd;
	gtwindow=[gd gtwindow];
}

- (id) topView {
	NSArray * subs = [self subviews];
	return [subs objectAtIndex:0];
}

- (id) bottomView {
	NSArray * subs = [self subviews];
	return [subs objectAtIndex:1];
}

- (id) leftView {
	NSArray * subs = [self subviews];
	return [subs objectAtIndex:0];
}

- (id) rightView {
	NSArray * subs = [self subviews];
	return [subs objectAtIndex:1];
}

- (void) show {
	[[[gtwindow contentView] superview] addSubview:self];
}

- (void) showInView:(NSView *) _view {
	NSRect rvf = [_view frame];
	NSRect nf=NSMakeRect(0,0,floor(rvf.size.width),floor(rvf.size.height));
	[self setFrame:nf];
	[_view addSubview:self];
}

- (void) showInView:(NSView *) _view withAdjustments:(NSRect) _adjust {
	NSRect rvf=[_view frame];
	NSRect nf=NSMakeRect(0+floor(_adjust.origin.x),0+floor(_adjust.origin.y),floor(rvf.size.width)+floor(_adjust.size.width),floor(rvf.size.height)+floor(_adjust.size.height));
	[self setFrame:nf];
	[_view addSubview:self];
}

@end
