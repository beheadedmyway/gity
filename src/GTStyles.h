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

@interface GTStyles : NSObject {
}

+ (GTStyles *) sharedInstance;
+ (NSAttributedString *) getButtonString:(NSString *) title;
+ (NSAttributedString *) getDownButtonString:(NSString *) title;
+ (NSAttributedString *) getOverButtonString:(NSString *) title;
+ (NSAttributedString *) getCustomWindowTitleString:(NSString *) title;
+ (NSAttributedString *) getRoundStatusButtonText:(NSString *) title;
+ (NSAttributedString *) getRoundStatusButtonOverText:(NSString *) title;
+ (NSAttributedString *) getRoundStatusButtonDownText:(NSString *) title;
+ (NSAttributedString *) getGrayRoundStatusButtonText:(NSString *) title;
+ (NSAttributedString *) getGrayRoundStatusButtonOverText:(NSString *) title;
+ (NSAttributedString *) getGrayRoundStatusButtonDownText:(NSString *) title;
+ (NSAttributedString *) getRedStatusButtonText:(NSString *) title;
+ (NSAttributedString *) getRedStatusButtonOverText:(NSString *) title;
+ (NSAttributedString *) getRedStatusButtonDownText:(NSString *) title;
+ (NSAttributedString *) getLighterStringForInsetLabel:(NSString *) label;
+ (NSAttributedString *) getDarkerStringForInsetLabel:(NSString *) label;
+ (NSAttributedString *) getSelectorNormalLabel:(NSString *) label;
+ (NSAttributedString *) getSelectorOverLabel:(NSString *) label;
+ (NSAttributedString *) getSelectorDownLabel:(NSString *) label;
+ (NSAttributedString *) getFilteredSearchLabel:(NSString *) title;

@end
