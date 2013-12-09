//
//  Path2View.m
//  Picasso
//
//  Created by Florian Morel on 01/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Path2View.h"
#import "MapPathStatus.h"

@implementation Path2View

- (void)drawRect:(CGRect)rect {
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIBezierPath* context = [UIBezierPath bezierPath];

    if(self.status == [MapPathStatus PathNotStartedStatus]) { // dash
        CGFloat dash[] = {5, 5};
        [context setLineDash:dash count:2 phase:2];
    }
    // else solid or solid/dash

    [context moveToPoint: CGPointMake(274,424)];
    [context addCurveToPoint: CGPointMake(341,395) controlPoint1: CGPointMake(274,424) controlPoint2: CGPointMake(314,434)];

    if(self.status == [MapPathStatus PathStartedStatus]) {
        [strokeColor setStroke];
        context.lineWidth = 4;
        [context stroke];

        CGFloat dash[] = {5, 5};
        [context setLineDash:dash count:2 phase:2];
        [context moveToPoint: CGPointMake(341,395)];
    }

    [context addCurveToPoint: CGPointMake(387,288) controlPoint1: CGPointMake(368,356) controlPoint2: CGPointMake(365,311)];
    [context addCurveToPoint: CGPointMake(426,271) controlPoint1: CGPointMake(408,266) controlPoint2: CGPointMake(426,271)];
    [strokeColor setStroke];
    context.lineWidth = 4;
    [context stroke];
}

@end