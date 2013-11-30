//
//  DashedPathView.m
//  Picasso
//
//  Created by Florian Morel on 30/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "DashedPathView.h"

@implementation DashedPathView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGFloat lines[] = {5, 5, 5, 5, 5};
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
    CGContextSetLineDash(context, 0, lines, 5);
    CGContextMoveToPoint(context, 0, 0);

    CGRect currentBounds;
    for(int i = 0; i < 7; i++) {
        currentBounds = CGRectMake(i * self.bounds.size.width / 7, self.bounds.origin.y, self.bounds.size.width / 7, self.bounds.size.height);
        CGContextAddCurveToPoint(context, currentBounds.origin.x + currentBounds.size.width / 5.0f, CGRectGetMidY(currentBounds) - currentBounds.size.width / 5.0f, CGRectGetMidX(currentBounds) - currentBounds.size.width / 5.0f, CGRectGetMidY(currentBounds) - currentBounds.size.width / 5.0f, CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
        CGContextAddCurveToPoint(context, CGRectGetMidX(currentBounds) + currentBounds.size.width / 5.0f, CGRectGetMidY(currentBounds) + currentBounds.size.width / 5.0f, currentBounds.size.width - currentBounds.size.width / 5.0f, CGRectGetMidY(currentBounds) + currentBounds.size.width / 5.0f, currentBounds.size.width, CGRectGetMidY(currentBounds));
    }

    CGContextStrokePath(context);
}

@end
