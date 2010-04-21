
#import "GDCrashReporter.h"

@implementation GDCrashReporter
@synthesize companyName;
@synthesize crashMessage;
@synthesize delegate;
@synthesize deleteCrashReport;
@synthesize hasCrash;
@synthesize pythonBinLocation;
@synthesize pythonSendFileScriptLocation;
@synthesize userDefaultsPrefix;
@synthesize windowTitle;

- (void) awakeFromNib {
	[self initUI];
}

- (id) initWithUserDefaultsPrefix:(NSString *) _prefix {
	self=[super init];
	hasCrash=false;
	deleteCrashReport=false;
	[self setPythonBinLocation:@"/usr/bin/python"];
	[self initSearchPaths];
	[self setUserDefaultsPrefix:_prefix];
	return self;
}

- (void) forceCrash {
	signal(SIGBUS,SIG_DFL);
	//*(long*)0 = 0xDEADBEEF;
	abort();
}

- (NSString *) applicationName {
	NSString * app = [[[NSBundle mainBundle] localizedInfoDictionary] valueForKey: @"CFBundleExecutable"];
	if (!app) app = [[[NSBundle mainBundle] infoDictionary] valueForKey: @"CFBundleExecutable"];
	return app;
}

- (void) initUI {
	GDRelease(placeHolderComm);
	placeHolderComm = [[[comments textStorage] string] copy];
	[window setFrameAutosaveName:[userDefaultsPrefix stringByAppendingString:@"_GDCrashReporterWindow"]];
	[comments setTextContainerInset:NSMakeSize(0,4)];
	[details setTextContainerInset:NSMakeSize(0,4)];
	if(!windowTitle) [self setWindowTitle:[NSString stringWithFormat:@"%@ Crashed",[self applicationName]]];
	if(windowTitle)[window setTitle:windowTitle];
	NSString * msg = nil;
	if(!crashMessage) {
		if(companyName) msg = [NSString stringWithFormat:@"%@ crashed the last time it was running. Do you want to report this to %@?",[self applicationName],companyName];
		else msg = [NSString stringWithFormat:@"%@ crashed the last time it was running. Do you want to report this?",[self applicationName]];
		[self setCrashMessage:msg];
	}
	if(crashMessage)[message setStringValue:crashMessage];
	[send setTarget:self];
	[send setAction:@selector(onsend:)];
	[cancel setTarget:self];
	[cancel setAction:@selector(oncancel:)];
	[comments setFont:[NSFont fontWithName:@"Lucida Grande" size:11]];
}

- (void) initSearchPaths {
	searchPaths=[[NSMutableArray alloc] init];
	[searchPaths addObject:[@"~/Library/Logs/CrashReporter/" stringByExpandingTildeInPath]];
	[searchPaths addObject:[@"~/Library/Logs/DiagnosticReports/" stringByExpandingTildeInPath]];
	[searchPaths addObject:@"/Library/Logs/CrashReporter/"];
	[searchPaths addObject:@"/Library/Logs/DiagnosticReports/"];
}

- (void) searchForCrashReports {
	NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
	NSFileManager * fman = [NSFileManager defaultManager];
	NSString * udkey = [userDefaultsPrefix stringByAppendingString:@"_GDCrashReporter"];
	NSTimeInterval lastCrashTI = [def doubleForKey:udkey];
	NSMutableArray * allFiles = [[NSMutableArray alloc] init];
	NSString * app = [self applicationName];
	NSString * file, * path, * fullPath;
	NSArray * files;
	NSDate * modDate, * nextCrash;
	NSDictionary * attributes;
	for(path in searchPaths) {
		files = [fman contentsOfDirectoryAtPath:path error:nil];
		if(files and [files count]>0) {
			for(file in files) {
				if([file hasPrefix:app]) {
					fullPath = [path stringByAppendingPathComponent:file];
					attributes = [fman attributesOfItemAtPath:fullPath error:nil];
					if(!attributes) continue;
					modDate = [attributes valueForKey:NSFileModificationDate];
					[allFiles addObject:[NSDictionary dictionaryWithObjectsAndKeys:fullPath,@"path",modDate,@"modDate",nil]];
				}
			}
		}
	}
	if([allFiles count] < 1) {
		hasCrash=false;
		[allFiles release];
		return;
	}
	NSSortDescriptor * dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"modDate" ascending:true];
	NSArray * sortedFiles = [allFiles sortedArrayUsingDescriptors:[NSArray arrayWithObject:dateSortDescriptor]];
	GDRelease(crashFile);
	crashFile = [[[sortedFiles lastObject] objectForKey:@"path"] copy];
	nextCrash = [[sortedFiles lastObject] objectForKey:@"modDate"];
	NSTimeInterval nextCrashTI = [nextCrash timeIntervalSince1970];
	if(nextCrashTI > lastCrashTI) {
		hasCrash = true;
		[def setDouble:nextCrashTI forKey:udkey];
	}
	else hasCrash = false;
	[dateSortDescriptor release];
	[allFiles release];
}

