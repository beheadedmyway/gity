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

#import "GTStateBarView.h"
#import "GittyDocument.h"
#import "GTDocumentController.h"

static NSPoint tlp;
static NSPoint brp;
static float sidePadding;
static float buttonSpacing;
static float buttonHeight;
static float windowSpacing;

@implementation GTStateBarView
@synthesize currentStateButton;

- (void) awakeFromNib {
	[super awakeFromNib];
	[searchField setRecentsAutosaveName:@"GTRecentSearches"];
	[[searchField cell] setPlaceholderString:@"Filter"];
	[[searchField cell] setAction:@selector(searchOccured:)];
	[[searchField cell] setTarget:self];
	if(!sidePadding) sidePadding = 8;
	if(!buttonHeight) buttonHeight = 21;
	if(!buttonSpacing) buttonSpacing = 6;
	if(!windowSpacing) windowSpacing = 8;
	if(!tlp.x) tlp = NSMakePoint(6,8);
	if(!brp.x) brp = NSMakePoint(8,6);
}

- (void) lazyInitWithGD:(GittyDocument *) _gd {
	[super lazyInitWithGD:_gd];
	splitContentView=[gd splitContentView];
	configView=[gd configView];
	[self initConfigAddButton];
	[self initConfigRemoveButton];
	[self initRefDropDownView];
}

- (void) show {
	NSRect sf = [self frame];
	NSView * rightView = [splitContentView rightView];
	NSRect rvf = [rightView frame];
	NSRect nf = NSMakeRect(0,rvf.size.height-28,rvf.size.width,sf.size.height);
	[self setFrame:nf];
	[rightView addSubview:self];
}

- (void) showWithHiddenSourceList {
	NSView * cv = [[gd gtwindow] contentView];
	NSRect rvf = [cv frame];
	NSRect nf = NSMakeRect(0,rvf.size.height-28,rvf.size.width,28);
	[self setFrame:nf];
	[cv addSubview:self];
}

- (void) initRefDropDownView {
	//refDropDownView = [[GDTitleBarRefView alloc] initWithFrame:NSMakeRect(100,3,31,20)];
	//NSLog(@"initRefDropDownView %@",refDropDownView);
	//[refDropDownView lazyInitWithGD:gd];
	/*NSPoint tl = NSMakePoint(11,12);
	NSPoint br = NSMakePoint(12,11);
	dropDown = [[GTScale9Control alloc] initWithFrame:NSMakeRect(6,4,100,21)];
	[dropDown setTopLeftPoint:tl];
	[dropDown setBottomRightPoint:br];
	[dropDown setScaledImage:[NSImage imageNamed:@"stateDropDownNormal.png"]];
	[dropDown setScaledOverImage:[NSImage imageNamed:@"stateDropDownOver.png"]];
	NSLog(@"initButton %@ %@", dropDown, [NSImage imageNamed:@"stateDropDownNormal.png"]);
	[self updateRefDropDownIconPosition];
	[self addSubview:dropDown];*/
}

- (void) updateRefDropDownIconPosition {
	//if(!hasSetIcon) {
	/*[dropDown setIcon:[NSImage imageNamed:@"stateDropDownArrowNormal.png"]];
	[dropDown setIconOver:[NSImage imageNamed:@"stateDropDownArrowOver.png"]];
	//}
	NSSize ds = [dropDown frame].size;
	[dropDown setIconPosition:NSMakePoint(ds.width-14,7)];*/
}

- (float) getRequiredWidth {
	NSSize labelSize = [barLabel frame].size;
	NSSize searchSize = [searchField frame].size;
	return labelSize.width + searchSize.width + (windowSpacing*2);
}

- (void) focusOnSearch {
	[searchField becomeFirstResponder];
}

- (void) clearSearchField {
	[searchField setStringValue:@""];
	[searchField resignFirstResponder];
}

- (void) searchOccured:(id) sender {
	if([[searchField stringValue] length] < 1) {
		[gd clearSearch];
		return;
	}
	[gd search:[searchField stringValue]];
}

- (void) removeEverything {
	lastLeftButton = nil;
	lastRightButton = nil;
	[searchField removeFromSuperview];
	[configAdd removeFromSuperview];
	[configRemove removeFromSuperview];
	[refDropDownView removeFromSuperview];
}

