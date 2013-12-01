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

    [context moveToPoint: CGPointMake(360,99)];
    [context addCurveToPoint: CGPointMake(357,137) controlPoint1: CGPointMake(360,99) controlPoint2: CGPointMake(376,123)];

    if(self.status == [MapPathStatus PathStartedStatus]) {
        [strokeColor setStroke];
        context.lineWidth = 2;
        [context stroke];

        CGFloat dash[] = {5, 5};
        [context setLineDash:dash count:2 phase:2];
        [context moveToPoint: CGPointMake(357,137)];
    }

    [context addCurveToPoint: CGPointMake(318,155) controlPoint1: CGPointMake(338,146) controlPoint2: CGPointMake(333,141)];
    [context addCurveToPoint: CGPointMake(319,183) controlPoint1: CGPointMake(303,170) controlPoint2: CGPointMake(319,183)];
    [strokeColor setStroke];
    context.lineWidth = 2;
    [context stroke];
}

@end