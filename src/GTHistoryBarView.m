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

#import "GTHistoryBarView.h"
#import "GTHistoryView.h"
#import "GTHistoryCommitDetailsView.h"
#import "GittyDocument.h"

@implementation GTHistoryBarView

- (void) awakeFromNib {
	[super awakeFromNib];
	NSColor * color1 = [NSColor colorWithDeviceRed:0.75 green:0.75 blue:0.75 alpha:1];
	NSColor * color2 = [NSColor colorWithDeviceRed:0.9 green:0.9 blue:0.9 alpha:1];
	NSArray * colors = [NSArray arrayWithObjects:color1,color2,nil];
	NSGradient * grad = [[NSGradient alloc] initWithColors:colors];
	[contextSlider setTarget:self];
	[contextSlider setAction:@selector(onContextSliderUpdate)];
	[contextSlider setIntegerValue:3];
	[self removeContext];
	[self setGradient:grad];
	[self initContextLabel];
	[self initBugButton];
	[self initViews];
	[self initButtons];
	[self showCenteredLabel];
}

- (void) setGDRefs {
	[super setGDRefs];
	historyView=[gd historyView];
	detailsView=[[gd historyDetailsContainerView] detailsView];
}

- (void) initViews {
	centeredLabel=[[GTInsetLabelView alloc] initWithFrame:NSMakeRect(0,1,1,18)];
	[centeredLabel setTopLabel:[GTStyles getDarkerStringForInsetLabel:@"no selection"]];
	[centeredLabel setBottomLabel:[GTStyles getLighterStringForInsetLabel:@"no selection"]];
	[GTViewLayoutHelper alignCenter:centeredLabel];
	viewSelectorButtons=[[NSView alloc] initWithFrame:NSMakeRect(0,0,58,17)];
	[GTViewLayoutHelper alignCenter:viewSelectorButtons];
}

- (void) initButtons {
	details=[[GTScale9Control alloc] initWithFrame:NSMakeRect(0,0,29,17)];
	[details setIsPushButton:true];
	[details setAction:@selector(toggleState)];
	[details setTarget:self];
	[details setScaledImage:[NSImage imageNamed:@"historyDetailsNormal.png"]];
	[details setScaledOverImage:[NSImage imageNamed:@"historyDetailsOver.png"]];
	[details setScaledDownImage:[NSImage imageNamed:@"historyDetailsSelected.png"]];
	[details setTopLeftPoint:NSMakePoint(7,8)];
	[details setBottomRightPoint:NSMakePoint(8,7)];
	
	tree=[[GTScale9Control alloc] initWithFrame:NSMakeRect(28,0,29,17)];
	[tree setIsPushButton:true];
	[tree setAction:@selector(toggleState)];
	[tree setTarget:self];
	[tree setScaledImage:[NSImage imageNamed:@"historyDetailsTreeNormal.png"]];
	[tree setScaledOverImage:[NSImage imageNamed:@"historyDetailsTreeOver.png"]];
	[tree setScaledDownImage:[NSImage imageNamed:@"historyDetailsTreeSelected.png"]];
	[tree setTopLeftPoint:NSMakePoint(7,8)];
	[tree setBottomRightPoint:NSMakePoint(8,7)];
	
	[viewSelectorButtons addSubview:details];
	[viewSelectorButtons addSubview:tree];
	[details pushDown];
	state=true;
}

- (void) initContextLabel {
	contextLabel=[[GTInsetLabelView alloc] initWithFrame:NSMakeRect(0,6,1,1)];
	[contextLabel setTopLabel:[GTStyles getDarkerStringForInsetLabel:@"context"]];
	[contextLabel setBottomLabel:[GTStyles getLighterStringForInsetLabel:@"context"]];
}

- (void) removeContext {
	[contextSlider removeFromSuperview];
	[contextLabel removeFromSuperview];
}

- (void) onContextSliderUpdate {
	if(lastContextValue == [contextSlider integerValue]) return;
	lastContextValue = [contextSlider integerValue];
	hasContextChanged=true;
	[detailsView invalidate];
	hasContextChanged=false;
}

- (NSInteger) contextValue {
	return [contextSlider integerValue];
}

- (void) moreContext {
	NSInteger val=[contextSlider integerValue];
	if(val==10) return;
	[contextSlider setIntegerValue:val+1];
	if(lastContextValue	!= [contextSlider integerValue]) hasContextChanged=true;
	lastContextValue = [contextSlider integerValue];
	[detailsView invalidate];
	hasContextChanged=false;
}