- (void) addRefDropDown {
	//[self addSubview:refDropDownView];
}

- (void) showHiddenSourceListState {
	//[barLabel removeFromSuperview];
	//[self addRefDropDown];
}

- (void) showActiveBranchState {
	[self removeEverything];
	[self invalidateSearchControl];
	if([gitd activeBranchName] != nil) {
		if (gitd.isHeadDetatched)
			[barLabel setStringValue:[@"" stringByAppendingFormat:@"%@, Commit %@", [gitd activeBranchName], [gitd currentAbbreviatedSha]]];
		else
			[barLabel setStringValue:[@"" stringByAppendingString:[gitd activeBranchName]]];
		[barLabel sizeToFit];
	}
}

- (void) showDetatchedHeadState {
	[self removeEverything];
	[self invalidateSearchControl];
	if([gitd currentAbbreviatedSha]) {
		[barLabel setStringValue:[@"Detached Head - On Commit: " stringByAppendingString:[gitd currentAbbreviatedSha]]];
	} else {
		[barLabel setStringValue:@"Detached Head (No Branch)"];
	}
	[barLabel sizeToFit];
}

- (void) showHistoryState {
	[self removeEverything];
	[self invalidateSearchControl];
	NSString * abn = [gitd activeBranchName];
	NSString * final = nil;
	if (gitd.isHeadDetatched)
		final = [@"History " stringByAppendingFormat:@"%@, Commit %@", abn, [gitd currentAbbreviatedSha]];
	else
		final = [@"History " stringByAppendingFormat:@"(%@)",abn];
	[barLabel setStringValue:final];
	[barLabel sizeToFit];
}

- (void) showHistoryStateWithRefName:(NSString *) _refName {
	[self removeEverything];
	[self invalidateSearchControl];
	NSString * final = nil;
	if (gitd.isHeadDetatched && [_refName isEqualToString:[gitd activeBranchName]])
		final = [@"History " stringByAppendingFormat:@"%@, Commit %@", _refName, [gitd currentAbbreviatedSha]];
	else
		final = [@"History " stringByAppendingFormat:@"(%@)",_refName];
	[barLabel setStringValue:final];
	[barLabel sizeToFit];
}

- (void) showConfigState {
	[self removeEverything];
	[barLabel setStringValue:@"Git Config"];
	[barLabel sizeToFit];
	[self invalidateConfigRemoveButton];
	[self invalidateConfigAddButton];
}

- (void) showRemoteStateForRemote:(NSString *) remote {
	[self removeEverything];
	[barLabel setStringValue:[@"Remote: " stringByAppendingString:remote]];
	[barLabel sizeToFit];
}

- (void) showGlobalConfigState {
	[self removeEverything];
	[barLabel setStringValue:@"Global Git Config"];
	[barLabel sizeToFit];
	[self invalidateConfigRemoveButton];
	[self invalidateConfigAddButton];
}

- (void) invalidateSearchControl {
	NSRect rvf=[self frame];
	NSRect sr=[searchField frame];
	float nx=ceil(rvf.size.width-186);
	NSRect y = NSMakeRect(nx,5,178,sr.size.height);
	[searchField setFrame:y];
	[self addSubview:searchField];
}

- (NSRect) getButtonRectSizedForLabel:(NSAttributedString *) label {
	return NSMakeRect(0,0,ceil([label size].width+sidePadding*2),ceil(buttonHeight));
}

- (NSPoint) getAttributedStringPositionForLabel:(NSAttributedString *) label {
	return NSMakePoint(sidePadding,3);
}

- (NSRect) updateButtonRectPositionFromRight:(id) button {
	double x;
	double y = 5;
	NSRect rect;
	if(lastRightButton is nil) {
		x = floor([self frame].size.width - [button frame].size.width - windowSpacing);
		rect = NSMakeRect(x,y,[button frame].size.width,[button frame].size.height);
	} else {
		x = floor([lastRightButton frame].origin.x - [button frame].size.width - buttonSpacing);
		rect = NSMakeRect(x,y,[button frame].size.width,[button frame].size.height);
	}
	lastRightButton=button;
	return rect;
}

