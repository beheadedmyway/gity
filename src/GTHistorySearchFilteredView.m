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

#import "GTHistorySearchFilteredView.h"
#import "GittyDocument.h"
#import "GTHistoryView.h"

@implementation GTHistorySearchFilteredView

- (void) awakeFromNib {
	[super awakeFromNib];
	//[self setColor:[NSColor colorWithDeviceRed:.94 green:.97 blue:.82 alpha:1]];
	[self setColor:[NSColor colorWithDeviceRed:.98 green:.97 blue:.79 alpha:1]];
	lineView = [[GTLineView alloc] initWithFrame:NSMakeRect(0,0,1,1)];
	[lineView setLineColor:[NSColor colorWithDeviceRed:.7 green:.7 blue:.7 alpha:1]];
	[lineView setAutoresizingMask:(NSViewWidthSizable)];
	[self initCloseButton];
}

- (void) lazyInitWithGD:(GittyDocument *) _gd {
	[super lazyInitWithGD:_gd];
	historyView=[gd historyView];
}

- (void) show {
	NSView * rightView = [[gd splitContentView] rightView];
	NSRect rf = [rightView frame];
	NSRect sf = [self frame];
	[self setFrameSize:NSMakeSize(rf.size.width,20)];
	[self setFrameOrigin:NSMakePoint(sf.origin.x,rf.size.height-48)];
	[rightView addSubview:self];
	[lineView setFrame:NSMakeRect(0,0,rf.size.width,1)];
	[self addSubview:lineView];
	[self updateFilterLabel];
	[self showCloseButton];
}

- (void) initCloseButton {
	close=[[GTScaledButtonControl alloc] initWithFrame:NSMakeRect(400,4,11,11)];
	[close setIcon:[NSImage imageNamed:@"cancelOver.png"]];
	[close setIconOver:[NSImage imageNamed:@"cancelNormal.png"]];
	[close setAction:@selector(close)];
	[close setTarget:self];
}

- (void) close {
	[historyView clearLoadInfoAndLoadHistory];
}

- (void) showCloseButton {
	//NSSize s = [filterInfo size];
	NSPoint p = NSMakePoint(7,5);
	[close setFrameOrigin:p];
	[self addSubview:close];
}

- (void) updateFilterLabel {
	GTGitCommitLoadInfo * info = [historyView loadInfo];
	NSString * message = @"";
	NSString * tmp = @"";
	if([info matchAll]) message = [message stringByAppendingString:@"(Match All)  "];
	if([info after]) {
		tmp = [@"After: " stringByAppendingString:[info afterDateForDisplay]];
		tmp=[tmp stringByAppendingString:@"  |  "];
		message = [message stringByAppendingString:tmp];
	}
	if([info before]) {
		tmp = [@"Before: " stringByAppendingString:[info beforeDateForDisplay]];
		if([info authorContains] && ![[info authorContains] isEmpty]) tmp = [tmp stringByAppendingString:@"  |  "];
		message = [message stringByAppendingString:tmp];
	}
	if([info authorContains] && ![[info authorContains] isEmpty]) {
		tmp = [@"Author: " stringByAppendingString:[info authorContains]];
		//tmp=[tmp stringByAppendingString:@"  |  "];
		message = [message stringByAppendingString:tmp];
	}
	if(filterInfo) [filterInfo release];
	filterInfo=nil;
	filterInfo=[[GTStyles getFilteredSearchLabel:message] retain];
	[self setNeedsDisplay:true];
}

- (void) drawRect:(NSRect) dirtyRect {
	[super drawRect:dirtyRect];
	[filterInfo drawAtPoint:NSMakePoint(24,3)];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTHistorySearchFilteredView\n");
	#endif
	GDRelease(close);
	GDRelease(filterInfo);
	GDRelease(lineView);
	historyView=nil;
	[super dealloc];
}

@end
