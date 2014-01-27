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

#import "GTConfigView.h"
#import "GittyDocument.h"

@implementation GTConfigView

- (void) awakeFromNib {}

- (void) lazyInitWithGD:(GittyDocument *) _gd {
	[super lazyInitWithGD:_gd];
	rightView=[[gd splitContentView] rightView];
	[self updateTableHeaders];
}

- (void) updateTableHeaders {
	NSTableColumn * column = [tableView tableColumnWithIdentifier:@"key"];
	GTTableHeaderCell * thc = [[GTTableHeaderCell alloc] init];
	[thc setTitle:@"Key"];
	[column setHeaderCell:thc];
}

- (void) show {
	NSRect rvf=[rightView frame];
	NSRect nf=NSMakeRect(0,0,rvf.size.width,floor(rvf.size.height-28));
	[self setFrame:nf];
	[rightView addSubview:self];
}

- (void) hide {
	[super hide];
	[self releaseLastKeysValue];
}

- (BOOL) isOnGlobalConfig {
	return isGlobalConfig;
}

- (void) reload {
	if([self isOnGlobalConfig]) [operations runGetGlobalConfigs];
	else [operations runGetConfigs];
}

- (void) releaseLastKeysValue {
	GDRelease(lastKeysValue);
}

- (void) addItem {
	[configs addObject:[NSMutableArray arrayWithObjects:@"",@"",nil]];
	[tableView reloadData];
	NSIndexSet * indxs = [[NSIndexSet alloc] initWithIndex:[tableView numberOfRows]-1];
	[tableView selectRowIndexes:indxs byExtendingSelection:false];
	[tableView editColumn:0 row:[tableView numberOfRows]-1 withEvent:nil select:true];
}

- (void) removeItem {
	[tableView abortEditing];
	NSIndexSet * indxs = [tableView selectedRowIndexes];
	[tableView selectRowIndexes:indxs byExtendingSelection:false];
	if([indxs count] < 1) return;
	NSMutableArray * tmp = [[configs objectsAtIndexes:indxs] mutableCopy];
	[configs removeObjectsAtIndexes:indxs];
	NSMutableArray * itm;
	NSString * key;
	for(itm in tmp) {
		key=[itm objectAtIndex:0];
		[[gd operations] runUnsetConfigForKey:key isGlobal:isGlobalConfig];
	}
	[tableView reloadData];
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *) table {
	return [configs count];
}

- (id) tableView:(NSTableView *) table objectValueForTableColumn:(NSTableColumn *) column row:(NSInteger) index {
	if (index <= -1 || index >= [configs count])
		return nil;
	
	if([[column identifier] isEqual:@"key"]) return [(NSMutableArray*)[configs objectAtIndex:index] objectAtIndex:0];
	else return [(NSMutableArray*)[configs objectAtIndex:index] objectAtIndex:1];
	return nil;
}

- (void) tableView:(NSTableView *) table setObjectValue:(id) object forTableColumn:(NSTableColumn *) column row:(NSInteger) index {
	NSString * key = nil;
	NSString * value = nil;
	
	if(index >= [configs count]) {
		[configs addObject:[NSMutableArray arrayWithObjects:@"",@"",nil]];
		return;
	}

	NSMutableArray * a = (NSMutableArray *)[configs objectAtIndex:index];
	if([[column identifier] isEqual:@"key"]) {
		[a replaceObjectAtIndex:0 withObject:object];
		value=[a objectAtIndex:1];
		key=object;
	} else {
		[a replaceObjectAtIndex:1 withObject:object];
		key=[a objectAtIndex:0];
		value=object;
	}
	if([[column identifier] isEqual:@"key"]) {
		value=[a objectAtIndex:1];
	}
	if([[column identifier] isEqual:@"value"]) {
		if(![key isEqual:@""] and ![value isEqual:@""] and ![value isEqual:lastKeysValue]) {
			NSString *regex = @"^[a-zA-Z0-9_]+[\\.].*+";
			if([key isMatchedByRegex:regex]) 
				[operations runWriteConfigForKey:key andValue:value isGlobal:[self isOnGlobalConfig]];
			else 
				[modals runConfigNeedsSectionError];
		}
	}
	[self releaseLastKeysValue];
	lastKeysValue=[value copy];
}

- (void) updateWithGlobalConfig {
	isGlobalConfig = true;
	configs = [NSMutableArray arrayWithArray:[gitd globalConfigs]];
	if(!setTableDelegates) {
		[tableView setDelegate:self];
		[tableView setDataSource:self];
	}
	[tableView reloadData];
}

- (void) update {
	isGlobalConfig=false;
	configs=[NSMutableArray arrayWithArray:[gitd configs]];
	if(!setTableDelegates) {
		[tableView setDelegate:self];
		[tableView setDataSource:self];
	}
	[tableView reloadData];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTConfigView\n");
	#endif
	GDRelease(configs);
	[self releaseLastKeysValue];
	rightView=nil;
	isGlobalConfig=false;
	setTableDelegates=false;
}

@end
