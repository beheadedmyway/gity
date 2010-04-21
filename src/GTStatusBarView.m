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

#import "GTStatusBarView.h"
#import "GittyDocument.h"
#import "GTDocumentController.h"

static float sidePadding;
static float buttonSpacing;
static float buttonHeight;
static float windowSpacing;

@implementation GTStatusBarView

- (void) awakeFromNib {
	if(!sidePadding)sidePadding=8;
	if(!buttonSpacing)buttonSpacing=6;
	if(!windowSpacing)windowSpacing=8;
	if(!buttonHeight)buttonHeight=17;
	deletedFilesCount=0;
	untrackedFilesCount=0;
	modifiedFilesCount=0;
	stagedFiles=0;
	unmergedFilesCount=0;
}

- (void) lazyInitWithGD:(GittyDocument *) _gd {
	[super lazyInitWithGD:_gd];
	splitContentView=[gd splitContentView];
	stateBarView=[gd stateBarView];
	[self updateButtonLabels];
	[self initDeletedFilesButton];
	[self initUntrackedFilesButton];
	[self initStagedFilesButton];
	[self initModifiedFilesButton];
	[self initConflictedFilesButton];
	[self invalidateAllButtons];
}

- (void) hide {
	[self removeFromSuperview];
}

- (void) update {
	if(deletedFilesCount == [gitd deletedFilesCount] &&
	   modifiedFilesCount == [gitd modifiedFilesCount] &&
	   untrackedFilesCount == [gitd untrackedFilesCount] &&
	   stagedFilesCount == [gitd stagedFilesCount] && 
	   unmergedFilesCount == [gitd unmergedFilesCount])return;
	[self invalidateCounts];
	[deletedFiles removeFromSuperview];
	[untrackedFiles removeFromSuperview];
	[modifiedFiles removeFromSuperview];
	[stagedFiles removeFromSuperview];
	[conflictedFiles removeFromSuperview];
	[self invalidateLabels];
	[self invalidateAllButtons];
	[self invalidateSelfFrame];
	[self invalidateAllButtons];
}

- (void) updateAfterViewChange {
	[self invalidateCounts];
	[deletedFiles removeFromSuperview];
	[untrackedFiles removeFromSuperview];
	[modifiedFiles removeFromSuperview];
	[stagedFiles removeFromSuperview];
	[conflictedFiles removeFromSuperview];
	[self invalidateLabels];
	[self invalidateAllButtons];
	[self invalidateSelfFrame];
	[self invalidateAllButtons];
}

- (void) invalidateCounts {
	deletedFilesCount = [gitd deletedFilesCount];
	modifiedFilesCount = [gitd modifiedFilesCount];
	untrackedFilesCount = [gitd untrackedFilesCount];
	stagedFilesCount = [gitd stagedFilesCount];
	unmergedFilesCount = [gitd unmergedFilesCount];
	if([deletedFiles isDown] && deletedFilesCount < 1) [deletedFiles performClick:nil];
	if([untrackedFiles isDown] && untrackedFilesCount < 1) [untrackedFiles performClick:nil];
	if([modifiedFiles isDown] && modifiedFilesCount < 1) [modifiedFiles performClick:nil];
	if([stagedFiles isDown] && stagedFilesCount < 1) [stagedFiles performClick:nil];
	if([conflictedFiles isDown] && unmergedFilesCount < 1) [conflictedFiles performClick:nil];
}

