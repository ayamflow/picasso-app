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
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIBezierPath* context = [UIBezierPath bezierPath];

    CGFloat dash[] = {5, 5};
    [context setLineDash:dash count:2 phase:2];

    [context moveToPoint: CGPointMake(0,482)];
    [context addCurveToPoint: CGPointMake(67,459) controlPoint1: CGPointMake(0,482) controlPoint2: CGPointMake(20,442)];
    [context addCurveToPoint: CGPointMake(181,521) controlPoint1: CGPointMake(114,476) controlPoint2: CGPointMake(101,507)];
    [context addCurveToPoint: CGPointMake(278,482) controlPoint1: CGPointMake(226,521) controlPoint2: CGPointMake(278,482)];
    [context addCurveToPoint: CGPointMake(362,475) controlPoint1: CGPointMake(278,482) controlPoint2: CGPointMake(310,466)];
    [context addCurveToPoint: CGPointMake(472,511) controlPoint1: CGPointMake(414,484) controlPoint2: CGPointMake(472,511)];
    [context addCurveToPoint: CGPointMake(591,467) controlPoint1: CGPointMake(472,511) controlPoint2: CGPointMake(528,524)];
    [context addCurveToPoint: CGPointMake(703,504) controlPoint1: CGPointMake(652,431) controlPoint2: CGPointMake(688,490)];
    [context addCurveToPoint: CGPointMake(792,524) controlPoint1: CGPointMake(718,518) controlPoint2: CGPointMake(763,560)];
    [context addCurveToPoint: CGPointMake(895,480) controlPoint1: CGPointMake(821,488) controlPoint2: CGPointMake(869,491)];
    [context addCurveToPoint: CGPointMake(990,527) controlPoint1: CGPointMake(921,469) controlPoint2: CGPointMake(990,527)];
    [context addCurveToPoint: CGPointMake(1258,482) controlPoint1: CGPointMake(990,527) controlPoint2: CGPointMake(978,560)];
    [context addCurveToPoint: CGPointMake(1354,506) controlPoint1: CGPointMake(1344,459) controlPoint2: CGPointMake(1354,506)];
    [context addCurveToPoint: CGPointMake(1425,538) controlPoint1: CGPointMake(1354,506) controlPoint2: CGPointMake(1378,548)];
    [context addCurveToPoint: CGPointMake(1534,505) controlPoint1: CGPointMake(1472,527) controlPoint2: CGPointMake(1498,500)];
    [context addCurveToPoint: CGPointMake(1627,544) controlPoint1: CGPointMake(1570,510) controlPoint2: CGPointMake(1593,544)];
    [context addCurveToPoint: CGPointMake(1759,521) controlPoint1: CGPointMake(1661,544) controlPoint2: CGPointMake(1746,529)];
    [context addCurveToPoint: CGPointMake(1892,492) controlPoint1: CGPointMake(1772,513) controlPoint2: CGPointMake(1852,488)];
    [context addCurveToPoint: CGPointMake(2003,512) controlPoint1: CGPointMake(1932,496) controlPoint2: CGPointMake(1964,524)];
    [context addCurveToPoint: CGPointMake(2251,485) controlPoint1: CGPointMake(2042,500) controlPoint2: CGPointMake(2251,485)];

    [strokeColor setStroke];
    context.lineWidth = 2;
    [context stroke];
}

/*- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);

    CGFloat lines[] = {5, 5};
    CGContextSetLineDash(context, 0, lines, 2);

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
}*/

@end
