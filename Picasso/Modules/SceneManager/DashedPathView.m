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

    CGContextAddCurveToPoint(context, 0, 92, 327, 3, 213,- 20);
    CGContextAddCurveToPoint(context, 440, 28, 672, 107, 541, 92);
    CGContextAddCurveToPoint(context, 804, 122, 954, 83, 954, 83);
    CGContextAddCurveToPoint(context, 954, 83, 1350, 111, 1150, 77);
    CGContextAddCurveToPoint(context, 1550, 144, 1672, 55, 1627, 64);
    CGContextAddCurveToPoint(context, 1718, 46, 1945, 77, 1909, 73);
    CGContextAddCurveToPoint(context, 1981, 80, 2309, 119, 2240, 142);
    CGContextAddCurveToPoint(context, 2370, 97, 2700, 37, 2635, 77);
    CGContextAddCurveToPoint(context, 2759, 0, 2972, 25, 2931,- 11);
    CGContextAddCurveToPoint(context, 3013, 61, 3300, 92, 3263, 138);
    CGContextAddCurveToPoint(context, 3336, 46, 3559, 62, 3463, 56);
    CGContextAddCurveToPoint(context, 3654, 67, 3786, 12, 3745, 37);
    CGContextAddCurveToPoint(context, 3827,- 11, 4018, 124, 3968, 119);
    CGContextAddCurveToPoint(context, 4068, 128, 4381, 0, 4277, 6);
    CGContextAddCurveToPoint(context, 4486,- 5, 4622, 62, 4622, 62);

    CGContextStrokePath(context);
}

@end
