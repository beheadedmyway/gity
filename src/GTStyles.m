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

#import "GTStyles.h"

static GTStyles * inst;

@implementation GTStyles

+ (instancetype) sharedInstance {
    static dispatch_once_t pred;
    static id inst = nil;
    dispatch_once(&pred, ^{
        inst = [[self alloc] init];
    });
    return inst;
}

+ (NSAttributedString *) getButtonString:(NSString *) title {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	NSColor * forg = [NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:.9];
	NSFont * font = [NSFont fontWithName:@"Lucida Grande" size:12];
	[d setObject:font forKey:NSFontAttributeName];
	[d setObject:forg forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString alloc] initWithString:title attributes:d] autorelease];
}

+ (NSAttributedString *) getDownButtonString:(NSString *) title {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	NSColor * forg = [NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:.5];
	NSFont * font = [NSFont fontWithName:@"Lucida Grande" size:12];
	[d setObject:font forKey:NSFontAttributeName];
	[d setObject:forg forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString alloc] initWithString:title attributes:d] autorelease];
}

+ (NSAttributedString *) getOverButtonString:(NSString *) title {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	NSColor * forg = [NSColor colorWithDeviceRed:.88 green:.88 blue:.88 alpha:.8];
	NSFont * font = [NSFont fontWithName:@"Lucida Grande" size:12];
	[d setObject:font forKey:NSFontAttributeName];
	[d setObject:forg forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString alloc] initWithString:title attributes:d] autorelease];
}

+ (NSAttributedString *) getCustomWindowTitleString:(NSString *) title {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	NSColor * forg = [NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:.7];
	NSFont * font = [NSFont fontWithName:@"Lucida Grande" size:9];
	[d setObject:font forKey:NSFontAttributeName];
	[d setObject:forg forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString alloc] initWithString:title attributes:d] autorelease];
}

+ (NSAttributedString *) getRoundStatusButtonText:(NSString *) title {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	NSColor * forg = [NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:.9];
	NSFont * font = [NSFont fontWithName:@"Lucida Grande" size:9];
	[d setObject:font forKey:NSFontAttributeName];
	[d setObject:forg forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString alloc] initWithString:title attributes:d] autorelease];
}

+ (NSAttributedString *) getRoundStatusButtonOverText:(NSString *) title {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	NSColor * forg = [NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:.78];
	NSFont * font = [NSFont fontWithName:@"Lucida Grande" size:9];
	[d setObject:font forKey:NSFontAttributeName];
	[d setObject:forg forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString alloc] initWithString:title attributes:d] autorelease];
}

+ (NSAttributedString *) getRoundStatusButtonDownText:(NSString *) title {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	NSColor * forg = [NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:.4];
	NSFont * font = [NSFont fontWithName:@"Lucida Grande" size:9];
	[d setObject:font forKey:NSFontAttributeName];
	[d setObject:forg forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString alloc] initWithString:title attributes:d] autorelease];
}

+ (NSAttributedString *) getGrayRoundStatusButtonText:(NSString *) title {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	NSColor * forg = [NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:.8];
	NSFont * font = [NSFont fontWithName:@"Lucida Grande" size:9];
	[d setObject:font forKey:NSFontAttributeName];
	[d setObject:forg forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString alloc] initWithString:title attributes:d] autorelease];
}

+ (NSAttributedString *) getGrayRoundStatusButtonOverText:(NSString *) title {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	NSColor * forg = [NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:.9];
	NSFont * font = [NSFont fontWithName:@"Lucida Grande" size:9];
	[d setObject:font forKey:NSFontAttributeName];
	[d setObject:forg forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString alloc] initWithString:title attributes:d] autorelease];
}

+ (NSAttributedString *) getGrayRoundStatusButtonDownText:(NSString *) title {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	NSColor * forg = [NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:.7];
	NSFont * font = [NSFont fontWithName:@"Lucida Grande" size:9];
	[d setObject:font forKey:NSFontAttributeName];
	[d setObject:forg forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString alloc] initWithString:title attributes:d] autorelease];
}

