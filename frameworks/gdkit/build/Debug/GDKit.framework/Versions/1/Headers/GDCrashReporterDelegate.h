
#import <Cocoa/Cocoa.h>

@interface NSObject (GDCrashReporterOptionalDelegate)

- (void) crashReporterDidCancel:(id) sender;
- (void) crashReporterDidSend:(id) sender;
- (void) crashReporterDidFinish:(id) sender;

@end

@protocol GDCrashReporterDelegate <NSObject>
@end
