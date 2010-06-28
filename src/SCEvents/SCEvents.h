/*
 *  $Id: SCEvents.h 45 2009-11-27 01:04:03Z stuart $
 *
 *  SCEvents
 *
 *  Copyright (c) 2009 Stuart Connolly
 *  http://stuconnolly.com/projects/source-code/
 *
 *  Permission is hereby granted, free of charge, to any person
 *  obtaining a copy of this software and associated documentation
 *  files (the "Software"), to deal in the Software without
 *  restriction, including without limitation the rights to use,
 *  copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the
 *  Software is furnished to do so, subject to the following
 *  conditions:
 *
 *  The above copyright notice and this permission notice shall be
 *  included in all copies or substantial portions of the Software.
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 *  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 *  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 *  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 *  OTHER DEALINGS IN THE SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>

@class SCEvent;
@protocol SCEventListenerProtocol;

@interface SCEvents : NSObject 
{
    id <SCEventListenerProtocol> delegate;    // The delegate that SCEvents is to notify when events occur.
    
    BOOL             isWatchingPaths;         // Is the events stream currently running.
    BOOL             ignoreEventsFromSubDirs; // Ignore events from sub-directories of the excluded paths. Defaults to YES.
    FSEventStreamRef eventStream;             // The actual FSEvents stream reference.
    CFTimeInterval   notificationLatency;     // The latency time of which SCEvents is notified by FSEvents of events. Defaults to 3 seconds.
      
    SCEvent          *lastEvent;              // The last event that occurred and that was delivered to the delegate.
    NSMutableArray   *watchedPaths;           // The paths that are to be watched for events.
    NSMutableArray   *excludedPaths;          // The paths that SCEvents should ignore events from and not deliver to the delegate.
}

@property (readwrite, assign) id delegate;
@property (readonly) BOOL isWatchingPaths;
@property (readwrite, assign) BOOL ignoreEventsFromSubDirs;
@property (readwrite, retain) SCEvent *lastEvent;
@property (readwrite, assign) double notificationLatency;
@property (readwrite, retain) NSMutableArray *watchedPaths;
@property (readwrite, retain) NSMutableArray *excludedPaths;

//+ (id)sharedPathWatcher;

- (BOOL)flushEventStreamSync;
- (BOOL)flushEventStreamAsync;

- (BOOL)startWatchingPaths:(NSMutableArray *)paths;
- (BOOL)startWatchingPaths:(NSMutableArray *)paths onRunLoop:(NSRunLoop *)runLoop;

- (BOOL)stopWatchingPaths;

- (NSString *)streamDescription;

@end