- (void) invalidateLabels {
	if(deletedFilesCount > 0 && deletedFilesLabel) [deletedFilesLabel release]; //deletedFiles
	if(deletedFilesCount == 1) deletedFilesLabel = [[GTStyles getRoundStatusButtonText:@"(1) Deleted File"] retain];
	if(deletedFilesCount > 1) deletedFilesLabel = [[GTStyles getRoundStatusButtonText:[NSString stringWithFormat:@"(%i) Deleted Files",(int)deletedFilesCount]] retain];
	if(untrackedFilesCount > 0 && untrackedFiles) [untrackedFilesLabel release]; //untrackedFiles
	if(untrackedFilesCount == 1) untrackedFilesLabel = [[GTStyles getRoundStatusButtonText:@"(1) Untracked File"] retain];
	if(untrackedFilesCount > 1) untrackedFilesLabel = [[GTStyles getRoundStatusButtonText:[NSString stringWithFormat:@"(%i) Untracked Files",(int)untrackedFilesCount]] retain];
	if(modifiedFilesCount > 0 && modifiedFilesLabel) [modifiedFilesLabel release]; //modified files
	if(modifiedFilesCount == 1) modifiedFilesLabel = [[GTStyles getRoundStatusButtonText:@"(1) Modified File"] retain];
	if(modifiedFilesCount > 1) modifiedFilesLabel = [[GTStyles getRoundStatusButtonText:[NSString stringWithFormat:@"(%i) Modified Files",(int)modifiedFilesCount]] retain];
	if(stagedFilesCount > 0 && stagedFilesLabel) [stagedFilesLabel release]; //staged files
	if(stagedFilesCount == 1) stagedFilesLabel = [[GTStyles getRoundStatusButtonText:@"(1) Staged File"] retain];
	if(stagedFilesCount > 1) stagedFilesLabel = [[GTStyles getRoundStatusButtonText:[NSString stringWithFormat:@"(%i) Staged Files",(int)stagedFilesCount]] retain];
	if(unmergedFilesCount > 0 && conflictedFilesLabel) [conflictedFilesLabel release]; //staged files
	if(unmergedFilesCount == 1) conflictedFilesLabel = [[GTStyles getRoundStatusButtonText:@"(1) Conflicted File"] retain];
	if(unmergedFilesCount > 1) conflictedFilesLabel = [[GTStyles getRoundStatusButtonText:[NSString stringWithFormat:@"(%i) Conflicted Files",(int)unmergedFilesCount]] retain];
}

- (void) invalidateAllButtons {
	lastButton=nil;
	@synchronized(self) {
		[self invalidateUntrackedFilesButton];
		[self invalidateDeleteFilesButton];
		[self invalidateModifiedFilesButton];
		[self invalidateStagedFilesButton];
		[self invalidateConflictedFilesButton];
	}
}

- (void) invalidateSelfFrame {
	NSRect frame = [self frame];
	//NSLog(@"invalidateSelfFrame");
	//NSLog(@"%@",[self superview]);
	NSRect rvf;
	if([self superview]) rvf = [[self superview] frame];
	else rvf = [[splitContentView rightView] frame];
	//NSView * rightView = [splitContentView rightView];
	//NSRect rvf = [rightView frame];
	float newWidth = 0;
	if(deletedFilesCount > 0) newWidth += [deletedFiles frame].size.width + buttonSpacing;
	if(untrackedFilesCount > 0) newWidth += [untrackedFiles frame].size.width + buttonSpacing;
	if(modifiedFilesCount > 0) newWidth += [modifiedFiles frame].size.width + buttonSpacing;
	if(stagedFilesCount > 0) newWidth += [stagedFiles frame].size.width + buttonSpacing;
	if(unmergedFilesCount > 0) newWidth += [conflictedFiles frame].size.width + buttonSpacing;
	newWidth -= buttonSpacing;
	frame.size.width = newWidth;
	float newX = floor( (rvf.size.width/2) - (newWidth/2) ); // - 32;
	frame.origin.x = newX;
	[self removeFromSuperview];
	[self setFrame:NSMakeRect(newX,3,frame.size.width,28)];
	[stateBarView addSubview:self];
}

-  (float) getTotalButtonWidth {
	float newWidth = 0;
	if(deletedFilesCount > 0) newWidth += [deletedFiles frame].size.width + buttonSpacing;
	if(untrackedFilesCount > 0) newWidth += [untrackedFiles frame].size.width + buttonSpacing;
	if(modifiedFilesCount > 0) newWidth += [modifiedFiles frame].size.width + buttonSpacing;
	if(stagedFilesCount > 0) newWidth += [stagedFiles frame].size.width + buttonSpacing;
	newWidth -= buttonSpacing;
	return newWidth;
}