+ (NSAttributedString *) getRedStatusButtonText:(NSString *) title {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	NSColor * forg = [NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:.96];
	NSFont * font = [NSFont fontWithName:@"Lucida Grande" size:9];
	[d setObject:font forKey:NSFontAttributeName];
	[d setObject:forg forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString alloc] initWithString:title attributes:d] autorelease];
}

+ (NSAttributedString *) getRedStatusButtonOverText:(NSString *) title {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	NSColor * forg = [NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:.78];
	NSFont * font = [NSFont fontWithName:@"Lucida Grande" size:9];
	[d setObject:font forKey:NSFontAttributeName];
	[d setObject:forg forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString alloc] initWithString:title attributes:d] autorelease];
}

+ (NSAttributedString *) getRedStatusButtonDownText:(NSString *) title {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	NSColor * forg = [NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:.6];
	NSFont * font = [NSFont fontWithName:@"Lucida Grande" size:9];
	[d setObject:font forKey:NSFontAttributeName];
	[d setObject:forg forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString alloc] initWithString:title attributes:d] autorelease];
}

+ (NSAttributedString *) getDarkerStringForInsetLabel:(NSString *) label {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	NSColor * forg = [NSColor colorWithDeviceRed:.2 green:.2 blue:.2 alpha:1];
	NSFont * font = [NSFont fontWithName:@"Lucida Grande" size:9];
	[d setObject:font forKey:NSFontAttributeName];
	[d setObject:forg forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString alloc] initWithString:label attributes:d] autorelease];
}

+ (NSAttributedString *) getLighterStringForInsetLabel:(NSString *) label {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	NSColor * forg = [NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:.35];
	NSFont * font = [NSFont fontWithName:@"Lucida Grande" size:9];
	[d setObject:font forKey:NSFontAttributeName];
	[d setObject:forg forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString alloc] initWithString:label attributes:d] autorelease];
}

+ (NSAttributedString *) getSelectorNormalLabel:(NSString *) label {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	NSColor * forg = [NSColor colorWithDeviceRed:.98 green:.98 blue:.98 alpha:1];
	NSFont * font = [NSFont fontWithName:@"Lucida Grande" size:9];
	[d setObject:font forKey:NSFontAttributeName];
	[d setObject:forg forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString alloc] initWithString:label attributes:d] autorelease];
}

+ (NSAttributedString *) getSelectorOverLabel:(NSString *) label {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	NSColor * forg = [NSColor colorWithDeviceRed:.93 green:.93 blue:.93 alpha:1];
	NSFont * font = [NSFont fontWithName:@"Lucida Grande" size:9];
	[d setObject:font forKey:NSFontAttributeName];
	[d setObject:forg forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString alloc] initWithString:label attributes:d] autorelease];
}

+ (NSAttributedString *) getSelectorDownLabel:(NSString *) label {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	NSColor * forg = [NSColor colorWithDeviceRed:.9 green:.9 blue:.9 alpha:1];
	NSFont * font = [NSFont fontWithName:@"Lucida Grande" size:9];
	[d setObject:font forKey:NSFontAttributeName];
	[d setObject:forg forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString alloc] initWithString:label attributes:d] autorelease];
}

+ (NSAttributedString *) getFilteredSearchLabel:(NSString *) title {
	NSMutableDictionary * d = [NSMutableDictionary dictionary];
	NSColor * forg = [NSColor colorWithDeviceRed:.16 green:.16 blue:.16 alpha:1];
	//NSColor * forg = [NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:1];
	NSFont * font = [NSFont fontWithName:@"Lucida Grande" size:10];
	[d setObject:font forKey:NSFontAttributeName];
	[d setObject:forg forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString alloc] initWithString:title attributes:d] autorelease];
}

+ (id)allocWithZone:(NSZone *) zone {
    @synchronized(self) {
		if (inst == nil) {
			inst = [super allocWithZone:zone];
			return inst;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *) zone {
	return self;
}

@end
