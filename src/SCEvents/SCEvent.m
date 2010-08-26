/*
 *  $Id: SCEvent.m 36 2009-09-08 21:36:02Z stuart $
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

#import "SCEvent.h"

@implementation SCEvent

@synthesize eventId;
@synthesize eventDate;
@synthesize eventPath;
@synthesize eventFlag;

/**
 * Returns an initialized instance of SCEvent using the supplied event ID, path 
 * and flag.
 */
+ (SCEvent *)eventWithEventId:(NSUInteger)identifier eventDate:(NSDate *)date eventPath:(NSString *)path eventFlag:(FSEventStreamEventFlags)flag
{
    return [[[SCEvent alloc] initWithEventId:identifier eventDate:date eventPath:path eventFlag:flag] autorelease];
}

/**
 * Initializes an instance of SCEvent using the supplied event ID, path and flag.
 */
- (id)initWithEventId:(NSUInteger)identifier eventDate:(NSDate *)date eventPath:(NSString *)path eventFlag:(FSEventStreamEventFlags)flag
{
    if ((self = [super init])) {
        [self setEventId:identifier];
        [self setEventDate:date];
        [self setEventPath:path];
        [self setEventFlag:flag];
    }
    
    return self;
}

/**
 * Provides the string used when printing this object in NSLog, etc. Useful for
 * debugging purposes.
 */
- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ { eventId = %ld, eventPath = %@, eventFlag = %ld } >", [self className], ((unsigned long)eventId), [self eventPath], ((unsigned long)eventFlag)];
}

/**
 * dealloc
 */
- (void)dealloc
{
    [eventDate release], eventDate = nil;
	
    [super dealloc];
}

@end
