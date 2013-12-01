//
//  DashPathViewLandscape.m
//  Picasso
//
//  Created by Florian Morel on 01/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "DashedPathViewLandscape.h"

@implementation DashedPathViewLandscape

- (void)drawRect:(CGRect)rect {
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIBezierPath* context = [UIBezierPath bezierPath];

    CGFloat dash[] = {5, 5};
    [context setLineDash:dash count:2 phase:2];

    [context moveToPoint: CGPointMake(271,162)];
    [context addCurveToPoint: CGPointMake(361,125) controlPoint1: CGPointMake(271,162) controlPoint2: CGPointMake(298,98)];
    [context addCurveToPoint: CGPointMake(513,224) controlPoint1: CGPointMake(424,152) controlPoint2: CGPointMake(406,201)];
    [context addCurveToPoint: CGPointMake(643,162) controlPoint1: CGPointMake(574,224) controlPoint2: CGPointMake(643,162)];
    [context addCurveToPoint: CGPointMake(755,150) controlPoint1: CGPointMake(643,162) controlPoint2: CGPointMake(686,136)];
    [context addCurveToPoint: CGPointMake(902,208) controlPoint1: CGPointMake(825,165) controlPoint2: CGPointMake(902,208)];
    [context addCurveToPoint: CGPointMake(1061,138) controlPoint1: CGPointMake(902,208) controlPoint2: CGPointMake(977,228)];
    [context addCurveToPoint: CGPointMake(1211,197) controlPoint1: CGPointMake(1143,80) controlPoint2: CGPointMake(1191,174)];
    [context addCurveToPoint: CGPointMake(1330,228) controlPoint1: CGPointMake(1231,219) controlPoint2: CGPointMake(1291,286)];
    [context addCurveToPoint: CGPointMake(1467,158) controlPoint1: CGPointMake(1369,171) controlPoint2: CGPointMake(1432,176)];
    [context addCurveToPoint: CGPointMake(1594,233) controlPoint1: CGPointMake(1502,141) controlPoint2: CGPointMake(1594,233)];
    [context addCurveToPoint: CGPointMake(1952,162) controlPoint1: CGPointMake(1594,233) controlPoint2: CGPointMake(1578,286)];
    [context addCurveToPoint: CGPointMake(2080,200) controlPoint1: CGPointMake(2068,126) controlPoint2: CGPointMake(2080,200)];
    [context addCurveToPoint: CGPointMake(2175,251) controlPoint1: CGPointMake(2080,200) controlPoint2: CGPointMake(2113,267)];
    [context addCurveToPoint: CGPointMake(2321,198) controlPoint1: CGPointMake(2238,234) controlPoint2: CGPointMake(2273,190)];
    [context addCurveToPoint: CGPointMake(2455,189) controlPoint1: CGPointMake(2369,206) controlPoint2: CGPointMake(2410,189)];

    [strokeColor setStroke];
    context.lineWidth = 2;
    [context stroke];
}

@end