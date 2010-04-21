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

#import "GTNewRemoteController.h"
#import "GittyDocument.h"

@implementation GTNewRemoteController

- (void) awakeFromNib {
	[super awakeFromNib];
	if(remoteName) {
		[remoteName setDelegate:self];
		[remoteName becomeFirstResponder];
	}
	if(remoteURL)[remoteURL setDelegate:self];
}

- (void) help:(id)sender {
	NSString * v = [remoteURL stringValue];
	if([v isEmpty]) [remoteURL setStringValue:@"git://git.server.com/project.git"];
	else if([v isEqual:@"git://git.server.com/project.git"])[remoteURL setStringValue:@"git@127.0.0.1:project.git"];
	else if([v isEqual:@"git@127.0.0.1:project.git"])[remoteURL setStringValue:@"http://git.server.com/project.git"];
	else if([v isEqual:@"http://git.server.com/project.git"])[remoteURL setStringValue:@"git://git.server.com/project.git"];
}

- (NSString *) remoteURLValue {
	return _remoteURLValue;
}

- (NSString *) remoteNameValue {
	return _remoteNameValue;
}

- (void) initButtons {
	NSPoint tl = [self getTL];
	NSPoint tr = [self getTR];
	ok = [[GTScale9Control alloc] initWithFrame:NSMakeRect(291,20,62,27)];
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
	
	cancel = [[GTScale9Control alloc] initWithFrame:NSMakeRect(225,20,62,27)];
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
	BOOL valid = true;
	GDRelease(_remoteNameValue);
	GDRelease(_remoteURLValue);
	_remoteNameValue = [[remoteName stringValue] copy];
	_remoteURLValue = [[remoteURL stringValue] copy];
	if([[gd gitd] hasRemote:_remoteNameValue]) {
		[modals runHasRemoteAlready];
		return;
	}
	lastButtonValue = NSOKButton;
	if([_remoteURLValue isEmptyOrContainsSpace]) {
		[remoteURL becomeFirstResponder];
		valid=false;
	}
	if([_remoteNameValue isEmptyOrContainsSpace]) {
		[remoteName becomeFirstResponder];
		valid=false;
	}
	if(!valid) {
		NSBeep();
		return;
	}
	[target performSelector:action];
	[self disposeNibs];
}

- (void) cancel:(id) sender {
	lastButtonValue = NSCancelButton;
	_remoteNameValue = [[remoteName stringValue] copy];
	_remoteURLValue = [[remoteURL stringValue] copy];
	[target performSelector:action];
	[self disposeNibs];
}

- (NSInteger) lastButtonValue {
	return lastButtonValue;
}

- (void) loadNibs {
	if(available) return;
	if(window == nil) [NSBundle loadNibNamed:@"NewRemote" owner:self];
	available = true;
}

- (void) disposeNibs {
	[super disposeNibs];
	lastButtonValue = NSCancelButton;
	[_remoteNameValue release];
	[_remoteURLValue release];
	_remoteNameValue = nil;
	_remoteURLValue = nil;
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTNewRemoteController\n");
	#endif
	[self disposeNibs];
	[super dealloc];
}

@end
