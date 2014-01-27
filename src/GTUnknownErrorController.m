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

#import "GTUnknownErrorController.h"
#import "GittyDocument.h"
#import "NS(Attributed)String+Geometrics.h"

@implementation GTUnknownErrorController

- (void) showAsSheetWithError:(NSString *) error {
	if([window isSheet]) {
        if (error)
        {
            NSString * e = [[[errorField stringValue] stringByAppendingString:@"\n---------------\n"] stringByAppendingString:error];
            [errorField setStringValue:e];
        }
	} else {
		[self loadNibs];
		[errorField setStringValue:error];
        [self sizeToFitError];
		[self showAsSheet];
	}
}

- (void)showAsSheetWithTitle:(NSString *)title error:(NSString *)error;
{
	if([window isSheet]) {
        if (error)
        {
            NSString * e = [[[errorField stringValue] stringByAppendingString:@"\n---------------\n"] stringByAppendingString:error];
            [errorField setStringValue:e];
        }
	} else {
		[self loadNibs];
		[errorField setStringValue:error];
        [titleField setStringValue:title];
        [self sizeToFitError];
		[self showAsSheet];
	}    
}

- (void)sizeToFitError
{
    NSRect windowRect = window.frame;
    NSRect textRect = errorField.frame;
    NSSize newSize = [[errorField stringValue] sizeForWidth:textRect.size.width height:FLT_MAX font:errorField.font];
    
    CGFloat heightDiff = newSize.height - textRect.size.height;
    textRect.size.height = newSize.height + 10;
    
    windowRect.size.height += heightDiff;
    
    errorField.frame = textRect;
    [window setFrame:windowRect display:NO];
}

- (void) showAsSheet {
	[super showAsSheet];
	[window makeKeyAndOrderFront:nil];
}

- (void) initButtons {    
	NSPoint tl=[self getTL];
	NSPoint tr=[self getTR];
	/*ok = [[GTScale9Control alloc] initWithFrame:NSMakeRect(421,20,62,27)];
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
	[[window contentView] addSubview:ok];*/
	cancel=[[GTScale9Control alloc] initWithFrame:NSMakeRect(335,20,62,27)];
	NSAssert(cancel!=nil,@"Assert Fail: cancel!=nil, cancel was indeed nil");
	[cancel sendsActionOnMouseUp:true];
	[cancel setScaledImage:[NSImage imageNamed:@"blackButton2.png"]];
	[cancel setScaledOverImage:[NSImage imageNamed:@"blackButton2Over.png"]];
	[cancel setScaledDownImage:[NSImage imageNamed:@"blackButton2Down.png"]];
	[cancel setTopLeftPoint:tl];
	[cancel setBottomRightPoint:tr];
	[cancel setAttributedTitle:[GTStyles getButtonString:@"OK"]];
	[cancel setAttributedTitleDown:[GTStyles getDownButtonString:@"OK"]];
	//[cancel setAttributedTitlePosition:NSMakePoint(12,6)];
    [cancel setAttributedTitlePosition:NSMakePoint(22,6)];
	[cancel setAction:@selector(cancel:)];
	[cancel setTarget:self];
	[[window contentView] addSubview:cancel];
}

- (void) onok:(id) sender {
	NSString * msg = [[errorField stringValue] copy];
	[operations runSendErrorEmail:msg];
	[self disposeNibs];
}

- (void) loadNibs {
	if(available) return;
	//[NSBundle loadNibNamed:@"UnknownError" owner:self];
    [NSBundle loadNibNamed:@"GitErrorSheet" owner:self];
	available=true;
}


@end
