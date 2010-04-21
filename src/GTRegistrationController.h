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
#import "defs.h"
#import "CFobLicVerifier.h"
#import "GTBaseExternalNibController.h"
#import "GTSpecialTextField.h"
#import "GTStyles.h"
#import "GTOperationsController.h"
#import "GTMainMenuHelper.h"

#define kGTGityLicenseVersion 1
#define kGTGityProductCode @"mcndvrgity"
#define kGTGityLicenseDefaultsKey @"GTGityLicense"
#define kGTGityLicenseNameDefaultsKey @"GTGityLicenseName"

@interface GTRegistrationController : GTBaseExternalNibController <NSTextFieldDelegate> {
	BOOL isRunningWithValidLicense;
	IBOutlet GTSpecialTextField * name;
	IBOutlet GTSpecialTextField * license;
	IBOutlet NSTextField * invalidLicense;
	NSUserDefaults * defaults;
}
@property (readonly,nonatomic) BOOL isRunningWithValidLicense;

- (void) initModalAndDefaults;
- (void) checkLicenseInUserDefaults;
- (void) saveLicense;
- (BOOL) checkLicense;
- (BOOL) isLicenseValid:(NSString *) _license name:(NSString *) _name;

@end
