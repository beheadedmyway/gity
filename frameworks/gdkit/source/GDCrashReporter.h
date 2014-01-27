
#import <Cocoa/Cocoa.h>
#import "macros.h"
#import "GDCrashReporterDelegate.h"
#import "NSFileHandle+Additions.h"

/**
 * @file GDCrashReporter.h
 * 
 * Header file for GDCrashReporter.
 */

/**
 * The GDCrashReporter is a controller that implements post-trauma-pre-usage
 * crash reporting.
 */
@interface GDCrashReporter : NSObject {
	BOOL hasCrash;
	BOOL deleteCrashReport;
	id <GDCrashReporterDelegate> delegate;
	NSString * placeHolderComm;
	NSString * crashFile;
	NSString * pythonBinLocation;
	NSString * pythonSendFileScriptLocation;
	NSString * userDefaultsPrefix;
	NSString * windowTitle;
	NSString * crashMessage;
	NSString * companyName;
	NSTask * task;
	NSMutableArray * searchPaths;
	IBOutlet NSWindow * window;
	IBOutlet NSButton * send;
	IBOutlet NSButton * cancel;
	IBOutlet NSTextView * comments;
	IBOutlet NSTextView * details;
	IBOutlet NSTextField * message;
}

/**
 * The delegate for this crash reporter.
 */
@property (strong,nonatomic) id delegate;

/**
 * A user defaults key prefix. This is used when saving the last
 * crash found so that it's only reported once.
 */
@property (copy,nonatomic) NSString * userDefaultsPrefix;

/**
 * The python binary location (default is /usr/bin/python).
 */
@property (copy,nonatomic) NSString * pythonBinLocation;

/**
 * The python sendcrashreport.pyc file location. Default is
 * taken from getting a resource path from NSBundle.
 */
@property (copy,nonatomic) NSString * pythonSendFileScriptLocation;

/**
 * Whether or not a crash report is available.
 */
@property (readonly,nonatomic) BOOL hasCrash;

/**
 * The window title to use for the nib.
 */
@property (copy,nonatomic) NSString * windowTitle;

/**
 * The crash message to display in the window.
 */
@property (copy,nonatomic) NSString * crashMessage;

/**
 * The company name to display (if crashMessage is not used).
 */
@property (copy,nonatomic) NSString * companyName;

/**
 * Whether or not the crash report should be deleted after it's reported.
 */
@property (assign,nonatomic) BOOL deleteCrashReport;

/**
 * [Designated initializer] Inititlize this crash reporter with
 * a user defaults prefix.
 */
- (id) initWithUserDefaultsPrefix:(NSString *) _prefix;

/**
 * [internal] The application name.
 */
- (NSString *) applicationName;

/**
 * Add a crash report (core dump) file search path.
 */
- (void) addCrashSearchPath:(NSString *) _searchPath;

/**
 * IBAction for a cancel button.
 */
- (IBAction) oncancel:(id) sender;

/**
 * Force crash any app that is using this crash reporter (for testing).
 */
- (void) forceCrash;

/**
 * [internal] Initializes default search paths.
 */
- (void) initSearchPaths;

/**
 * [internal] Initializes UI components from the nib.
 */
- (void) initUI;

/**
 * [internal];
 */
- (void) performCrashReporterDidFinishOnDelegate;

/**
 * [internal];
 */
- (void) performCrashReporterDidSendOnDelegate;

/**
 * [internal];
 */
- (void) performCrashReporterDidCancelOnDelegate;

/**
 * IBAction for a send button.
 */
- (IBAction) onsend:(id) sender;

/**
 * [internal] Searches for crash reports and finds the latest one.
 */
- (void) searchForCrashReports;

/**
 * [internal] Used to delete a crash report.
 */
- (void) _deleteCrashReport;

/**
 * Shows the crash report nib.
 */
- (void) show;


@end
