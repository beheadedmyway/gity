//
//  GTHistoryGraphCell.m
//  gitty
//
//  Created by brandon on 10/15/12.
//
//

#import "GTHistoryGraphCell.h"

@implementation GTHistoryGraphCell

- (void)drawVerticalLine:(NSRect)frame
{
    CGFloat centerX = frame.origin.x + frame.size.width / 2;
    //CGFloat centerY = frame.origin.y + frame.size.height / 2;

    //// Rectangle Drawing
    NSBezierPath* rectanglePath = [NSBezierPath bezierPathWithRect: NSMakeRect(centerX, frame.origin.y, 1, frame.size.height)];
    [[NSColor blackColor] setFill];
    [rectanglePath fill];    
}

- (void)drawLeanRightLine:(NSRect)frame
{
    [[NSColor blackColor] setStroke];

    NSBezierPath* bezierPath = [NSBezierPath bezierPath];
    [bezierPath moveToPoint:NSMakePoint(frame.origin.x + frame.size.width + 3.5, frame.origin.y)];
    [bezierPath lineToPoint:NSMakePoint(frame.origin.x - 2, frame.origin.y + frame.size.height)];
    [bezierPath setLineWidth:0.75];
    [bezierPath closePath];
    [bezierPath stroke];
}

- (void)drawLeanLeftLine:(NSRect)frame
{
    [[NSColor blackColor] setStroke];
    
    NSBezierPath* bezierPath = [NSBezierPath bezierPath];
    [bezierPath moveToPoint:NSMakePoint(frame.origin.x -2, frame.origin.y)];
    [bezierPath lineToPoint:NSMakePoint(frame.origin.x + frame.size.width + 3.5, frame.origin.y + frame.size.height)];
    [bezierPath setLineWidth:0.75];
    [bezierPath closePath];
    [bezierPath stroke];
}

- (void)drawDot:(NSRect)frame
{
    CGFloat centerX = frame.origin.x + frame.size.width / 2;
    CGFloat centerY = frame.origin.y + frame.size.height / 2;
    //// Oval Drawing
    NSBezierPath* ovalPath = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(centerX - 1.5, centerY - 2, 4, 4)];
    [[NSColor blackColor] setFill];
    [ovalPath fill];    
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    //[super drawWithFrame:cellFrame inView:controlView];
    NSString *graphString = [self objectValue];
    NSRect glyphRect = NSMakeRect(cellFrame.origin.x + 4, cellFrame.origin.y - 1, 6, cellFrame.size.height + 2);
    
    for (NSUInteger index = 0; index < [graphString length]; index++)
    {
        unichar c = [graphString characterAtIndex:index];
        switch (c)
        {
            case '*':
                [self drawVerticalLine:glyphRect];
                [self drawDot:glyphRect];
                break;
                
            case '|':
                [self drawVerticalLine:glyphRect];
                break;
                
            case '/':
                [self drawLeanRightLine:glyphRect];
                break;
                
            case '\\':
                [self drawLeanLeftLine:glyphRect];
                break;
                
            default:
                break;
        }
        
        glyphRect.origin.x += 6;
    }
}

@end
