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

#import "GTDiffBarView.h"
#import "GittyDocument.h"

@implementation GTDiffBarView
@synthesize diffStateView;

- (void) awakeFromNib {
	NSColor * color1 = [NSColor colorWithDeviceRed:0.75 green:0.75 blue:0.75 alpha:1];
	NSColor * color2 = [NSColor colorWithDeviceRed:0.9 green:0.9 blue:0.9 alpha:1];
	NSArray * colors = [NSArray arrayWithObjects:color1,color2,nil];
	NSGradient * grad = [[[NSGradient alloc] initWithColors:colors] autorelease];
	[self setGradient:grad];
}

- (void) lazyInitWithGD:(GittyDocument *) _gd {
	[super lazyInitWithGD:_gd];
	[diffStateView lazyInitWithGD:_gd];
	//[self initViews];
}

- (void) initViews {
	//leftLabel=[[GTInsetLabelView alloc] initWithFrame:NSMakeRect(0,0,1,1)];
	//[leftLabel showInView:self withAdjustments:NSMakeRect(7,5,0,0)];
}

- (void) showDiffState {
	[diffStateView showInView:self];
	//[selectorStateView removeFromSuperview];
}

- (void) showDiffSelectState {
	[diffStateView removeFromSuperview];
	//[selectorStateView showInView:self];
}

- (void) invalidate {
	/*NSString * label;
	GTGitFile * selectedGitFile = [[gd activeBranchView] selectedGitFile];
	if([[gd activeBranchView] selectedFilesCount] < 1) label = @"";
	if([[gd activeBranchView] selectedFilesCount] > 1) label=@"";
	if([[gd activeBranchView] selectedFilesCount] == 1) label=[selectedGitFile shortFilename];
	[leftLabel setTopLabel:[GTStyles getDarkerStringForInsetLabel:label]];
	[leftLabel setBottomLabel:[GTStyles getLighterStringForInsetLabel:label]];
	//if([selectorStateView superview]) [selectorStateView invalidate];*/
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTDiffBarView\n");
	#endif
	[super dealloc];
}

@end