- (void) lessContext {
	NSInteger val=[contextSlider integerValue];
	if(val==1) return;
	[contextSlider setIntegerValue:val-1];
	if(lastContextValue	!= [contextSlider integerValue]) hasContextChanged=true;
	lastContextValue = [contextSlider integerValue];
	[detailsView invalidate];
	hasContextChanged=false;
}

- (BOOL) hasContextChanged {
	return hasContextChanged;
}

- (void) showContextLabel {
	NSRect clf = [contextLabel frame];
	clf.origin.x = [contextSlider frame].origin.x + [contextSlider frame].size.width;
	[contextLabel setFrame:clf];
	[self addSubview:contextLabel];
}

- (void) initBugButton {
	NSPoint tl = NSMakePoint(4,5);
	NSPoint br = NSMakePoint(5,4);
	bugButton = [[GTScale9Control alloc] initWithFrame:NSMakeRect(0,0,22,17)];
	[bugButton setTopLeftPoint:tl];
	[bugButton setBottomRightPoint:br];
	[bugButton setIconPosition:NSMakePoint(5,2)];
	[bugButton setScaledImage:[NSImage imageNamed:@"smallSquareButtonNormal.png"]];
	[bugButton setScaledOverImage:[NSImage imageNamed:@"smallSquareButtonOver.png"]];
	[bugButton setScaledDownImage:[NSImage imageNamed:@"smallSquareButtonDown.png"]];
	[bugButton setIcon:[NSImage imageNamed:@"bugIconNormal.png"]];
	[bugButton setIconOver:[NSImage imageNamed:@"bugIconOver.png"]];
	[bugButton setIconDown:[NSImage imageNamed:@"bugIconDown.png"]];
	[bugButton setToolTip:@"Report commit rendering bugs"];
	[bugButton setTarget:self];
	[bugButton setAction:@selector(onBugButtonClick)];
	[GTViewLayoutHelper alignRight:bugButton];
}

- (void) showBugButton {
	NSRect sframe=[self frame];
	NSRect cbf=[bugButton frame];
	NSPoint bo=NSMakePoint(sframe.size.width-cbf.size.width-8,3);
	[bugButton setFrameOrigin:bo];
	[self addSubview:bugButton];
}

- (void) onBugButtonClick {
	NSInteger res=[modals runReportCommitBugNotice];
	if(res==NSCancelButton) return;
	[detailsView sendCommitBugReport];
}

- (void) showSelectorButtons {
	NSRect sf=[self frame];
	float width=sf.size.width;
	float nx=ceil((width/2)-(50/2));
	NSPoint p=NSMakePoint(nx,3);
	[viewSelectorButtons setFrameOrigin:p];
	//[self addSubview:viewSelectorButtons];
}

- (void) removeSelectorButtons {
	[viewSelectorButtons removeFromSuperview];
}

- (void) showCenteredLabel {
	NSRect sframe=[self frame];
	float width=sframe.size.width;
	//sframe.origin.y-=32;
	float nx=ceil((width/2)-([centeredLabel frame].size.width/2));
	[centeredLabel setFrameOrigin:NSMakePoint(nx,6)];
	[self addSubview:centeredLabel];
}

- (void) toggleState {
	if(state) {
		[details pushUp];
		[tree pushDown];
	} else {
		[tree pushUp];
		[details pushDown];
	}
	state=!state;
}

- (BOOL) isDetailsButtonPushed {
	return state;
}

- (BOOL) isTreeButtonPushed {
	return !state;
}

- (void) invalidate {
	GTGitCommit * commit = [historyView selectedItem];
	if(commit is nil) {
		[self removeContext];
		[self removeSelectorButtons];
		[self showCenteredLabel];
		[bugButton removeFromSuperview];
		return;
	}
	[centeredLabel removeFromSuperview];
	[self showSelectorButtons];
	[self showBugButton];
	[self showContextLabel];
	[self addSubview:contextSlider];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTHistoryBarView\n");
	#endif
	GDRelease(centeredLabel);
	GDRelease(viewSelectorButtons);
	GDRelease(details);
	GDRelease(tree);
	GDRelease(contextLabel);
	GDRelease(contextSlider);
}

@end
