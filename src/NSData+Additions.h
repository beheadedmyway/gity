//
//  NSData+Additions.h
//  gitty
//
//  Created by brandon on 10/15/12.
//
//

#import <Foundation/Foundation.h>

@interface NSData (Additions)

- (NSRange)rangeOfData:(NSData *)dataToFind;
- (NSString *)stringValueWithEncoding:(NSStringEncoding)encoding;

@end
