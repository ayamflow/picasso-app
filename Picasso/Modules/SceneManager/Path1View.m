//
//  Path1View.m
//  Picasso
//
//  Created by Florian Morel on 01/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Path1View.h"
#import "MapPathStatus.h"

@implementation Path1View

- (void)drawRect:(CGRect)rect {
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIBezierPath* context = [UIBezierPath bezierPath];

    if(self.status == [MapPathStatus PathNotStartedStatus]) { // dash
        CGFloat dash[] = {5, 5};
        [context setLineDash:dash count:2 phase:2];
    }
    // else solid or solid/dash

    [context moveToPoint: CGPointMake(41,115)];
    [context addCurveToPoint: CGPointMake(61,86) controlPoint1: CGPointMake(41,115) controlPoint2: CGPointMake(40,96)];
    [context addCurveToPoint: CGPointMake(98,91) controlPoint1: CGPointMake(81,75) controlPoint2: CGPointMake(98,91)];

    if(self.status == [MapPathStatus PathStartedStatus]) {
        [strokeColor setStroke];
        context.lineWidth = 2;
        [context stroke];

        CGFloat dash[] = {5, 5};
        [context setLineDash:dash count:2 phase:2];
        [context moveToPoint: CGPointMake(98,91)];
    }

    [context addCurveToPoint: CGPointMake(105,137) controlPoint1: CGPointMake(98,91) controlPoint2: CGPointMake(122,104)];
    [context addCurveToPoint: CGPointMake(94,193) controlPoint1: CGPointMake(87,170) controlPoint2: CGPointMake(89,187)];
    [context addCurveToPoint: CGPointMake(110,205) controlPoint1: CGPointMake(98,198) controlPoint2: CGPointMake(110,205)];
    [strokeColor setStroke];
    context.lineWidth = 2;
    [context stroke];
}

@end