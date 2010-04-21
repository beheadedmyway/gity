//copyright 2009 aaronsmith

#import "GDRegistration.h"

@implementation GDRegistration
@synthesize homeURL;

- (id) init {
	if(self = [super init]) {
		defaults = [NSUserDefaults standardUserDefaults];
		blacklist = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) sendLicenseHome {
	if(![self homeURL]) return;
	if(![self hasSavedRegistration]) return;
	if([defaults boolForKey:kGDRegistrationHasSentHome]) return;
	NSString * url = [self homeURL];
	NSString * s = [url stringByAppendingString:[self getLicense]];
	NSURL * u = [NSURL URLWithString:s];
	NSURLRequest * home = [NSURLRequest requestWithURL:u];
	NSURLConnection * con = [[NSURLConnection alloc] initWithRequest:home delegate:NULL];
	[defaults setBool:TRUE forKey:kGDRegistrationHasSentHome];
	[con release];
}

- (void) saveRegistrationIntoUserDefaults:(NSString *) nameStorageKey licenseStorageKey:(NSString *) licenseStorageKey name:(NSString *) name license:(NSString *) license {
	[defaults setObject:name forKey:nameStorageKey];
	[defaults setObject:license forKey:licenseStorageKey];
	[defaults setBool:FALSE forKey:kGDRegistrationHasSentHome];
}

- (void) saveRegistrationLicense:(NSString *) license forName:(NSString *) name {
	[defaults setObject:name forKey:kGDRegistrationNameKey];
	[defaults setObject:license forKey:kGDRegistrationLicenseKey];
	[defaults setBool:FALSE forKey:kGDRegistrationHasSentHome];
}

- (void) addLicenseToBlacklist:(NSString *) license {
	if(license == nil) return;
	[blacklist addObject:license];
}

- (Boolean) isValidForName:(NSString *) name andLicense:(NSString *) license {
	if([self isLicenseBlacklisted:license]) return FALSE;
	return TRUE;
}

- (Boolean) isValid {
	return [self isValidForName:[defaults objectForKey:kGDRegistrationNameKey] andLicense:[defaults objectForKey:kGDRegistrationLicenseKey]];
}

- (Boolean) hasSavedRegistration {
	NSString * name = [defaults objectForKey:kGDRegistrationNameKey];
	NSString * key = [defaults objectForKey:kGDRegistrationLicenseKey];
	if(name != nil && key != nil) return TRUE;
	return FALSE;
}

- (Boolean) isLicenseBlacklisted:(NSString *) license {
	return [blacklist containsObject:license];
}

- (Boolean) isRegisteredLicenseBlacklisted {
	Boolean retval = [self isLicenseBlacklisted:[defaults objectForKey:kGDRegistrationLicenseKey]];
	if(retval) [defaults setBool:FALSE forKey:kGDRegistrationHasSentHome];
	return retval;
}

- (NSString *) getName {
	return [defaults objectForKey:kGDRegistrationNameKey];
}

- (NSString *) getLicense {
	return [defaults objectForKey:kGDRegistrationLicenseKey];
}

- (void) dealloc {
	[blacklist release];
	[super dealloc];
}

@end
