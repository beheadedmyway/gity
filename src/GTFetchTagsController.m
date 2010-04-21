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

#import "GTFetchTagsController.h"
#import "GittyDocument.h"

@implementation GTFetchTagsController

- (void) awakeFromNib {
	[super awakeFromNib];
	if(remoteTag is nil) return;
	[self initSpinner];
	[self updatePopUpButtons];
	[remoteTag setEnabled:false];
	[notAtRemote retain];
	[notAtRemote removeFromSuperview];
	tagCache=[[NSMutableDictionary alloc] init];
}

- (void) initSpinner {
	NSRect r=[spinner frame];
	[spinner setFrame:NSMakeRect(r.origin.x,r.origin.y,10,10)];
	[spinner retain];
	[spinner removeFromSuperview];
	[spinner setUsesThreadedAnimation:true];
}

- (void) menuDidClose:(NSMenu *) menu {
	if(menu == sourceRemotes) {
		if([menu indexOfItem:lastHighlightedItem] < 1) {
			[notAtRemote removeFromSuperview];
			[remoteTag setEnabled:false];
			return;
		}
		[spinner startAnimation:nil];
		[tagBox addSubview:spinner];
		[sourceRemote setEnabled:false];
		NSString * remote=[lastHighlightedItem title];
		if([tagCache objectForKey:remote]) [self updateRemoteTagNames];
		else {
			working=true;
			[notAtRemote removeFromSuperview];
			[operations runGetRemoteTagNamesFromRemote:[lastHighlightedItem title]];
		}
	} else {
		if([menu indexOfItem:lastHighlightedItem] < 1) return;
	}
}

- (void) menu:(NSMenu *) menu willHighlightItem:(NSMenuItem *) item {
	lastHighlightedItem=item;
}

- (void) updatePopUpButtons {
	working=false;
	GDRelease(sourceRemotes);
	GDRelease(availableTags);
	sourceRemotes = [[NSMenu alloc] init];
	availableTags = [[NSMenu alloc] init];
	[sourceRemotes setDelegate:self];
	[availableTags setDelegate:self];
	NSMutableArray * remotes = [gitd remoteNames];
	NSString * remote;
	NSMenuItem * item = [[NSMenuItem alloc] init];
	[item setTitle:@"Select A Remote"];
	[sourceRemotes addItem:item];
	[item release];
	item=nil;
	for(remote in remotes) {
		item = [[NSMenuItem alloc] init];
		[item setTitle:remote];
		[sourceRemotes addItem:item];
		[item release];
		item=nil;
	}
	[sourceRemote setMenu:sourceRemotes];
}

- (void) updateRemoteTagNames {
	if([[gitd remoteTagNames] count] < 1) {
		[tagBox addSubview:notAtRemote];
		[sourceRemote setEnabled:true];
		[spinner stopAnimation:nil];
		[spinner removeFromSuperview];
		working=false;
		return;
	}
	NSMutableArray * bn;
	NSString * remote = [[sourceRemote selectedItem] title];
	bn=[tagCache objectForKey:remote];
	if(bn is nil) {
		bn = [gitd remoteTagNames];
		[tagCache setObject:bn forKey:remote];
	}
	GDRelease(availableTags);
	availableTags = [[NSMenu alloc] init];
	[availableTags setDelegate:self];
	NSMenuItem * item = [[NSMenuItem alloc] init];
	[item setTitle:@"Select A Tag"];
	[availableTags addItem:item];
	[item release];
	item = nil;
	NSString * branch;
	for(branch in bn) {
		item=[[NSMenuItem alloc] init];
		[item setTitle:branch];
		[availableTags addItem:item];
		[item release];
		item=nil;
	}
	[remoteTag setMenu:availableTags];
	[remoteTag setEnabled:true];
	[sourceRemote setEnabled:true];
	[spinner stopAnimation:nil];
	[spinner removeFromSuperview];
	[availableTags release];
	availableTags=nil;
	working=false;
}

- (void) disableAll {
	[sourceRemote selectItemAtIndex:0];
	[remoteTag setEnabled:false];
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
	[[window contentView] addSubview:ok];
	[ok setAction:@selector(onok:)];
	[ok setTarget:self];
	
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
	NSString * remoteTagNameValue = [[remoteTag selectedItem] title];
	NSString * remote = [[sourceRemote selectedItem] title];
	if([sourceRemote indexOfSelectedItem] < 1) {
		NSBeep();
		return;
	}
	if([remoteTag indexOfSelectedItem] < 1) {
		NSBeep();
		return;
	}
	[operations runFetchTag:remoteTagNameValue fromRemote:remote];
	if(target) [target performSelector:action];
	[self disposeNibs];
}

- (void) loadNibs {
	if(available) return;
	if(window == nil) [NSBundle loadNibNamed:@"FetchTags" owner:self];
	available=true;
}

- (void) disposeNibs {
	[super disposeNibs];
	if(spinner) {
		[spinner stopAnimation:nil];
		GDRelease(spinner);
	}
	GDRelease(notAtRemote);
	GDRelease(sourceRemotes);
	GDRelease(tagCache);
	lastHighlightedItem=nil;
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTFetchTagsController\n");
	#endif
	[self disposeNibs];
	[super dealloc];
}

@end
