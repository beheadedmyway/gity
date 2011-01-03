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

#import "GTRegistrationController.h"

@implementation GTRegistrationController
@synthesize isRunningWithValidLicense;

- (void) awakeFromNib {
	[super awakeFromNib];
	[name setDelegate:self];
	[license setDelegate:self];
	[invalidLicense retain];
	[invalidLicense removeFromSuperview];
	[self initModalAndDefaults];
}

- (void) show {
	[super show];
	[name becomeFirstResponder];
}

- (void) initModalAndDefaults {
	if(defaults is nil) defaults=[NSUserDefaults standardUserDefaults];
	if(modals is nil) modals = [GTModalController sharedInstance];
}

- (void) initButtons {
	NSPoint tl = [self getTL];
	NSPoint tr = [self getTR];
	ok=[[GTScale9Control alloc] initWithFrame:NSMakeRect(292,20,62,27)];
	NSAssert(ok!=nil,@"Assert Fail: ok!=nil, ok was indeed nil");
	[ok sendsActionOnMouseUp:true];
	[ok setScaledImage:[NSImage imageNamed:@"blackButton2.png"]];
	[ok setScaledOverImage:[NSImage imageNamed:@"blackButton2Over.png"]];
	[ok setScaledDownImage:[NSImage imageNamed:@"blackButton2Down.png"]];
	[ok setTopLeftPoint:tl];
	[ok setBottomRightPoint:tr];
	[ok setAttributedTitle:[GTStyles getButtonString:@"OK"]];
	[ok setAttributedTitleDown:[GTStyles getDownButtonString:@"OK"]];
	[ok setAttributedTitlePosition:NSMakePoint(22,6)];
	[ok setAction:@selector(onok:)];
	[ok setTarget:self];
	[[window contentView] addSubview:ok];
	
	cancel=[[GTScale9Control alloc] initWithFrame:NSMakeRect(227,20,62,27)];
	NSAssert(cancel!=nil,@"Assert Fail: cancel!=nil, cancel was indeed nil");
	[cancel sendsActionOnMouseUp:true];
	[cancel setScaledImage:[NSImage imageNamed:@"blackButton2.png"]];
	[cancel setScaledOverImage:[NSImage imageNamed:@"blackButton2Over.png"]];
	[cancel setScaledDownImage:[NSImage imageNamed:@"blackButton2Down.png"]];
	[cancel setTopLeftPoint:tl];
	[cancel setBottomRightPoint:tr];
	[cancel setAttributedTitle:[GTStyles getButtonString:@"Cancel"]];
	[cancel setAttributedTitleDown:[GTStyles getDownButtonString:@"Cancel"]];
	[cancel setAttributedTitlePosition:NSMakePoint(12,6)];
	[cancel setAction:@selector(cancel:)];
	[cancel setTarget:self];
	[[window contentView] addSubview:cancel];
}

- (void) onok:(id) sender {
	[self initModalAndDefaults];
	[invalidLicense removeFromSuperview];
	if([self checkLicense]) {
		isRunningWithValidLicense=true;
		[self saveLicense];
	} else {
		isRunningWithValidLicense=false;
		[[window contentView] addSubview:invalidLicense];
		NSBeep();
	}
	[GTOperationsController updateLicenseRunStatus:isRunningWithValidLicense];
}

- (BOOL) checkLicense {
	[self initModalAndDefaults];
	NSString * nameValue = [name stringValue];
	NSString * licenseValue = [license stringValue];
	NSString * fullNameValue = [nameValue stringByAppendingFormat:@" %i",kGTGityLicenseVersion];
	return [self isLicenseValid:licenseValue name:fullNameValue];
}

- (void) checkLicenseInUserDefaults {
	[self initModalAndDefaults];
	#ifdef kGTGityNoLicenseRequired
	[GTMainMenuHelper disableRegistrationItem];
	#endif
	NSString * nameValue = [defaults valueForKey:kGTGityLicenseNameDefaultsKey];
	NSString * licenseValue = [defaults valueForKey:kGTGityLicenseDefaultsKey];
	if(nameValue is nil or licenseValue is nil) {
		isRunningWithValidLicense=false;
		[GTOperationsController updateLicenseRunStatus:isRunningWithValidLicense];
		return;
	}
	NSString * fullNameValue = [nameValue stringByAppendingFormat:@" %i",kGTGityLicenseVersion];
	if(![self isLicenseValid:licenseValue name:fullNameValue]) {
		isRunningWithValidLicense=false;
		[defaults removeObjectForKey:kGTGityLicenseNameDefaultsKey];
		[defaults removeObjectForKey:kGTGityLicenseDefaultsKey];
		[modals runSavedLicenseInvalid];
		[GTOperationsController updateLicenseRunStatus:isRunningWithValidLicense];
	} else {
		isRunningWithValidLicense=true;
		[GTMainMenuHelper updateRegistrationItem:isRunningWithValidLicense];
		[GTOperationsController updateLicenseRunStatus:isRunningWithValidLicense];
	}
}

- (BOOL) isLicenseValid:(NSString *) _license name:(NSString *) _name {
	NSString * regName = [NSString stringWithFormat:@"%@,%@",kGTGityProductCode,_name];
	NSMutableString *pkb64 = [NSMutableString string];
	[pkb64 appendString:@"MIHwMIGoBgcqhkjOOAQBMIGcAkEAqOgu"];
	[pkb64 appendString:@"Bpfe1ExLkkQDomLA7Egy/k"];
	[pkb64 appendString:@"DA2bDjN/Ho\nFtpychn4PshiM"];
	[pkb64 appendString:@"0qPOEbMJtBfunOtg8"];
	[pkb64 appendString:@"5Ovz4pW4QpD9QUMMD8CQIVAOXuYZy9h1f"];
	[pkb64 appendString:@"I\nrp9kJXguL5aLVRwDAkBasPNux2S1Sfk6l1PVgEFiQ"];
	[pkb64 appendString:@"F9BA9GM7cBOSbIHWQgwtbLu\nFpLSpHSb7OL+"];
	[pkb64 appendString:@"W4l0HYSpiv7V+mQe06hl"];
	[pkb64 appendString:@"PdgppF6eA0MA"];
	[pkb64 appendString:@"AkBwd5YSyAish1RSNbEj\nqdslAp0lGZOQ3"];
	[pkb64 appendString:@"WHyBXTJsiqHcXcxBPgohTJ8/m8xK"];
	[pkb64 appendString:@"lSysF7jBXhF/pxKpUNMbtSd\nmUUa\n"];
	NSString * publicKey = [NSString stringWithString:pkb64];
	publicKey = [CFobLicVerifier completePublicKeyPEM:publicKey];
	CFobLicVerifier * verifier = [CFobLicVerifier verifierWithPublicKey:publicKey];
	verifier.regName = regName;
	verifier.regCode = _license;
	if ([verifier verify]) return true;
	return false;
}

- (void) saveLicense {
	[self initModalAndDefaults];
	[defaults setObject:[name stringValue] forKey:kGTGityLicenseNameDefaultsKey];
	[defaults setObject:[license stringValue] forKey:kGTGityLicenseDefaultsKey];
	isRunningWithValidLicense=true;
	[GTOperationsController updateLicenseRunStatus:isRunningWithValidLicense];
	[GTMainMenuHelper updateRegistrationItem:isRunningWithValidLicense];
	[self cancel:nil];
}

- (void) loadNibs {
	if(available) return;
	if(window == nil) [NSBundle loadNibNamed:@"Registration" owner:self];
	available = true;
}

@end
