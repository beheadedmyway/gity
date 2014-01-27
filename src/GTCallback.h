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

#import <Cocoa/Cocoa.h>
#import <GDKit/GDKit.h>
#import "defs.h"

@interface GTCallback : NSObject {
	id target;
	SEL action;
	NSArray * args;
	NSInvocation * invoker;
	NSMethodSignature * signature;
}

@property (strong,nonatomic) NSArray * args;
@property (strong,nonatomic) id target;
@property (assign,nonatomic) SEL action;

- (void) execute;
- (void) executeOnMainThread;
- (void) getReturnValue:(void *) _resultAddress;
- (void) setupInvoker;
- (id) initWithTarget:(id) _target andAction:(SEL) _action;
- (id) initWithTarget:(id) _target andAction:(SEL) _action andArgs:(NSArray *) _args;

@end