- (BOOL) isDirty {
	if(untrackedFilesCount > 0) return true;
	if(modifiedFilesCount > 0) return true;
	if(deletedFilesCount > 0) return true;
	if(unmergedFilesCount > 0) return true;
	return false;
}

- (BOOL) isDirtyWithStage {
	if([self isDirty]) return true;
	if(stagedFilesCount > 0) return true;
	return false;
}

- (BOOL) shouldShowConflictedFiles {
	return (unmergedFilesCount > 0 && conflictedFilesStatus);
}

- (BOOL) shouldShowUntrackedFiles {
	return (untrackedFilesCount > 0 && untrackedFilesStatus);
}

- (BOOL) shouldShowModifiedFiles {
	return (modifiedFilesCount > 0 && modifiedFilesStatus);
}

- (BOOL) shouldShowDeletedFiles {
	return (deletedFilesCount > 0 && deletedFilesStatus);
}

- (BOOL) shouldShowStagedFiles {
	return (stagedFilesCount > 0 && stagedFilesStatus);
}

- (BOOL) isStagedFilesButtonToggled {
	return stagedFilesStatus;
}

- (BOOL) isOnlyUntrackedFilesButtonToggled {
	if(untrackedFilesStatus && (!stagedFilesStatus && !modifiedFilesStatus && !deletedFilesStatus && !conflictedFilesStatus)) return true;
	return false;
}

- (BOOL) hasOnlyUntrackedFilesExceptStage {
	if(unmergedFilesCount > 0 || modifiedFilesCount > 0 || deletedFilesCount > 0) return false;
	if(untrackedFilesCount > 0) return true;
	return false;
}

- (BOOL) areAnyButtonsToggledExceptStage {
	if(modifiedFilesStatus) return true;
	if(untrackedFilesStatus) return true;
	if(deletedFilesStatus) return true;
	return false;
}

- (BOOL) shouldShowAnyFilesExceptStaged {
	if(unmergedFilesCount > 0) return true;
	if(untrackedFilesCount > 0) return true;
	if(deletedFilesCount > 0) return true;
	return false;
}

- (void) toggleAllFiles {
	if(stagedFilesStatus) [stagedFiles performClick:nil];
	if(modifiedFilesStatus) [modifiedFiles performClick:nil];
	if(deletedFilesStatus) [deletedFiles performClick:nil];
	if(untrackedFilesStatus) [untrackedFiles performClick:nil];
	if(conflictedFilesStatus) [conflictedFiles performClick:nil];
}

- (void) toggleStagedFiles {
	[stagedFiles performClick:stagedFiles];
}

- (void) toggleUntrackedFiles {
	[untrackedFiles performClick:nil];
}

- (void) toggleModifiedFiles {
	[modifiedFiles performClick:nil];
}

- (void) toggleDeletedFiles {
	[deletedFiles performClick:nil];
}

- (void) toggleConflictedFiles {
	[conflictedFiles performClick:nil];
}

- (void) updateButtonLabels {
	deletedFilesLabel = [[GTStyles getRoundStatusButtonText:@"Deleted Files"] retain];
	untrackedFilesLabel = [[GTStyles getRoundStatusButtonText:@"Untracked Files"] retain];
	stagedFilesLabel = [[GTStyles getRoundStatusButtonText:@"Staged Files"] retain];
	modifiedFilesLabel = [[GTStyles getRoundStatusButtonText:@"Modified Files"] retain];
	conflictedFilesLabel = [[GTStyles getRoundStatusButtonText:@"Conflicted Files"] retain];
}

- (NSRect) getButtonRectSizedForLabel:(NSAttributedString *) label {
	return NSMakeRect(0,0,ceil([label size].width+sidePadding*2),ceil(buttonHeight));
}

- (NSPoint) getAttributedStringPositionForLabel:(NSAttributedString *) label {
	return NSMakePoint(sidePadding,3);
}

