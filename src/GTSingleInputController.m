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

#import "GTSingleInputController.h"
#import "GittyDocument.h"

@implementation GTSingleInputController
@synthesize lastButtonValue;

- (void) awakeFromNib {
	[super awakeFromNib];
	if(_inputLabel) [inputLabel setStringValue:_inputLabel];
	if(_sheetTitle) [sheetTitle setStringValue:_sheetTitle];
	[input setDelegate:self];
	if(!showsCheckout) if([checkout superview]) [checkout removeFromSuperview];
}

- (void) showAsSheet {
	[super showAsSheet];
	[input becomeFirstResponder];
}

- (void) reset {
	[input setStringValue:@""];
}

- (void) setAllowsSpaces:(BOOL) spaces {
	allowsSpaces=spaces;
}

- (void) setShowsCheckoutCheckbox:(BOOL) useCheckbox {
	showsCheckout=useCheckbox;
}

- (BOOL) wasCheckoutChecked {
	return _wasChecked;
}

- (void) initButtons {
	NSPoint tl = [self getTL];
	NSPoint tr = [self getTR];
	ok = [[GTScale9Control alloc] initWithFrame:NSMakeRect(254,15,62,27)];
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
	
	cancel = [[GTScale9Control alloc] initWithFrame:NSMakeRect(186,15,62,27)];
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

- (void) cancel:(id) sender {
	lastButtonValue = NSCancelButton;
	[target performSelector:action];
	[self disposeNibs];
}

- (void) onok:(id) sender {
	_inputValue=[[input stringValue] copy];
	if(showsCheckout)_wasChecked=[checkout state];
	if(!allowsSpaces) {
		if([_inputValue isEmptyOrContainsSpace]) {
			NSBeep();
			return;
		}
	}
	lastButtonValue=NSOKButton;
	[target performSelector:action];
	[self disposeNibs];
}

- (void) loadNibs {
	if(available) return;
	if(window == nil)[NSBundle loadNibNamed:@"SingleInput" owner:self];
	available=true;
}

- (void) setSheetTitleValue:(NSString *) _title {
	if(_sheetTitle neq _title) {
		_sheetTitle = [_title copy];
	}
}

- (void) setInputLabelValue:(NSString *) _label {
	if(_inputLabel neq _label) {
		_inputLabel = [_label copy];
	}
}

- (NSString *) inputValue {
	return _inputValue;
}

- (BOOL) isValid {
	return false;
}

- (void) disposeNibs {
	[super disposeNibs];
	showsCheckout = false;
	allowsSpaces = false;
	lastButtonValue = 0;
	//[checkout release];
	_sheetTitle = nil;
	_inputLabel = nil;
	_inputValue = nil;
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTSingleInputController\n");
	#endif
	[self disposeNibs];
}

@end