- (NSRect) updateButtonRectPositionFromLeft:(GTScale9Control *) button {
	double x;
	double y = 4;
	NSRect rect;
	if(lastLeftButton is nil) {
		x = windowSpacing;
		rect = NSMakeRect(x,y,[button frame].size.width,[button frame].size.height);
	} else {
		x = floor([lastLeftButton frame].origin.x + [lastLeftButton frame].size.width + buttonSpacing);
		rect = NSMakeRect(x,y,[button frame].size.width,[button frame].size.height);
	}
	lastLeftButton = button;
	return rect;
}

- (void) updateLeftButtonSizeAndPosition:(GTScale9Control *) button label:(NSAttributedString *) label {
	[button setFrame:[self getButtonRectSizedForLabel:label]];
	[button setFrame:[self updateButtonRectPositionFromLeft:button]];
}

- (void) updateRightButtonSizeAndPosition:(GTScale9Control *) button label:(NSAttributedString *) label {
	[button setFrame:[self getButtonRectSizedForLabel:label]];
	[button setFrame:[self updateButtonRectPositionFromRight:button]];
}

- (void) initConfigAddButton {
	configAdd = [[GTScale9Control alloc] initWithFrame:NSMakeRect(0,0,26,21)];
	[configAdd setScaledImage:[NSImage imageNamed:@"blackButtonNoShadow.png"]];
	[configAdd setScaledOverImage:[NSImage imageNamed:@"blackButtonNoShadowOver2.png"]];
	[configAdd setScaledDownImage:[NSImage imageNamed:@"blackButtonNoShadowDown.png"]];
	[configAdd setTopLeftPoint:tlp];
	[configAdd setBottomRightPoint:brp];
	[configAdd setIconPosition:NSMakePoint(8,5)];
	[configAdd setIcon:[NSImage imageNamed:@"configAddNormal.png"]];
	[configAdd setIconOver:[NSImage imageNamed:@"configAddOver.png"]];
	[configAdd setIconDown:[NSImage imageNamed:@"configAddDown.png"]];
	[configAdd setAutoresizingMask:(NSViewMinXMargin)];
	[configAdd setAction:@selector(onConfigAdd)];
	[configAdd setTarget:self];
}

- (void) initConfigRemoveButton {
	configRemove = [[GTScale9Control alloc] initWithFrame:NSMakeRect(100,0,26,21)];
	[configRemove setScaledImage:[NSImage imageNamed:@"blackButtonNoShadow.png"]];
	[configRemove setScaledOverImage:[NSImage imageNamed:@"blackButtonNoShadowOver2.png"]];
	[configRemove setScaledDownImage:[NSImage imageNamed:@"blackButtonNoShadowDown.png"]];
	[configRemove setTopLeftPoint:tlp];
	[configRemove setBottomRightPoint:brp];
	[configRemove setIconPosition:NSMakePoint(8,7)];
	[configRemove setIcon:[NSImage imageNamed:@"configRemoveNormal.png"]];
	[configRemove setIconOver:[NSImage imageNamed:@"configRemoveOver.png"]];
	[configRemove setIconDown:[NSImage imageNamed:@"configRemoveDown.png"]];
	[configRemove setAutoresizingMask:(NSViewMinXMargin)];
	[configRemove setAction:@selector(onConfigRemove)];
	[configRemove setTarget:self];
}

- (void) onConfigRemove {
	[configView removeItem];
}

- (void) onConfigAdd {
	[configView addItem];
}

- (void) invalidateConfigRemoveButton {
	[configRemove setFrame:[self updateButtonRectPositionFromRight:configRemove]];
	[self addSubview:configRemove];
}

- (void) invalidateConfigAddButton {
	[configAdd setFrame:[self updateButtonRectPositionFromRight:configAdd]];
	[self addSubview:configAdd];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTStateBarView\n");
	#endif
	[configRemove removeFromSuperview];
	[configAdd removeFromSuperview];
	GDRelease(configRemove);
	GDRelease(configAdd);
	GDRelease(searchField);
	//GDRelease(refDropDownView);
	GDRelease(barLabel);
	lastLeftButton = nil;
	lastRightButton = nil;
}

@end
