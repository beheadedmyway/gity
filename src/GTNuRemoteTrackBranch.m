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

#import "GTNuRemoteTrackBranch.h"
#import "GittyDocument.h"

@implementation GTNuRemoteTrackBranch

- (void) awakeFromNib {
	[super awakeFromNib];
	if(remoteBranch is nil) return;
	[self initSpinner];
	[self updatePopUpButtons];
	[remoteBranch setEnabled:false];
	[localBranchName setEnabled:false];
	[localBranchName setDelegate:self];
	[notAtRemote removeFromSuperview];
	branchesCache=[[NSMutableDictionary alloc] init];
}

- (void) initSpinner {
	NSRect r=[spinner frame];
	[spinner setFrame:NSMakeRect(r.origin.x,r.origin.y,10,10)];
	[spinner removeFromSuperview];
	[spinner setUsesThreadedAnimation:true];
}

- (void) menuDidClose:(NSMenu *) menu {
	if(menu == sourceRemotes) {
		if([menu indexOfItem:lastHighlightedItem] < 1) {
			[notAtRemote removeFromSuperview];
			[remoteBranch setEnabled:false];
			[localBranchName setStringValue:@""];
			[localBranchName setEnabled:false];
			return;
		}
		[spinner startAnimation:nil];
		[remoteBox addSubview:spinner];
		[sourceRemote setEnabled:false];
		NSString * remote = [lastHighlightedItem title];
		if([branchesCache objectForKey:remote]) {
			[self updateRemoteBranchNames];
		} else {
			working=true;
			[notAtRemote removeFromSuperview];
			[operations runGetRemoteBranchNamesFromRemote:[lastHighlightedItem title]];
		}
	} else {
		if([menu indexOfItem:lastHighlightedItem] < 1) {
			[localBranchName setStringValue:@""];
			[localBranchName setEnabled:false];
			return;
		} else {
			[localBranchName setEnabled:true];
			[localBranchName setStringValue:[lastHighlightedItem title]];
		}
	}
}

- (void) menu:(NSMenu *) menu willHighlightItem:(NSMenuItem *) item {
	lastHighlightedItem=item;
}

- (void) updatePopUpButtons {
	GDRelease(sourceRemotes);
	GDRelease(availableBranches);
	sourceRemotes = [[NSMenu alloc] init];
	availableBranches = [[NSMenu alloc] init];
	[sourceRemotes setDelegate:self];
	[availableBranches setDelegate:self];
	NSMutableArray * remotes = [gitd remoteNames];
	NSString * remote;
	NSMenuItem * item = [[NSMenuItem alloc] init];
	[item setTitle:@"Select A Remote"];
	[sourceRemotes addItem:item];
	item=nil;
	for(remote in remotes) {
		item = [[NSMenuItem alloc] init];
		[item setTitle:remote];
		[sourceRemotes addItem:item];
		item = nil;
	}
	[sourceRemote setMenu:sourceRemotes];
}

- (void) updateRemoteBranchNames {
	if([[gitd remoteBranchNames] count] < 1) {
		[remoteBox addSubview:notAtRemote];
		[sourceRemote setEnabled:true];
		[spinner stopAnimation:nil];
		[spinner removeFromSuperview];
	}
	NSMutableArray * bn;
	NSString * remote = [[sourceRemote selectedItem] title];
	bn=[branchesCache objectForKey:remote];
	if(bn is nil) {
		bn = [gitd remoteBranchNames];
		[branchesCache setObject:bn forKey:remote];
	}
	GDRelease(availableBranches);
	availableBranches = [[NSMenu alloc] init];
	[availableBranches setDelegate:self];
	NSMenuItem * item = [[NSMenuItem alloc] init];
	[item setTitle:@"Select A Branch"];
	[availableBranches addItem:item];
	item=nil;
	NSString * branch;
	for(branch in bn) {
		item=[[NSMenuItem alloc] init];
		[item setTitle:branch];
		[availableBranches addItem:item];
		item=nil;
	}
	[remoteBranch setMenu:availableBranches];
	[remoteBranch setEnabled:true];
	[sourceRemote setEnabled:true];
	[spinner stopAnimation:nil];
	[spinner removeFromSuperview];
	availableBranches=nil;
	working=false;
}

- (void) disableAll {
	[sourceRemote selectItemAtIndex:0];
	[remoteBranch setEnabled:false];
	[localBranchName setEnabled:false];
}

- (void) initButtons {
	NSPoint tl = [self getTL];
	NSPoint tr = [self getTR];
	ok=[[GTScale9Control alloc] initWithFrame:NSMakeRect(352,20,62,27)];
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
	[[window contentView] addSubview:ok];
	
	cancel=[[GTScale9Control alloc] initWithFrame:NSMakeRect(287,20,62,27)];
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
	[[window contentView] addSubview:cancel];
}

- (void) onok:(id) sender {
	if(working) {
		NSBeep();
		return;
	}
	NSString * localBranchNameValue = [localBranchName stringValue];
	NSString * remoteBranchNameValue = [[remoteBranch selectedItem] title];
	NSString * remote = [[sourceRemote selectedItem] title];
	if([sourceRemote indexOfSelectedItem] < 1) {
		NSBeep();
		[sourceRemote becomeFirstResponder];
		return;
	}
	if([localBranchNameValue length] is 0) {
		NSBeep();
		[localBranchName becomeFirstResponder];
		return;
	}
	NSRange s = [localBranchNameValue rangeOfString:@" "];
	if(!(s.location==NSNotFound)) {
		[localBranchName becomeFirstResponder];
		NSBeep();
		return;
	}
	[operations runNewTrackingBranchWithLocalBranch:localBranchNameValue andRemoteBranch:remoteBranchNameValue andRemote:remote];
	if(target) [target performSelector:action];
	[self disposeNibs];
}

- (void) loadNibs {
	if(available) return;
	if(window == nil) [NSBundle loadNibNamed:@"NewTrackingBranch" owner:self];
	available = true;
}

- (void) disposeNibs {
	[super disposeNibs];
	if(spinner) {
		[spinner stopAnimation:nil];
		GDRelease(spinner);
	}
	GDRelease(notAtRemote);
	GDRelease(sourceRemotes);
	GDRelease(branchesCache);
	lastHighlightedItem = nil;
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTNuRemoteTrackBranch\n");
	#endif
	[self disposeNibs];
}

@end
