//
//  Path3View.m
//  Picasso
//
//  Created by Florian Morel on 01/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Path3View.h"
#import "MapPathStatus.h"

@implementation Path3View

- (void)drawRect:(CGRect)rect {
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIBezierPath* context = [UIBezierPath bezierPath];

    if(self.status == [MapPathStatus PathNotStartedStatus]) { // dash
        CGFloat dash[] = {5, 5};
        [context setLineDash:dash count:2 phase:2];
    }
    // else solid or solid/dash

    [context moveToPoint: CGPointMake(477,275)];
    [context addCurveToPoint: CGPointMake(560,243) controlPoint1: CGPointMake(477,275) controlPoint2: CGPointMake(544,282)];

    if(self.status == [MapPathStatus PathStartedStatus]) {
        [strokeColor setStroke];
        context.lineWidth = 4;
        [context stroke];

        CGFloat dash[] = {5, 5};
        [context setLineDash:dash count:2 phase:2];
        [context moveToPoint: CGPointMake(560, 243)];
    }

    [context addCurveToPoint: CGPointMake(600,161) controlPoint1: CGPointMake(576,205) controlPoint2: CGPointMake(560,188)];
    [context addCurveToPoint: CGPointMake(694,168) controlPoint1: CGPointMake(641,133) controlPoint2: CGPointMake(686,159)];

    [strokeColor setStroke];
    context.lineWidth = 4;
    [context stroke];

}

@end