- (NSRect) updateButtonRectPositionForRightAlign:(GTScale3Control *) button {
	double x;
	double y = 3;
	NSRect rect;
	if(lastButton is nil) {
		x = floor([gtwindow frame].size.width - [button frame].size.width - windowSpacing);
		rect = NSMakeRect(x,y,[button frame].size.width,[button frame].size.height);
	} else {
		x = floor([lastButton frame].origin.x - [button frame].size.width - buttonSpacing);
		rect = NSMakeRect(x,y,[button frame].size.width,[button frame].size.height);
	}
	lastButton=button;
	return rect;
}

- (NSRect) updateButtonRectPositionForLeftAlign:(GTScale3Control *) button {
	double x;
	double y = 3;
	NSRect rect;
	if(lastButton is nil) {
		x = floor(0);
		rect = NSMakeRect(x,y,[button frame].size.width,[button frame].size.height);
	} else {
		x = floor([lastButton frame].origin.x + [lastButton frame].size.width + buttonSpacing);
		rect = NSMakeRect(x,y,[button frame].size.width,[button frame].size.height);
	}
	lastButton=button;
	return rect;
}

- (void) updateButtonSizeAndPosition:(GTScale3Control *) button label:(NSAttributedString *) label {
	[button setFrame:[self getButtonRectSizedForLabel:label]];
	//[button setFrame:[self updateButtonRectPositionForRightAlign:button]];
	[button setFrame:[self updateButtonRectPositionForLeftAlign:button]];
}

- (void) updateButton:(GTScale3Control *) button toNewX:(float) x {
	NSRect mf = [button frame];
	mf.origin.x += x;
	[button setFrame:mf];
}

- (void) updateLabelForButton:(GTScale3Control *) button newLabel:(NSAttributedString *) label {
	[button setAttributedTitle:[GTStyles getRoundStatusButtonText:[label string]]];
	[button setAttributedTitleDown:[GTStyles getRoundStatusButtonDownText:[label string]]];
	[button setAttributedTitleOver:[GTStyles getRoundStatusButtonOverText:[label string]]];
}

- (void) updateConflictedLabelForButton:(GTScale3Control *) button newLabel:(NSAttributedString *) label {
	[button setAttributedTitle:[GTStyles getRedStatusButtonText:[label string]]];
	[button setAttributedTitleDown:[GTStyles getRedStatusButtonDownText:[label string]]];
	[button setAttributedTitleOver:[GTStyles getRedStatusButtonOverText:[label string]]];
}

- (void) setButtonTargetAndAction:(GTScale3Control *) button {
	[button setTarget:self];
	[button setAction:@selector(toggleFilesStatus:)];
}

- (void) toggleFilesStatus:(id) sender {
	if(sender == deletedFiles) deletedFilesStatus = !deletedFilesStatus;
	if(sender == untrackedFiles) untrackedFilesStatus = !untrackedFilesStatus;
	if(sender == modifiedFiles) modifiedFilesStatus = !modifiedFilesStatus;
	if(sender == stagedFiles) stagedFilesStatus = !stagedFilesStatus;
	if(sender == conflictedFiles) conflictedFilesStatus = !conflictedFilesStatus;
	[gd onStatusBarFilesToggled];
}

- (void) initDeletedFilesButton {
	deletedFiles = [[GTScale3Control alloc] initWithFrame:NSMakeRect(0,0,0,0)];
	[deletedFiles setScaledImage:[NSImage imageNamed:@"statusBlackNormal2.png"]];
	[deletedFiles setScaledOverImage:[NSImage imageNamed:@"statusBlackOver2.png"]];
	[deletedFiles setScaledDownImage:[NSImage imageNamed:@"statusBlackDown.png"]];
	[deletedFiles setAttributedTitle:[GTStyles getRoundStatusButtonText:[deletedFilesLabel string]]];
	[deletedFiles setAttributedTitleDown:[GTStyles getRoundStatusButtonDownText:[deletedFilesLabel string]]];
	[deletedFiles setAttributedTitleOver:[GTStyles getRoundStatusButtonOverText:[deletedFilesLabel string]]];
	[deletedFiles setEdgeSize:NSMakeSize(sidePadding,0)];
	[deletedFiles setIsPushButton:true];
	[deletedFiles setAutoresizingMask:(NSViewMinXMargin)];
	[self setButtonTargetAndAction:deletedFiles];
}

