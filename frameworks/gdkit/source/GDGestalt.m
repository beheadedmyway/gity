//copyright 2009 aaronsmith

#import "GDGestalt.h"

@implementation GDGestalt

+ (SInt32) gestaltSystemVersion {
	SInt32 res;
	Gestalt(gestaltSystemVersionMajor,&res);
	return res;
}

+ (SInt32) gestaltMinorVersion {
	SInt32 res;
	Gestalt(gestaltSystemVersionMinor,&res);
	return res;
}

@end
