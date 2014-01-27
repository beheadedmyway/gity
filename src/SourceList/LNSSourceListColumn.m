
#import "LNSSourceListColumn.h"
#import "LNSSourceListCell.h"
#import "LNSSourceListSourceGroupCell.h"

@implementation LNSSourceListColumn

- (void) awakeFromNib {
	LNSSourceListCell* dataCell = [[LNSSourceListCell alloc] init];
	[dataCell setFont:[[self dataCell] font]];
	[dataCell setLineBreakMode:[[self dataCell] lineBreakMode]];
	[self setDataCell:dataCell];
}

- (id) dataCellForRow:(NSInteger) row {
	if(row >= 0) {
		GTSourceListItem * value = [(NSOutlineView *)[self tableView] itemAtRow:row];
		if([value isGroupItem]) {
			LNSSourceListSourceGroupCell * groupCell = [[LNSSourceListSourceGroupCell alloc] init];
			[groupCell setFont:[[self dataCell] font]];
			[groupCell setLineBreakMode:[[self dataCell] lineBreakMode]];
			return groupCell;
		}
	}
	return [self dataCell];
}

@end