- (void) invalidateDeleteFilesButton {
	if(deletedFilesCount < 1) return;
	[self updateLabelForButton:deletedFiles newLabel:deletedFilesLabel];
	[self updateButtonSizeAndPosition:deletedFiles label:deletedFilesLabel];
	[deletedFiles setAttributedTitlePosition:[self getAttributedStringPositionForLabel:deletedFilesLabel]];
	[self addSubview:deletedFiles];
}

- (void) initUntrackedFilesButton {
	untrackedFiles = [[GTScale3Control alloc] initWithFrame:NSMakeRect(0,0,0,0)];
	[untrackedFiles setScaledImage:[NSImage imageNamed:@"statusBlackNormal2.png"]];
	[untrackedFiles setScaledOverImage:[NSImage imageNamed:@"statusBlackOver2.png"]];
	[untrackedFiles setScaledDownImage:[NSImage imageNamed:@"statusBlackDown.png"]];
	[untrackedFiles setAttributedTitle:[GTStyles getRoundStatusButtonText:[untrackedFilesLabel string]]];
	[untrackedFiles setAttributedTitleDown:[GTStyles getRoundStatusButtonDownText:[untrackedFilesLabel string]]];
	[untrackedFiles setAttributedTitleOver:[GTStyles getRoundStatusButtonOverText:[untrackedFilesLabel string]]];
	[untrackedFiles setEdgeSize:NSMakeSize(sidePadding,0)];
	[untrackedFiles setIsPushButton:true];
	[untrackedFiles setAutoresizingMask:(NSViewMinXMargin)];
	[self setButtonTargetAndAction:untrackedFiles];
}

- (void) invalidateUntrackedFilesButton {
	if(untrackedFilesCount < 1) return;
	[self updateLabelForButton:untrackedFiles newLabel:untrackedFilesLabel];
	[self updateButtonSizeAndPosition:untrackedFiles label:untrackedFilesLabel];
	[untrackedFiles setAttributedTitlePosition:[self getAttributedStringPositionForLabel:untrackedFilesLabel]];
	[self addSubview:untrackedFiles];
}

- (void) initStagedFilesButton {
	stagedFiles = [[GTScale3Control alloc] initWithFrame:NSMakeRect(0,0,0,0)];
	[stagedFiles setScaledImage:[NSImage imageNamed:@"statusBlackNormal2.png"]];
	[stagedFiles setScaledOverImage:[NSImage imageNamed:@"statusBlackOver2.png"]];
	[stagedFiles setScaledDownImage:[NSImage imageNamed:@"statusBlackDown.png"]];
	[stagedFiles setAttributedTitle:[GTStyles getRoundStatusButtonText:[stagedFilesLabel string]]];
	[stagedFiles setAttributedTitleDown:[GTStyles getRoundStatusButtonDownText:[stagedFilesLabel string]]];
	[stagedFiles setAttributedTitleOver:[GTStyles getRoundStatusButtonOverText:[stagedFilesLabel string]]];
	[stagedFiles setEdgeSize:NSMakeSize(sidePadding,0)];
	[stagedFiles setIsPushButton:true];
	[stagedFiles setAutoresizingMask:(NSViewMinXMargin)];
	[self setButtonTargetAndAction:stagedFiles];
}

- (void) invalidateStagedFilesButton {
	if(stagedFilesCount < 1) return;
	[self updateLabelForButton:stagedFiles newLabel:stagedFilesLabel];
	[self updateButtonSizeAndPosition:stagedFiles label:stagedFilesLabel];
	[stagedFiles setAttributedTitlePosition:[self getAttributedStringPositionForLabel:stagedFilesLabel]];
	[self addSubview:stagedFiles];
}

