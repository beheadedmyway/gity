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

#import "GTNotificationsHelper.h"

@implementation GTNotificationsHelper

+ (NSNotification *) notificationForName:(NSString *) _notification {
	return [NSNotification notificationWithName:_notification object:nil];
}

+ (NSNotification *) notificationForName:(NSString *) _notification andObject:(id) _object {
	return [NSNotification notificationWithName:_notification object:_object];
}

@end
