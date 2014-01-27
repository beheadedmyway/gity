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

#import "GTHistorySearchController.h"
#import "GTHistoryView.h"
#import "GittyDocument.h"

@implementation GTHistorySearchController

- (void) awakeFromNib {
	[super awakeFromNib];
	today=[[NSDate date] dateByAddingTimeInterval:86400];
	past=[today dateByAddingTimeInterval:-604800];
	[before setDateValue:today];
	[after setDateValue:past];
	if(lastAfterDate) [after setDateValue:lastAfterDate];
	if(lastBeforeDate) [before setDateValue:lastBeforeDate];
	if(lastAuthorValue) [authorContains setStringValue:lastAuthorValue];
	[matchAll setState:lastMatchAll];
}

- (void) lazyInitWithGD:(GittyDocument *) _gd {
	[super lazyInitWithGD:_gd];
	historyView=[gd historyView];
}

- (void) loadNibs {
	if(available) return;
	if(window == nil) [NSBundle loadNibNamed:@"HistoryAdvancedSearch" owner:self];
	available=true;
}

- (void) initButtons {
	NSPoint tl = [self getTL];
	NSPoint tr = [self getTR];
	ok = [[GTScale9Control alloc] initWithFrame:NSMakeRect(223,20,62,27)];
	NSAssert(ok!=nil,@"Assert Fail: ok!=nil, ok was indeed nil");
	[ok sendsActionOnMouseUp:true];
	[ok setScaledImage:[NSImage imageNamed:@"blackButton2.png"]];
	[ok setScaledOverImage:[NSImage imageNamed:@"blackButton2Over.png"]];
	[ok setScaledDownImage:[NSImage imageNamed:@"blackButton2Down.png"]];
	[ok setTopLeftPoint:tl];
	[ok setBottomRightPoint:tr];
	[ok setAttributedTitle:[GTStyles getButtonString:@"Search"]];
	[ok setAttributedTitleDown:[GTStyles getDownButtonString:@"Search"]];
	[ok setAttributedTitlePosition:NSMakePoint(12,6)];
	[[window contentView] addSubview:ok];
	[ok setAction:@selector(onok:)];
	[ok setTarget:self];
	
	cancel = [[GTScale9Control alloc] initWithFrame:NSMakeRect(157,20,62,27)];
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
	[historyView updateBefore:[before dateValue]
					 andAfter:[after dateValue]
			andAuthorContains:[authorContains stringValue] 
		   andMessageContains:[[messageContains textStorage] string]
			andShouldMatchAll:[matchAll state]];
	lastMessageValue=[[[messageContains textStorage] string] copy];
	lastAuthorValue=[[authorContains stringValue] copy];
	lastBeforeDate=[[before dateValue] copy];
	lastAfterDate=[[after dateValue] copy];
	lastMatchAll=[matchAll state];
	[gd onHistorySearch];
	[self disposeNibs];
}

- (void) cancel:(id) sender {
	[self disposeNibs];
}

- (void) disposeNibs {
	[super disposeNibs];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTHistorySearchController\n");
	#endif
	[self disposeNibs];
	lastMessageValue=nil;
	lastAuthorValue=nil;
	lastBeforeDate=nil;
	lastAfterDate=nil;
	lastMatchAll=false;
	today=nil;
	past=nil;
}

@end
