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

    [context moveToPoint: CGPointMake(237,137)];
    [context addCurveToPoint: CGPointMake(279,121) controlPoint1: CGPointMake(237,137) controlPoint2: CGPointMake(271,140)];

    if(self.status == [MapPathStatus PathStartedStatus]) {
        [strokeColor setStroke];
        context.lineWidth = 2;
        [context stroke];

        CGFloat dash[] = {5, 5};
        [context setLineDash:dash count:2 phase:2];
        [context moveToPoint: CGPointMake(279,121)];
    }

    [context addCurveToPoint: CGPointMake(299,80) controlPoint1: CGPointMake(287,102) controlPoint2: CGPointMake(279,93)];
    [context addCurveToPoint: CGPointMake(346,83) controlPoint1: CGPointMake(319,66) controlPoint2: CGPointMake(342,79)];
    [strokeColor setStroke];
    context.lineWidth = 2;
    [context stroke];

}

@end
