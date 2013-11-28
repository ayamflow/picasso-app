//
//  ClockNeedleView.m
//  Picasso
//
//  Created by MOREL Florian on 28/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "ClockNeedleView.h"

#define kLineWidth 2

@implementation ClockNeedleView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetLineWidth(context, kLineWidth);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextMoveToPoint(context, rect.size.width / 2, rect.size.height / 2);
    CGContextAddLineToPoint(context, rect.size.width / 2, rect.size.height / 2 + self.lineLength);
    CGContextStrokePath(context);
}

@end
