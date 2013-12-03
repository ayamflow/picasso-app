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

    [context moveToPoint: CGPointMake(681,403)];
    [context addCurveToPoint: CGPointMake(754,415) controlPoint1: CGPointMake(681,403) controlPoint2: CGPointMake(715,423)];

    if(self.status == [MapPathStatus PathStartedStatus]) {
        [strokeColor setStroke];
        context.lineWidth = 4;
        [context stroke];

        CGFloat dash[] = {5, 5};
        [context setLineDash:dash count:2 phase:2];
        [context moveToPoint: CGPointMake(754,415)];
    }

    [context addCurveToPoint: CGPointMake(843,434) controlPoint1: CGPointMake(793,407) controlPoint2: CGPointMake(833,425)];
    [context addCurveToPoint: CGPointMake(870,466) controlPoint1: CGPointMake(853,444) controlPoint2: CGPointMake(870,466)];
    [strokeColor setStroke];
    context.lineWidth = 4;
    [context stroke];
}

@end
