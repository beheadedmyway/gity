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

#import "GTDiffBarDiffStateView.h"
#import "GittyDocument.h"

@implementation GTDiffBarDiffStateView

- (void) awakeFromNib {
	[super awakeFromNib];
	[contextSlider retain];
	[contextSlider setTarget:self];
	[contextSlider setAction:@selector(onContextSliderUpdate)];
	[contextSlider setIntegerValue:3];
}

- (void) lazyInitWithGD:(GittyDocument *) _gd {
	[super lazyInitWithGD:_gd];
	diffView=[gd diffView];
	[self initViews];
}

- (void) showInView:(NSView *) _view {
	[super showInView:_view];
	[self showCenteredLabel];
	[self showContextLabel];
}

- (void) onContextSliderUpdate {
	if(lastContextValue == [contextSlider integerValue]) return;
	lastContextValue = [contextSlider integerValue];
	[diffView rediffFromContextUpdate];
}

- (void) initViews {
	//selectorContainer=[[NSView alloc] initWithFrame:NSMakeRect(0,0,1,22)];
	contextLabel=[[GTInsetLabelView alloc] initWithFrame:NSMakeRect(0,6,1,1)];
	[contextLabel setTopLabel:[GTStyles getDarkerStringForInsetLabel:@"context"]];
	[contextLabel setBottomLabel:[GTStyles getLighterStringForInsetLabel:@"context"]];
	centeredLabel=[[GTInsetLabelView alloc] initWithFrame:NSMakeRect(0,1,1,18)];
	[centeredLabel setTopLabel:[GTStyles getDarkerStringForInsetLabel:@"no changes"]];
	[centeredLabel setBottomLabel:[GTStyles getLighterStringForInsetLabel:@"no changes"]];
	[GTViewLayoutHelper alignCenter:centeredLabel];
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
	[bugButton setToolTip:@"Report diff rendering bugs"];
	[bugButton setTarget:self];
	[bugButton setAction:@selector(onBugButtonClick)];
	[GTViewLayoutHelper alignRight:bugButton];
}

- (void) onBugButtonClick {
	NSInteger res=[modals runReportDiffBugNotice];
	if(res==NSCancelButton) return;
	[diffView reportDiff];
}

- (NSInteger) contextValue {
	return [contextSlider integerValue];
}

- (void) moreContext {
	NSInteger val=[contextSlider integerValue];
	if(val==10) return;
	[contextSlider setIntegerValue:val+1];
	lastContextValue = [contextSlider integerValue];
	[diffView rediffFromContextUpdate];
}

- (void) lessContext {
	NSInteger val=[contextSlider integerValue];
	if(val==1) return;
	[contextSlider setIntegerValue:val-1];
	lastContextValue = [contextSlider integerValue];
	[diffView rediffFromContextUpdate];
}

- (void) showCenteredLabelWithLabel:(NSString *) _label {
	[centeredLabel setTopLabel:[GTStyles getDarkerStringForInsetLabel:_label]];
	[centeredLabel setBottomLabel:[GTStyles getLighterStringForInsetLabel:_label]];
	[self showCenteredLabel];
}

- (void) showCenteredLabel {
	NSRect sframe=[self frame];
	//sframe.origin.y-=32;
	float nx = ceil((sframe.size.width/2) - ([centeredLabel frame].size.width/2));
	[centeredLabel setFrameOrigin:NSMakePoint(nx,6)];
	[self addSubview:centeredLabel];
}

- (void) hideCenteredLabel {
	[centeredLabel removeFromSuperview];
}

- (void) showContextSlider {
	[self addSubview:contextSlider];
}

- (void) showContextLabel {
	NSRect clf = [contextLabel frame];
	clf.origin.x = [contextSlider frame].origin.x + [contextSlider frame].size.width;
	[contextLabel setFrame:clf];
	[self addSubview:contextLabel];
}

