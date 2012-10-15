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

#import "GTNewBranchController.h"
#import "GittyDocument.h"

@implementation GTNewBranchController
@synthesize branchValue;

- (void) reset {
	if(newBranchName)[newBranchName setStringValue:@""];
}

- (void) initButtons {
	NSPoint tl=[self getTL];
	NSPoint tr=[self getTR];
	ok=[[GTScale9Control alloc] initWithFrame:NSMakeRect(342,20,62,27)];
	[ok sendsActionOnMouseUp:true];
	[ok setScaledImage:[NSImage imageNamed:@"blackButton2.png"]];
	[ok setScaledOverImage:[NSImage imageNamed:@"blackButton2Over.png"]];
	[ok setScaledDownImage:[NSImage imageNamed:@"blackButton2Down.png"]];
	[ok setTopLeftPoint:tl];
	[ok setBottomRightPoint:tr];
	[ok setAttributedTitle:[GTStyles getButtonString:@"OK"]];
	[ok setAttributedTitleDown:[GTStyles getDownButtonString:@"OK"]];
	[ok setAttributedTitlePosition:NSMakePoint(22,6)];
	[ok setAction:@selector(onok:)];
	[ok setTarget:self];
	[[window contentView] addSubview:ok];
	
	cancel=[[GTScale9Control alloc] initWithFrame:NSMakeRect(276,20,62,27)];
	[cancel sendsActionOnMouseUp:true];
	[cancel setScaledImage:[NSImage imageNamed:@"blackButton2.png"]];
	[cancel setScaledOverImage:[NSImage imageNamed:@"blackButton2Over.png"]];
	[cancel setScaledDownImage:[NSImage imageNamed:@"blackButton2Down.png"]];
	[cancel setTopLeftPoint:tl];
	[cancel setBottomRightPoint:tr];
	[cancel setAttributedTitle:[GTStyles getButtonString:@"Cancel"]];
	[cancel setAttributedTitleDown:[GTStyles getDownButtonString:@"Cancel"]];
	[cancel setAttributedTitlePosition:NSMakePoint(12,6)];
	[cancel setAction:@selector(cancel:)];
	[cancel setTarget:self];
	[[window contentView] addSubview:cancel];
}

- (void) onok:(id) sender {
	if([[newBranchName stringValue] length] is 0) {
		NSBeep();
		return;
	}
	branchValue=[[newBranchName stringValue] copy];
	if(target) [target performSelector:action];
	[self disposeNibs];
}

- (void) loadNibs {
	if(available)return;
	if(window==nil)[NSBundle loadNibNamed:@"NewBranch" owner:self];
	available=true;
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTNewBranchController\n");
	#endif
	[branchValue release];
	[self disposeNibs];
	[super dealloc];
}

@end