- (void) show {
	[NSBundle loadNibNamed:@"CrashReport" owner:self];
	NSFileHandle * fh = [NSFileHandle fileHandleForReadingAtPath:crashFile];
	NSData * data = [fh readDataToEndOfFile];
	NSString * crashContent = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	[[[details textStorage] mutableString] appendString:crashContent];
	[crashContent release];
	[window makeKeyAndOrderFront:nil];
	[details setFont:[NSFont fontWithName:@"Lucida Grande" size:11]];
	[window makeFirstResponder:send];
}

- (void) performCrashReporterDidFinishOnDelegate {
	if(delegate and [delegate respondsToSelector:@selector(crashReporterDidFinish:)]) {
		[delegate performSelector:@selector(crashReporterDidFinish:) withObject:self];
	}
}

- (void) performCrashReporterDidSendOnDelegate {
	if(delegate and [delegate respondsToSelector:@selector(crashReporterDidSend:)]) {
		[delegate performSelector:@selector(crashReporterDidSend:) withObject:self];
	}
}

- (void) performCrashReporterDidCancelOnDelegate {
	if(delegate and [delegate respondsToSelector:@selector(crashReporterDidCancel:)]) {
		[delegate performSelector:@selector(crashReporterDidCancel:) withObject:self];
	}
}

- (void) addCrashSearchPath:(NSString *) _searchPath {
	if(!_searchPath) return;
	NSString * c = [_searchPath copy];
	[searchPaths addObject:c];
	[c release];
}

- (void) _deleteCrashReport {
	NSFileManager * fm = [NSFileManager defaultManager];
	[fm removeItemAtPath:crashFile error:nil];
}

- (IBAction) onsend:(id) sender {
	[window orderOut:nil];
	NSString * pyc;
	NSBundle * mb = [NSBundle bundleForClass:[self class]];
	if(task and [task isRunning]) [task terminate];
	GDRelease(task);
	task = [[NSTask alloc] init];
	NSMutableArray * args = [[NSMutableArray alloc] init];
	NSString * comms = [[comments textStorage] string];
	[task setLaunchPath:pythonBinLocation];
	pyc=[mb pathForResource:@"sendcrashreport" ofType:@"pyc"];
	if(!pyc)pyc=[mb pathForResource:@"sendcrashreport" ofType:@"pyc" inDirectory:@"Python"];
	if(!pyc)pyc=[mb pathForResource:@"sendcrashreport" ofType:@"pyc" inDirectory:@"Scripts"];
	[args addObject:pyc];
	[args addObject:[@"-f " stringByAppendingString:crashFile]];
	if([comms length] > 0 && ![comms isEqual:placeHolderComm]) {
		NSString * tmpFileName = [NSFileHandle tmpFileName];
		NSFileHandle * tmp = [NSFileHandle tmpFile:tmpFileName];
		NSData * cdata = [comms dataUsingEncoding:NSUTF8StringEncoding];
		[tmp writeData:cdata];
		[args addObject:[@"-c " stringByAppendingString:tmpFileName]];
	}
	[task setArguments:args];
	[args release];
	[self performSelectorInBackground:@selector(launchTask) withObject:nil];
	[self performCrashReporterDidSendOnDelegate];
}

- (void) taskComplete {
	if([self deleteCrashReport]) [self _deleteCrashReport];
	[self performCrashReporterDidFinishOnDelegate];
}

- (void) launchTask {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	[task launch];
	[task waitUntilExit];
	[pool drain];
	[self performSelectorOnMainThread:@selector(taskComplete) withObject:nil waitUntilDone:false];
}

- (IBAction) oncancel:(id) sender {
	if([self deleteCrashReport]) [self _deleteCrashReport];
	[window orderOut:nil];
	[self performCrashReporterDidCancelOnDelegate];
	[self performCrashReporterDidFinishOnDelegate];
}

- (void) dealloc {
	#ifdef GDKIT_PRINT_DEALLOCS
	printf("dealloc GDCrashReporter\n");
	#endif
	hasCrash=false;
	GDRelease(placeHolderComm);
	if(task and [task isRunning]) [task terminate];
	GDRelease(task);
	GDRelease(searchPaths);
	GDRelease(userDefaultsPrefix);
	GDRelease(pythonBinLocation);
	GDRelease(pythonSendFileScriptLocation);
	GDRelease(delegate);
	GDRelease(crashFile);
	GDRelease(windowTitle);
	GDRelease(crashMessage);
	[super dealloc];
}

@end
