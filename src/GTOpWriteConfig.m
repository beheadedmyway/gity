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

#import "GTOpWriteConfig.h"

@implementation GTOpWriteConfig

- (id) initWithGD:(GittyDocument *)_gd andKey:(NSString *) _key andValue:(NSString *) _value isGlobal:(BOOL) _global {
	key = [_key copy];
	value = [_value copy];
	isGlobal = _global;
	self=[super initWithGD:_gd];
	return self;
}

- (void) setArguments {
	if([self isCancelled]) return;
	[self setArgumentsWithPythonScript:[GTPythonScripts writeConfig] setArgsOnTask:false];
	[args addObject:[@"-m " stringByAppendingString:key]];
	[args addObject:[@"-m " stringByAppendingString:value]];
	if(isGlobal) [args addObject:[@"-m " stringByAppendingFormat:@"%i",1]];
	[self updateArguments];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTOpWriteConfig\n");
	#endif
	GDRelease(key);
	GDRelease(value);
	isGlobal=false;
	[super dealloc];
}

@end
