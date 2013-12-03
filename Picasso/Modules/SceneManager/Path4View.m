//
//  Path4View.m
//  Picasso
//
//  Created by Florian Morel on 01/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Path4View.h"
#import "MapPathStatus.h"

@implementation Path4View

- (void)drawRect:(CGRect)rect {
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIBezierPath* context = [UIBezierPath bezierPath];

    if(self.status == [MapPathStatus PathNotStartedStatus]) { // dash
        CGFloat dash[] = {5, 5};
        [context setLineDash:dash count:2 phase:2];
    }
    // else solid or solid/dash

    [context moveToPoint: CGPointMake(723,200)];
    [context addCurveToPoint: CGPointMake(717,276) controlPoint1: CGPointMake(723,200) controlPoint2: CGPointMake(754,247)];

    if(self.status == [MapPathStatus PathStartedStatus]) {
        [strokeColor setStroke];
        context.lineWidth = 4;
        [context stroke];

        CGFloat dash[] = {5, 5};
        [context setLineDash:dash count:2 phase:2];
        [context moveToPoint: CGPointMake(717,276)];
    }

    [context addCurveToPoint: CGPointMake(638,312) controlPoint1: CGPointMake(679,293) controlPoint2: CGPointMake(669,283)];
    [context addCurveToPoint: CGPointMake(641,368) controlPoint1: CGPointMake(608,341) controlPoint2: CGPointMake(641,368)];
    [strokeColor setStroke];
    context.lineWidth = 4;
    [context stroke];
}

@end