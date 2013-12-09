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

    if(self.status == [MapPathStatus PathNotStartedStatus]) {
        CGFloat dash[] = {2, 3};
        [context setLineDash:dash count:2 phase:2];
        context.lineWidth = 1;
    }
    else {
        context.lineWidth = 4;
    }

    [context moveToPoint: CGPointMake(385,201)];

    if(self.status != [MapPathStatus PathCompletedStatus]) {
        [strokeColor setStroke];
        [context stroke];
        
        CGFloat dash[] = {2, 3};
        [context setLineDash:dash count:2 phase:2];
    [context moveToPoint: CGPointMake(385,201)];
        context.lineWidth = 1;
    }

    [context addCurveToPoint: CGPointMake(298,181) controlPoint1: CGPointMake(381,188) controlPoint2: CGPointMake(343,166)];

    [strokeColor setStroke];
    [context stroke];
}

@end