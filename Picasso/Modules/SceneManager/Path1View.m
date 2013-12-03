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

    [context moveToPoint: CGPointMake(85,231)];
    [context addCurveToPoint: CGPointMake(124,173) controlPoint1: CGPointMake(85,231) controlPoint2: CGPointMake(82,194)];
    [context addCurveToPoint: CGPointMake(199,184) controlPoint1: CGPointMake(165,152) controlPoint2: CGPointMake(199,184)];

    if(self.status == [MapPathStatus PathStartedStatus]) {
        [strokeColor setStroke];
        context.lineWidth = 4;
        [context stroke];

        CGFloat dash[] = {5, 5};
        [context setLineDash:dash count:2 phase:2];
        [context moveToPoint: CGPointMake(199, 184)];
    }

    [context addCurveToPoint: CGPointMake(212,276) controlPoint1: CGPointMake(199,184) controlPoint2: CGPointMake(247,210)];
    [context addCurveToPoint: CGPointMake(190,387) controlPoint1: CGPointMake(176,342) controlPoint2: CGPointMake(180,375)];
    [context addCurveToPoint: CGPointMake(223,411) controlPoint1: CGPointMake(199,398) controlPoint2: CGPointMake(223,411)];
    [strokeColor setStroke];
    context.lineWidth = 4;
    [context stroke];
}

@end