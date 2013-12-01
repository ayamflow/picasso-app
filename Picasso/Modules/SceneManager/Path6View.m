//
//  Path6View.m
//  Picasso
//
//  Created by Florian Morel on 01/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Path6View.h"
#import "MapPathStatus.h"

@implementation Path6View

- (void)drawRect:(CGRect)rect {
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIBezierPath* context = [UIBezierPath bezierPath];

    if(self.status == [MapPathStatus PathNotStartedStatus]) { // dash
        CGFloat dash[] = {5, 5};
        [context setLineDash:dash count:2 phase:2];
    }
    // else solid or solid/dash

    [context moveToPoint: CGPointMake(449,254)];
    [context addCurveToPoint: CGPointMake(472,262) controlPoint1: CGPointMake(449,254) controlPoint2: CGPointMake(454,263)];
    [context addCurveToPoint: CGPointMake(503,236) controlPoint1: CGPointMake(491,261) controlPoint2: CGPointMake(502,241)];
    [context addCurveToPoint: CGPointMake(495,188) controlPoint1: CGPointMake(504,232) controlPoint2: CGPointMake(509,206)];


    if(self.status == [MapPathStatus PathStartedStatus]) {
        [strokeColor setStroke];
        context.lineWidth = 2;
        [context stroke];

        CGFloat dash[] = {5, 5};
        [context setLineDash:dash count:2 phase:2];
        [context moveToPoint: CGPointMake(495,188)];
    }

    [context addCurveToPoint: CGPointMake(470,128) controlPoint1: CGPointMake(481,169) controlPoint2: CGPointMake(462,151)];
    [context addCurveToPoint: CGPointMake(497,105) controlPoint1: CGPointMake(478,106) controlPoint2: CGPointMake(495,105)];
    [context addCurveToPoint: CGPointMake(524,129) controlPoint1: CGPointMake(499,105) controlPoint2: CGPointMake(522,103)];
    [strokeColor setStroke];
    context.lineWidth = 2;
    [context stroke];
}

@end