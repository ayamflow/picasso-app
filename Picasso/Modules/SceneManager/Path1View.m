//
//  Path1View.m
//  Picasso
//
//  Created by Florian Morel on 01/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Path1View.h"
#import "MapPathStatus.h"

@implementation Path1View

- (void)drawRect:(CGRect)rect {
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIBezierPath* context = [UIBezierPath bezierPath];

    if(self.status == [MapPathStatus PathNotStartedStatus]) { // dash
        CGFloat dash[] = {2, 3};
        [context setLineDash:dash count:2 phase:2];
            context.lineWidth = 1;
    }
    else {
        context.lineWidth = 4;
    }
    // else solid or solid/dash

    [context moveToPoint: CGPointMake(179,518)];
    [context addCurveToPoint: CGPointMake(197,425) controlPoint1: CGPointMake(179,518) controlPoint2: CGPointMake(214,482)];
    [context addCurveToPoint: CGPointMake(130,374) controlPoint1: CGPointMake(192,398) controlPoint2: CGPointMake(130,374)];
    [context addCurveToPoint: CGPointMake(103,350) controlPoint1: CGPointMake(109,371) controlPoint2: CGPointMake(101,363)];
    [context addCurveToPoint: CGPointMake(152,329) controlPoint1: CGPointMake(105,338) controlPoint2: CGPointMake(140,329)];

    if(self.status == [MapPathStatus PathStartedStatus]) {
        [strokeColor setStroke];
        [context stroke];

        CGFloat dash[] = {2, 3};
        [context setLineDash:dash count:2 phase:2];
        [context moveToPoint: CGPointMake(152,329)];
        context.lineWidth = 1;
    }
    else {
        context.lineWidth = 4;
    }

    [context addCurveToPoint: CGPointMake(245,364) controlPoint1: CGPointMake(164,328) controlPoint2: CGPointMake(212,331)];
    [context addCurveToPoint: CGPointMake(312,423) controlPoint1: CGPointMake(279,403) controlPoint2: CGPointMake(269,424)];
    [context addCurveToPoint: CGPointMake(346,365) controlPoint1: CGPointMake(357,416) controlPoint2: CGPointMake(353,374)];
    [context addCurveToPoint: CGPointMake(330,348) controlPoint1: CGPointMake(346,365) controlPoint2: CGPointMake(336,352)];
    [context addCurveToPoint: CGPointMake(308,294) controlPoint1: CGPointMake(324,344) controlPoint2: CGPointMake(302,323)];
    [context addCurveToPoint: CGPointMake(342,252) controlPoint1: CGPointMake(313,264) controlPoint2: CGPointMake(342,252)];
    [context addCurveToPoint: CGPointMake(386,204) controlPoint1: CGPointMake(342,252) controlPoint2: CGPointMake(386,222)];

    [strokeColor setStroke];
    [context stroke];
}

@end