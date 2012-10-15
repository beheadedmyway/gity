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

#import "GTCommitMessageController.h"
#import "GittyDocument.h"
#import "GTDocumentController.h"

@implementation GTCommitMessageController
@synthesize commitMessageValue;
@synthesize addBeforeCommit;

- (void) awakeFromNib {
	if(messageField is nil) return;
	[messageField setDelegate:self];
	[window setContentBorderThickness:15 forEdge:NSMinYEdge];
	[super awakeFromNib];
}

- (void) show {
	readyToCommit = NO;
	[super show];
}

- (void) showAsSheet {
	readyToCommit = NO;
	[super showAsSheet];
	[self focus];
	[self updateMessageFieldAttributes];
	[messageField setDelegate:self];
}

- (void) focus {
	if(window) [window makeKeyWindow];
	[window makeFirstResponder:messageField];
}

- (void) updateMessageFieldAttributes {
	[messageField setTextContainerInset:NSMakeSize(0,4)];
	[messageField setFont:[NSFont fontWithName:@"Lucida Grande" size:11]];
}

- (BOOL) textView:(NSTextView *) aTextView doCommandBySelector:(SEL) aSelector {
	NSEvent * event = [NSApp currentEvent];
	if(([event modifierFlags] & NSCommandKeyMask) && ([event keyCode] == 36 /* enter */)) {
		[self performSelectorOnMainThread:@selector(onok:) withObject:nil waitUntilDone:false];
		return YES;
	}
	return NO;
	//return FALSE;
}

- (void) initButtons {
	NSPoint tl = [self getTL];
	NSPoint tr = [self getTR];
	ok = [[GTScale9Control alloc] initWithFrame:NSMakeRect(345,25,62,27)];
	NSAssert(ok!=nil,@"Assert Fail: ok!=nil, ok was indeed nil");
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
	[ok fixRightEdge:true];
	[ok fixLeftEdge:false];
	[ok fixBottomEdge:true];
	[[window contentView] addSubview:ok];
	
	cancel = [[GTScale9Control alloc] initWithFrame:NSMakeRect(280,25,62,27)];
	NSAssert(cancel!=nil,@"Assert Fail: cancel!=nil, cancel was indeed nil");
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
	[cancel fixRightEdge:true];
	[cancel fixLeftEdge:false];
	[cancel fixBottomEdge:true];
	[[window contentView] addSubview:cancel];
}

- (IBAction) onok:(id) sender {
	NSString * val = [[messageField textStorage] string];
	if([val length] is 0) {
		NSBeep();
		return;
	}
	commitMessageValue = [val copy];
	if(target) 
		[target performSelector:action];
	readyToCommit = YES;
	fileSelection = [[[gd activeBranchView] selectedFiles] copy];
	if (addBeforeCommit)
		[operations runAddFilesOperation];
	else
	{
		[self finishTwoStageCommit];
	}
}

- (void) finishTwoStageCommit {
	if (!readyToCommit)
		return;
	
	if ([gd.gitd stagedFilesCount] >= 1)
		[operations runCommitOperationWithFiles:fileSelection];
	else
		NSBeep();
	self.addBeforeCommit = false;
	[self disposeNibs];
}

- (BOOL) shouldSignoff {
	return [signoff state];
}

- (void) loadNibs {
	if(available) return;
	if(window==nil) [NSBundle loadNibNamed:@"CommitMessage" owner:self];
	available=true;
}

- (void) disposeNibs {
	label=nil;
	messageField=nil;
	[fileSelection release];
	fileSelection = nil;
	GDRelease(commitMessageValue);
	[super disposeNibs];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTCommitMessageController\n");
	#endif
	[self disposeNibs];
	[super dealloc];
}

@end
