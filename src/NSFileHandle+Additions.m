//
//  NSFileHandle+Additions.m
//  gitty
//
//  Created by brandon on 10/15/12.
//
//

#import "NSFileHandle+Additions.h"

@implementation NSFileHandle (Additions)

- (NSString *) readLine
{
    NSData * newLineData = [@"\n" dataUsingEncoding:NSASCIIStringEncoding];
    NSMutableData * currentData = [[NSMutableData alloc] init];
    NSUInteger chunkSize = 1;
    BOOL shouldReadMore = YES;
    
    if ([self fileDescriptor] == -1)
        return nil;
    
    @autoreleasepool
    {
        @try
        {
            while (shouldReadMore)
            {
                NSData * chunk = [self readDataOfLength:chunkSize];
                if (!chunk || [chunk length] == 0)
                    break;
                
                NSRange newLineRange = [chunk rangeOfData:newLineData];
                if (newLineRange.location != NSNotFound)
                {
                    
                    //include the length so we can include the delimiter in the string
                    chunk = [chunk subdataWithRange:NSMakeRange(0, newLineRange.location + [newLineData length])];
                    shouldReadMore = NO;
                }
                
                [currentData appendData:chunk];
            }
        }
        @catch (NSException *exception)
        {
            currentData = nil;
        }
    }
    
    if (!currentData || [currentData length] == 0)
        return nil;
    
    NSString * line = [[NSString alloc] initWithData:currentData encoding:NSASCIIStringEncoding];
    return line;
}

@end
