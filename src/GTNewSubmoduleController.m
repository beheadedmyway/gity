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

#import "GTNewSubmoduleController.h"
#import "GittyDocument.h"

@implementation GTNewSubmoduleController

- (void) awakeFromNib {
	[submoduleName setDelegate:self];
	[submoduleURL setDelegate:self];
	[submoduleDestination setDelegate:self];
	[submoduleName becomeFirstResponder];
}

- (void) help:(id)sender {
	NSString * v=[submoduleURL stringValue];
	if([v isEmpty])[submoduleURL setStringValue:@"git://git.server.com/project.git"];
	else if([v isEqual:@"git://git.server.com/project.git"])[submoduleURL setStringValue:@"git@127.0.0.1:project.git"];
	else if([v isEqual:@"git@127.0.0.1:project.git"])[submoduleURL setStringValue:@"http://git.server.com/project.git"];
	else if([v isEqual:@"http://git.server.com/project.git"])[submoduleURL setStringValue:@"git://git.server.com/project.git"];
}

- (void) initButtons {
	NSPoint tl = [self getTL];
	NSPoint tr = [self getTR];
	chooseDestination=[[GTScale9Control alloc] initWithFrame:NSMakeRect(376,148,32,27)];
	[chooseDestination sendsActionOnMouseUp:true];
	[chooseDestination setScaledImage:[NSImage imageNamed:@"blackButton2.png"]];
	[chooseDestination setScaledOverImage:[NSImage imageNamed:@"blackButton2Over.png"]];
	[chooseDestination setScaledDownImage:[NSImage imageNamed:@"blackButton2Down.png"]];
	[chooseDestination setTopLeftPoint:tl];
	[chooseDestination setBottomRightPoint:tr];
	[chooseDestination setIcon:[NSImage imageNamed:@"folderIcon.png"]];
	[chooseDestination setIconPosition:NSMakePoint(8,7)];
	[chooseDestination setTarget:self];
	[chooseDestination setAction:@selector(choosedir:)];
	[[window contentView] addSubview:chooseDestination];
	
	ok = [[GTScale9Control alloc] initWithFrame:NSMakeRect(355,20,62,27)];
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
	
	cancel = [[GTScale9Control alloc] initWithFrame:NSMakeRect(289,20,62,27)];
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
	_submoduleURL = [[submoduleURL stringValue] copy];
	_submoduleDestination = [[submoduleDestination stringValue] copy];
	_submoduleName = [[submoduleName stringValue] copy];
	if([_submoduleName isEmptyOrContainsSpace]) {
		NSBeep();
		[submoduleName becomeFirstResponder];
		return;
	}
	if([_submoduleURL isEmptyOrContainsSpace]) {
		NSBeep();
		[submoduleURL becomeFirstResponder];
		return;
	}
	if([_submoduleDestination isEmpty]) {
		NSBeep();
		[submoduleDestination becomeFirstResponder];
		return;
	}
	if(![self checkIfDestIsInRepo]) {
		[modals runSubmoduleDestinationIncorrect];
		return;
	}
	if(target) [target performSelector:action];
	[self disposeNibs];
}

- (void) choosedir:(id) sender {
	NSOpenPanel * op = [NSOpenPanel openPanel];
	[op setCanChooseDirectories:true];
	[op setCanCreateDirectories:true];
	[op setCanChooseFiles:false];
    [op setDirectoryURL:[NSURL fileURLWithPath:[git gitProjectPath]]];
    [op beginSheetModalForWindow:window completionHandler:^(NSInteger result) {
        NSOpenPanel * op = (NSOpenPanel *) sender;
        if(result is NSFileHandlingPanelCancelButton) return;
        _submoduleDestination = [[[op URL] path] copy];
        [submoduleDestination setStringValue:_submoduleDestination];
    }];
}

- (BOOL) checkIfDestIsInRepo {
	NSString * proj = [git gitProjectPath];
	NSString * reg = [proj stringByAppendingString:@".*$"];
	NSString * dest = [submoduleDestination stringValue];
	if([dest isMatchedByRegex:reg]) return true;
	return false;
}

- (NSString *) submoduleDestination {
	return _submoduleDestination;
}

- (NSString *) submoduleURL {
	return _submoduleURL;
}

- (NSString *) submoduleName {
	return _submoduleName;
}

- (void) loadNibs {
	if(available)return;
	if(window==nil)[NSBundle loadNibNamed:@"NewSubmodule" owner:self];
	available=true;
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTNewSubmoduleController\n");
	#endif
	GDRelease(_submoduleURL);
	GDRelease(_submoduleDestination);
	GDRelease(_submoduleName);
	GDRelease(chooseDestination);
	[self disposeNibs];
	[super dealloc];
}

@end
