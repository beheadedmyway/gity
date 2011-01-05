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

#import "GTActiveBranchTableView.h"
#import "GittyDocument.h"

@implementation GTActiveBranchTableView

- (void) keyDown:(NSEvent *) event {
	//NSLog(@"%i",[event keyCode]);
	GTActiveBranchView * abv = (GTActiveBranchView *)[self delegate];
	GittyDocument * gd = [abv gd];
	NSIndexSet * selectedRows = [self selectedRowIndexes];
	switch ([event keyCode]) {
		case 18:
			if([selectedRows containsIndex:0]) [self deselectRow:0];
			else [self selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:true];
			return;
			break;
		case 19:
			if([selectedRows containsIndex:1]) [self deselectRow:1];
			else [self selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:true];
			return;
			break;
		case 20:
			if([selectedRows containsIndex:2]) [self deselectRow:2];
			else [self selectRowIndexes:[NSIndexSet indexSetWithIndex:2] byExtendingSelection:true];
			return;
			break;
		case 21:
			if([selectedRows containsIndex:3]) [self deselectRow:3];
			else [self selectRowIndexes:[NSIndexSet indexSetWithIndex:3] byExtendingSelection:true];
			return;
			break;
		case 23:
			if([selectedRows containsIndex:4]) [self deselectRow:4];
			else [self selectRowIndexes:[NSIndexSet indexSetWithIndex:4] byExtendingSelection:true];
			return;
			break;
		case 22:
			if([selectedRows containsIndex:5]) [self deselectRow:5];
			else [self selectRowIndexes:[NSIndexSet indexSetWithIndex:5] byExtendingSelection:true];
			return;
			break;
		case 26:
			if([selectedRows containsIndex:6]) [self deselectRow:6];
			else [self selectRowIndexes:[NSIndexSet indexSetWithIndex:6] byExtendingSelection:true];
			return;
			break;
		case 28:
			if([selectedRows containsIndex:7]) [self deselectRow:7];
			else [self selectRowIndexes:[NSIndexSet indexSetWithIndex:7] byExtendingSelection:true];
			return;
			break;
		case 25:
			if([selectedRows containsIndex:8]) [self deselectRow:8];
			else [self selectRowIndexes:[NSIndexSet indexSetWithIndex:8] byExtendingSelection:true];
			return;
			break;
		case 29:
			if([selectedRows containsIndex:9]) [self deselectRow:9];
			else [self selectRowIndexes:[NSIndexSet indexSetWithIndex:9] byExtendingSelection:true];
			return;
			break;
		case 49:
			// handle quicklook
			[gd quickLook:self];
			break;
		case 51:
			if([[self selectedRowIndexes] count] > 0) {
				[[self delegate] performSelector:@selector(deleteAtRow)];
				return;
			}
			break;
		default:
			break;
	}
	if([GTResponderHelper isEscapeKey:event]) {
		if([GTResponderHelper respondsToEscapeKey:[self delegate]]) {
			[GTResponderHelper tryEscapeKeyWithEvent:event onObject:[self delegate]];
		}
	} else if(([event modifierFlags] & NSAlternateKeyMask) && [event keyCode] == 0) [gd gitAdd:nil];
	else if(([event modifierFlags] & NSAlternateKeyMask) && [event keyCode] == 2) [gd gitDestage:nil];
	//else if(([event modifierFlags] & NSAlternateKeyMask) && [event keyCode] == 14) [gd gitDiscardChanges:nil];
	else if(([event modifierFlags] & NSAlternateKeyMask) && [event keyCode] == 5) [gd gitDiscardChanges:nil];
	else if(([event modifierFlags] & NSAlternateKeyMask) && [event keyCode] == 3) [gd resolveConflictsWithFileMerge:nil];
	else if(([event modifierFlags] & NSAlternateKeyMask) && [event keyCode] == 15) [gd gitRemove:nil];
	else if(([event modifierFlags] & NSAlternateKeyMask) && [event keyCode] == 8) [gd gitCommit:nil];
	else [super keyDown:event];
}

@end
