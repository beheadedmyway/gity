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

#import "GTRemoteView.h"
#import "GittyDocument.h"

@implementation GTRemoteView

- (void) awakeFromNib {
	//[scale9View setSourceImage:[NSImage imageNamed:@"remoteViewScale9.png"]];
	//[scale9View setTopLeftPoint:NSMakePoint(12,13) andBottomRightPoint:NSMakePoint(13,12)];
}

- (void) showForRemote:(NSString *) remote {
	NSView * rightView = [[gd splitContentView] rightView];
	NSRect rvf = [rightView frame];
	NSRect nf = NSMakeRect(0,0,rvf.size.width,floor(rvf.size.height-28));
	[self setFrame:nf];
	[self addSubview:scale9View];
	[rightView addSubview:self];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTRemoteView\n");
	#endif
	[self removeFromSuperview];
}

@end
