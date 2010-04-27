//copyright aaronsmith 2009

#import <Cocoa/Cocoa.h>

/**
 * @file GDAppExpiration.h
 *
 * Header file for GDAppExpiration.
 */

#ifdef GDAppBetaExpires
#	ifndef GDAppBetaExpiresAfter
#		define GDAppBetaExpiresAfter 45 //days
#	endif
#endif

/**
 * The default maximum application launch count.
 */
#define GDAppExpiresAfterLaunches 15

/**
 * The GDAppExpiration is a utility that
 * can manage app expirations for a couple situations.
 *
 * It manages a few situations - first when the app
 * is in Beta, and it needs to expire a certain amount
 * of days after the application was compiled - like 45
 * days or something. This is a hard compiled in date in
 * the app.
 *
 * Another option - keep track of when an application expires
 * on the client machine, after a thresh-hold like 15 days.
 *
 * And the last option - keep track of the number of times an
 * application has launched, and whether or not it exceeds a
 * thresh-hold.
 * 
 * <b>Macros:</b><br/>
 * <em>GDAppBetaExpires</em> - Define this to indicate the a expiration date
 * should be compiled in for "Beta" expirations.<br/>
 * <em>GDAppBetaExpiresAfter</em> - The number of days before the beta app
 * expires - the default is 45.
 * <em>GDAppExpiresAfterLaunches</em> - The maximum number of application launches
 * before the app is considered expired - the default is 15.
 */
@interface GDAppExpiration : NSObject {
	short launchCount;
	short maxLaunches;
	short runsForDays;
}

/**
 * The number of times the application has launched.
 */
@property (assign) short launchCount;

/**
 * The maximum number of application launches.
 */
@property (assign) short maxLaunches;

/**
 * How many days the app should run for.
 */
@property (assign) short runsForDays;

/**
 * Whether or not the application has been launched
 * more then the maximum allowed times.
 */
- (Boolean) hasExceededMaxLaunches;

/**
 * Whether or not a Beta app has expired.
 */
+ (Boolean) isBetaExpired;

/**
 * Whether or not the client has expired after a
 * certain number of days.
 */
- (Boolean) hasClientExpired;

/**
 * Increments the launch count.
 */
- (void) applicationLaunched;

@end
