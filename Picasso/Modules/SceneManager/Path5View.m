//
//  Path5View.m
//  Picasso
//
//  Created by Florian Morel on 01/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Path5View.h"
#import "MapPathStatus.h"

@implementation Path5View

- (void)drawRect:(CGRect)rect {
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIBezierPath* context = [UIBezierPath bezierPath];

    if(self.status == [MapPathStatus PathNotStartedStatus]) { // dash
        CGFloat dash[] = {5, 5};
        [context setLineDash:dash count:2 phase:2];
    }
    // else solid or solid/dash

    [context moveToPoint: CGPointMake(339,201)];
    [context addCurveToPoint: CGPointMake(376,207) controlPoint1: CGPointMake(339,201) controlPoint2: CGPointMake(356,211)];

    if(self.status == [MapPathStatus PathStartedStatus]) {
        [strokeColor setStroke];
        context.lineWidth = 2;
        [context stroke];

        CGFloat dash[] = {5, 5};
        [context setLineDash:dash count:2 phase:2];
        [context moveToPoint: CGPointMake(376,207)];
    }

    [context addCurveToPoint: CGPointMake(420,216) controlPoint1: CGPointMake(395,203) controlPoint2: CGPointMake(415,212)];
    [context addCurveToPoint: CGPointMake(434,232) controlPoint1: CGPointMake(425,221) controlPoint2: CGPointMake(434,232)];
    [strokeColor setStroke];
    context.lineWidth = 2;
    [context stroke];
}

@end