- (void) showBugButton {
	NSRect sframe=[self frame];
	NSRect cbf = [bugButton frame];
	NSPoint bo = NSMakePoint(sframe.size.width-cbf.size.width-8,3);
	[bugButton setFrameOrigin:bo];
	[self addSubview:bugButton];
}

- (void) removeAll {
	//if([selectorContainer superview]) [selectorContainer removeFromSuperview];
	if([contextSlider superview]) [contextSlider removeFromSuperview];
	if([contextLabel superview]) [contextLabel removeFromSuperview];
	if([bugButton superview]) [bugButton removeFromSuperview];
}

- (void) removeAllAndShowContext {
	//if([selectorContainer superview]) [selectorContainer removeFromSuperview];
	[self showContextSlider];
	[self showContextLabel];
}

- (void) showNoChanges {
	[self removeAll];
	[self showCenteredLabelWithLabel:@"no changes"];
}

- (void) showHeadVSStage {
	[self showCenteredLabelWithLabel:@"head vs stage"];
	[self removeAllAndShowContext];
	[self showBugButton];
}

- (void) showHeadVSWorkingTree {
	[self showCenteredLabelWithLabel:@"head vs working tree"];
	[self removeAllAndShowContext];
	[self showBugButton];
}

- (void) showStageVSWorkingTree {
	[self showCenteredLabelWithLabel:@"stage vs working tree"];
	[self removeAllAndShowContext];
	[self showBugButton];
}

- (void) showNothingToDiff {
	[self removeAll];
	[self showCenteredLabelWithLabel:@"nothing to diff"];
	[self showBugButton];
}

- (void) showWorkingTreeChanges {
	[self removeAll];
	[self showContextSlider];
	[self showContextLabel];
	[self showCenteredLabelWithLabel:@"working tree changes"];
	[self showBugButton];
}

- (void) showStagedChanges {
	[self removeAll];
	[self showContextSlider];
	[self showContextLabel];
	[self showCenteredLabelWithLabel:@"staged changes"];
	[self showBugButton];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTDiffBarDiffStateView\n");
	#endif
	GDRelease(contextSlider);
	GDRelease(contextLabel);
	GDRelease(contextLabel);
	GDRelease(bugButton);
	GDRelease(vsimg);
	[super dealloc];
}

@end


