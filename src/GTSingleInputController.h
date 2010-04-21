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

#import <Cocoa/Cocoa.h>
#import <RegexKit/RegexKit.h>
#import <GDKit/GDKit.h>
#import "GTBaseExternalNibController.h"
#import "GTScale9Control.h"
#import "GTStyles.h"

@interface GTSingleInputController : GTBaseExternalNibController <NSTextFieldDelegate> {
	BOOL allowsSpaces;
	BOOL _wasChecked;
	BOOL showsCheckout;
	IBOutlet NSTextField * sheetTitle;
	IBOutlet NSTextField * inputLabel;
	IBOutlet NSTextField * input;
	IBOutlet NSButton * checkout;
	NSInteger lastButtonValue;
	NSString * _sheetTitle;
	NSString * _inputLabel;
	NSString * _inputValue;
}

@property (readonly,nonatomic) NSInteger lastButtonValue;

- (void) initButtons;
- (void) setSheetTitleValue:(NSString *) _title;
- (void) setInputLabelValue:(NSString *) _label;
- (void) setAllowsSpaces:(BOOL) spaces;
- (void) setShowsCheckoutCheckbox:(BOOL) useCheckbox;
- (BOOL) isValid;
- (BOOL) wasCheckoutChecked;
- (NSString *) inputValue;

@end
