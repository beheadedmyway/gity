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

#import "GTCustomTitleController.h"
#import "GittyDocument.h"
#import "GTDocumentController.h"

@implementation GTCustomTitleController
@synthesize windowTitle;

- (void) update {
	/*NSString * path = [[gd fileURL] path];
	if(!path) path = @"/Untitled";
	NSArray * pieces = [path pathComponents];
	NSInteger last = [pieces count] - 1;
	NSString * wt = [pieces objectAtIndex:last];
	NSAttributedString * wtitle = [GTStyles getCustomWindowTitleString:wt];
	windowTitle = [[wtitle string] copy];
	int padding = 200;
	NSSize titleSize = [wtitle size];
	titleSize.width += padding;
	NSRect windowFrame = [[[gtwindow contentView] superview] frame];
	[title setAttributedStringValue:wtitle];
	float newx = ((windowFrame.size.width - titleSize.width) / 2) + (padding / 2);
	[title setFrame:NSMakeRect(newx,windowFrame.size.height-titleSize.height-7,titleSize.width+2,titleSize.height+2)];
	[[[gtwindow contentView] superview] addSubview:title];*/
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTCustomTitleView\n");
	#endif
	if(title)[title removeFromSuperview];
	GDRelease(windowTitle);
	[super dealloc];
}

@end