/*
 vsimg=[[NSImage imageNamed:@"diffVS.png"] retain];
 vs=[[GTImageView alloc] initWithFrame:NSMakeRect(0,0,1,1)];
 [vs setImg:vsimg];
 leftSelector = [[GTScale9Control alloc] initWithFrame:NSMakeRect(0,0,104,15)];
 [leftSelector setScaledImage:[NSImage imageNamed:@"diffSelectorNormal.png"]];
 [leftSelector setScaledOverImage:[NSImage imageNamed:@"diffSelectorOver.png"]];
 [leftSelector setScaledDownImage:[NSImage imageNamed:@"diffSelectorDown.png"]];
 [leftSelector setIcon:[NSImage imageNamed:@"diffSelectorArrowNormal.png"]];
 [leftSelector setIconOver:[NSImage imageNamed:@"diffSelectorArrowOver.png"]];
 [leftSelector setIconDown:[NSImage imageNamed:@"diffSelectorArrowDown.png"]];
 [leftSelector setIconPosition:NSMakePoint(88,4)];
 [leftSelector setTopLeftPoint:[self getTL]];
 [leftSelector setBottomRightPoint:[self getTR]];
 [leftSelector setTarget:self];
 [leftSelector setAction:@selector(leftPopup)];
 rightSelector = [[GTScale9Control alloc] initWithFrame:NSMakeRect(0,0,104,15)];
 [rightSelector setScaledImage:[NSImage imageNamed:@"diffSelectorNormal.png"]];
 [rightSelector setScaledOverImage:[NSImage imageNamed:@"diffSelectorOver.png"]];
 [rightSelector setScaledDownImage:[NSImage imageNamed:@"diffSelectorDown.png"]];
 [rightSelector setIcon:[NSImage imageNamed:@"diffSelectorArrowNormal.png"]];
 [rightSelector setIconOver:[NSImage imageNamed:@"diffSelectorArrowOver.png"]];
 [rightSelector setIconDown:[NSImage imageNamed:@"diffSelectorArrowDown.png"]];
 [rightSelector setIconPosition:NSMakePoint(88,4)];
 [rightSelector setTopLeftPoint:[self getTL]];
 [rightSelector setBottomRightPoint:[self getTR]];
 [rightSelector setTarget:self];
 [rightSelector setAction:@selector(rightPopup)];

- (void) showSelector {
 [self hideCenterLabel];
 NSRect sframe = [self frame];
 sframe.origin.y -= 32;
 
 NSRect lsf = NSMakeRect(0,4,104,15);
 [leftSelector setFrame:lsf];
 [selectorContainer addSubview:leftSelector];
 
 NSSize imgsize = [vsimg size];
 float imgx = ceil(lsf.origin.x + lsf.size.width + 4);
 NSRect imgfr = NSMakeRect(imgx,8,imgsize.width,imgsize.height);
 [vs setFrame:imgfr];
 [selectorContainer addSubview:vs];
 
 NSRect rsf = NSMakeRect(ceil(imgfr.origin.x + imgfr.size.width + 4),4,104,15);
 [rightSelector setFrame:rsf];
 [selectorContainer addSubview:rightSelector];
 
 float totalWidth = lsf.size.width + imgsize.width + rsf.size.width + 8;
 float cx = ceil((sframe.size.width - totalWidth) / 2) - 30;
 NSRect crect = [selectorContainer frame];
 [selectorContainer setFrame:NSMakeRect(cx,0,totalWidth,crect.size.height)];
 [GTViewLayoutHelper alignCenter:selectorContainer];
 
 [self showContextLabel];
 [self showContextSlider];
 [self addSubview:selectorContainer];
}
 
- (void) leftPopup {
NSPoint eventPoint = [selectorContainer convertPoint:[leftSelector frame].origin toView:self];
eventPoint.x-=2;
eventPoint.y-=2;
NSPoint globalPoint = [self convertPointToBase:eventPoint];
NSEvent * event = [NSEvent mouseEventWithType:NSLeftMouseDown location:globalPoint modifierFlags:0 timestamp:0 windowNumber:[[gd gtwindow] windowNumber] context:nil eventNumber:0 clickCount:1 pressure:0];
[NSMenu popUpContextMenu:[[gd contextMenus] leftDiffSelectorMenu] withEvent:event forView:leftSelector];
}

- (void) rightPopup {
NSPoint eventPoint = [selectorContainer convertPoint:[rightSelector frame].origin toView:self];
eventPoint.x-=2;
eventPoint.y-=2;
NSPoint globalPoint = [self convertPointToBase:eventPoint];
NSEvent * event = [NSEvent mouseEventWithType:NSLeftMouseDown location:globalPoint modifierFlags:0 timestamp:0 windowNumber:[[gd gtwindow] windowNumber] context:nil eventNumber:0 clickCount:1 pressure:0];
[NSMenu popUpContextMenu:[[gd contextMenus] rightDiffSelectorMenu] withEvent:event forView:rightSelector];
}

- (void) menuDidClose:(NSMenu *) menu {
if(menu == [[gd contextMenus] leftDiffSelectorMenu]) [leftSelector resetSources];
else if(menu == [[gd contextMenus] rightDiffSelectorMenu]) [rightSelector resetSources];
}

- (BOOL) shouldRunDiff {
return false;
}

- (void) updateSelector:(GTScale9Control *) _selector withLabel:(NSString *) _label {
NSAttributedString * normal = [GTStyles getSelectorNormalLabel:_label];
NSAttributedString * over = [GTStyles getSelectorOverLabel:_label];
NSAttributedString * down = [GTStyles getSelectorDownLabel:_label];
[_selector setAttributedTitle:normal];
[_selector setAttributedTitleOver:over];
[_selector setAttributedTitleDown:down];
float swidth = [_selector frame].size.width;
float lwidth = [normal size].width;
float nx = ceil((swidth - lwidth)/2);
NSPoint pos = NSMakePoint(nx,2);
[_selector setAttributedTitlePosition:pos];
}

- (NSString *) leftSelectorValue {
return [[leftSelector attributedTitle] string];
}

- (NSString *) rightSelectorValue {
return [[rightSelector attributedTitle] string];
}

- (void) rightDiffSelectorHEADSelected:(id) sender {
NSMenuItem * item = (NSMenuItem *) sender;
[self updateSelector:rightSelector withLabel:[[item title] lowercaseString]];
[[gd contextMenus] invalidateLeftDiffSelector];
}

- (void) rightDiffSelectorPWDSelected:(id) sender {
NSMenuItem * item = (NSMenuItem *) sender;
[self updateSelector:rightSelector withLabel:[[item title] lowercaseString]];
[[gd contextMenus] invalidateLeftDiffSelector];
}

- (void) rightDiffSelectorStageSelected:(id) sender {
NSMenuItem * item = (NSMenuItem *) sender;
[self updateSelector:rightSelector withLabel:[[item title] lowercaseString]];
[[gd contextMenus] invalidateLeftDiffSelector];
}

- (void) rightDiffSelectorCommitSelected:(id) sender {
[[gd diffView] showDiffCommitSelectorState];
[[gd contextMenus] invalidateLeftDiffSelector];
}

- (void) leftDiffSelectorHEADSelected:(id) sender {
NSMenuItem * item = (NSMenuItem *) sender;
[self updateSelector:leftSelector withLabel:[[item title] lowercaseString]];
[[gd contextMenus] invalidateRightDiffSelectorMenu];
}

- (void) leftDiffSelectorPWDSelected:(id) sender {
NSMenuItem * item = (NSMenuItem *) sender;
[self updateSelector:leftSelector withLabel:[[item title] lowercaseString]];
[[gd contextMenus] invalidateRightDiffSelectorMenu];
}

- (void) leftDiffSelectorStageSelected:(id) sender {
NSMenuItem * item = (NSMenuItem *) sender;
[self updateSelector:leftSelector withLabel:[[item title] lowercaseString]];
[[gd contextMenus] invalidateRightDiffSelectorMenu];
}

- (void) leftDiffSelectorCommitSelected:(id) sender {
[[gd diffView] showDiffCommitSelectorState];
[[gd contextMenus] invalidateRightDiffSelectorMenu];
}

- (BOOL) isLeftSelectorOnWorking {
return ([[[leftSelector attributedTitle] string] isEqual:@"working"]);
}

- (BOOL) isLeftSelectorOnStage {
return ([[[leftSelector attributedTitle] string] isEqual:@"stage"]);
}

- (BOOL) isLeftSelectorOnHead {
return ([[[leftSelector attributedTitle] string] isEqual:@"head"]);
}

- (BOOL) isLeftSelectorOnCommit {
return !([self isLeftSelectorOnWorking] || [self isLeftSelectorOnHead] || [self isLeftSelectorOnStage]);
}

- (BOOL) isRightSelectorOnWorking {

return ([[[rightSelector attributedTitle] string] isEqual:@"working"]);
}

- (BOOL) isRightSelectorOnStage {
return ([[rightSelector attributedTitle] string] == @"stage");
}

- (BOOL) isRightSelectorOnHead {
return ([[rightSelector attributedTitle] string] == @"head");
}

- (BOOL) isRightSelectorOnCommit {
return !([self isRightSelectorOnWorking] || [self isRightSelectorOnHead] || [self isRightSelectorOnStage]);
}
*/