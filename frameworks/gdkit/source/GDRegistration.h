//copyright 2009 aaronsmith

#import <Cocoa/Cocoa.h>

/**
 * @file GDRegistration.h
 *
 * Header file for GDRegistration.
 */

/**
 * The default storage key for NSUserDefaults to store the name.
 */
#define kGDRegistrationNameKey @"GDRegistrationNameKey"

/**
 * The default storage key for NSUserDefaults to store the license.
 */
#define kGDRegistrationLicenseKey @"GDRegistrationLicenseKey"

/**
 * The key used to store whether or not a license has been sent home.
 */
#define kGDRegistrationHasSentHome @"GDRegistrationHasSentHome"

/**
 * The Info.plist key for the send home URL.
 */
#define kGDRegistrationHomeURLKey @"GDLicenseHomeURL"

/**
 * The GDRegistration helps with application registration.
 */
@interface GDRegistration : NSObject {
	
	NSString * homeURL;
	
	/**
	 * User defaults instance.
	 */
	NSUserDefaults * defaults;
	
	/**
	 * Blacklisted licenses.
	 */
	NSMutableArray * blacklist;
}

/**
 * A url that the license get's "sent home" to.
 *
 * The license is appended onto this url.
 */
@property (copy) NSString * homeURL;

/**
 * Sends a GET request to a URL.
 *
 * You need a key in your Info.plist file called "GDLicenseHomeURL" - the
 * license is appended onto that url.
 */
- (void) sendLicenseHome;

/**
 * Saves registration into user defaults.
 *
 * @param nameStorageKey The registrant name storage key.
 * @param licenseStorageKey The license storage key.
 * @param name The registrant name.
 * @param license The license.
 */
- (void) saveRegistrationIntoUserDefaults:(NSString *) nameStorageKey licenseStorageKey:(NSString *) licenseStorageKey name:(NSString *) name license:(NSString *) license;

/**
 * Saves registration information into user defaults using default storage keys.
 *
 * @param license The license key.
 * @param name The registrant name.
 */
- (void) saveRegistrationLicense:(NSString *) license forName:(NSString *) name;

/**
 * The license code.
 *
 * The license has to have been saved with the default license storage key.
 */
- (NSString *) getLicense;

/**
 * The registrant name.
 *
 * The name has to have been saved with the default name storage key.
 */
- (NSString *) getName;

/**
 * Whether or not a registration is valid.
 *
 * @param name The registrant name.
 * @param license The license.
 */
- (Boolean) isValidForName:(NSString *) name andLicense:(NSString *) license;

/**
 * Checks that the registered license is valid.
 *
 * A license has to already have been saved in user defaults.
 */
- (Boolean) isValid;

/**
 * Whether or not a saved registration exists in user defaults.
 */
- (Boolean) hasSavedRegistration;

/**
 * Check whether or not a license is blacklisted.
 *
 * @param license The license to check.
 */
- (Boolean) isLicenseBlacklisted:(NSString *) license;

/**
 * Whether or not the license that is saved in user defaults
 * is blacklisted.
 */
- (Boolean) isRegisteredLicenseBlacklisted;

/**
 * Add a license that's considered blacklisted.
 *
 * @param license The license to blacklist.
 */
- (void) addLicenseToBlacklist:(NSString *) license;

@end