- (void) initModifiedFilesButton {
	modifiedFiles = [[GTScale3Control alloc] initWithFrame:NSMakeRect(0,0,0,0)];
	[modifiedFiles setScaledImage:[NSImage imageNamed:@"statusBlackNormal2.png"]];
	[modifiedFiles setScaledOverImage:[NSImage imageNamed:@"statusBlackOver2.png"]];
	[modifiedFiles setScaledDownImage:[NSImage imageNamed:@"statusBlackDown.png"]];
	[modifiedFiles setAttributedTitle:[GTStyles getGrayRoundStatusButtonText:[modifiedFilesLabel string]]];
	[modifiedFiles setAttributedTitleDown:[GTStyles getRoundStatusButtonDownText:[modifiedFilesLabel string]]];
	[modifiedFiles setAttributedTitleOver:[GTStyles getRoundStatusButtonOverText:[modifiedFilesLabel string]]];
	[modifiedFiles setEdgeSize:NSMakeSize(sidePadding,0)];
	[modifiedFiles setIsPushButton:true];
	[modifiedFiles setAutoresizingMask:(NSViewMinXMargin)];
	[self setButtonTargetAndAction:modifiedFiles];
}

- (void) invalidateModifiedFilesButton {
	if(modifiedFilesCount < 1) return;
	[self updateLabelForButton:modifiedFiles newLabel:modifiedFilesLabel];
	[self updateButtonSizeAndPosition:modifiedFiles label:modifiedFilesLabel];
	[modifiedFiles setAttributedTitlePosition:[self getAttributedStringPositionForLabel:modifiedFilesLabel]];
	[self addSubview:modifiedFiles];
}

- (void) initConflictedFilesButton {
	conflictedFiles = [[GTScale3Control alloc] initWithFrame:NSMakeRect(0,0,0,0)];
	[conflictedFiles setScaledImage:[NSImage imageNamed:@"statusConflictedNormal.png"]];
	[conflictedFiles setScaledOverImage:[NSImage imageNamed:@"statusConflictedOver.png"]];
	[conflictedFiles setScaledDownImage:[NSImage imageNamed:@"statusConflictedDown.png"]];
	[conflictedFiles setAttributedTitle:[GTStyles getGrayRoundStatusButtonText:[conflictedFilesLabel string]]];
	[conflictedFiles setAttributedTitleDown:[GTStyles getGrayRoundStatusButtonText:[conflictedFilesLabel string]]];
	[conflictedFiles setAttributedTitleOver:[GTStyles getGrayRoundStatusButtonText:[conflictedFilesLabel string]]];
	[conflictedFiles setEdgeSize:NSMakeSize(sidePadding,0)];
	[conflictedFiles setIsPushButton:true];
	[conflictedFiles setAutoresizingMask:(NSViewMinXMargin)];
	[self setButtonTargetAndAction:conflictedFiles];
}

- (void) invalidateConflictedFilesButton {
	if(unmergedFilesCount < 1) return;
	[self updateConflictedLabelForButton:conflictedFiles newLabel:conflictedFilesLabel];
	[self updateButtonSizeAndPosition:conflictedFiles label:conflictedFilesLabel];
	[conflictedFiles setAttributedTitlePosition:[self getAttributedStringPositionForLabel:conflictedFilesLabel]];
	[self addSubview:conflictedFiles];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTStatusBarView\n");
	#endif
	if([deletedFiles superview]) [deletedFiles removeFromSuperview];
	if([untrackedFiles superview]) [untrackedFiles removeFromSuperview];
	if([modifiedFiles superview]) [modifiedFiles removeFromSuperview];
	if([stagedFiles superview]) [stagedFiles removeFromSuperview];
	if([conflictedFiles superview]) [conflictedFiles removeFromSuperview];
	GDRelease(deletedFilesLabel);
	GDRelease(untrackedFilesLabel);
	GDRelease(stagedFilesLabel);
	GDRelease(modifiedFilesLabel);
	GDRelease(conflictedFilesLabel);
	GDRelease(conflictedFiles);
	GDRelease(deletedFiles);
	GDRelease(untrackedFiles);
	GDRelease(modifiedFiles);
	GDRelease(stagedFiles);
	splitContentView=nil;
	[super dealloc];
}

@end
