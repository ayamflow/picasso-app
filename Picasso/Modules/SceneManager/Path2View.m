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

    [context moveToPoint: CGPointMake(136,211)];
    [context addCurveToPoint: CGPointMake(169,197) controlPoint1: CGPointMake(136,211) controlPoint2: CGPointMake(156,216)];

    if(self.status == [MapPathStatus PathStartedStatus]) {
        [strokeColor setStroke];
        context.lineWidth = 2;
        [context stroke];

        CGFloat dash[] = {5, 5};
        [context setLineDash:dash count:2 phase:2];
        [context moveToPoint: CGPointMake(169,197)];
    }

    [context addCurveToPoint: CGPointMake(192,143) controlPoint1: CGPointMake(183,177) controlPoint2: CGPointMake(181,155)];
    [context addCurveToPoint: CGPointMake(212,135) controlPoint1: CGPointMake(203,132) controlPoint2: CGPointMake(212,135)];
    [strokeColor setStroke];
    context.lineWidth = 2;
    [context stroke];

}

@end