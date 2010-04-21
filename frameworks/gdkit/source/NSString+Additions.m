
#import "NSString+Additions.h"

@implementation NSString (GDAdditions)

- (const char *) cstring {
	return [self UTF8String];
}

- (BOOL) isEmpty {
	return [self isEqual:@""];
}

- (BOOL) containsSpace {
	NSRange s = [self rangeOfString:@" "];
	if(!(s.location==NSNotFound)) return true;
	return false;
}

- (BOOL) isEmptyOrContainsSpace {
	if([self isEmpty]) return true;
	if([self containsSpace]) return true;
	return false;
}

@end
