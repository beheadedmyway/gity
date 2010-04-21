//copyright 2009 aaronsmith

#import "GDResponderHelper.h"

@implementation GDResponderHelper

+ (void) ifIsEscapeKey:(NSEvent *) event sendAction:(SEL) _action toTarget:(id) _target {
	if([event keyCode] == 53 and [_target respondsToSelector:_action]) [_target performSelector:_action];
}

@end
