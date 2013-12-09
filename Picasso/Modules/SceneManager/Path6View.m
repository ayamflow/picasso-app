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

    [context moveToPoint: CGPointMake(900,510)];
    [context addCurveToPoint: CGPointMake(947,526) controlPoint1: CGPointMake(900,510) controlPoint2: CGPointMake(910,528)];
    [context addCurveToPoint: CGPointMake(1009,474) controlPoint1: CGPointMake(984,524) controlPoint2: CGPointMake(1007,483)];
    [context addCurveToPoint: CGPointMake(992,377) controlPoint1: CGPointMake(1011,466) controlPoint2: CGPointMake(1021,413)];

    if(self.status == [MapPathStatus PathStartedStatus]) {
        [strokeColor setStroke];
        context.lineWidth = 4;
        [context stroke];

        CGFloat dash[] = {5, 5};
        [context setLineDash:dash count:2 phase:2];
        [context moveToPoint: CGPointMake(992,377)];
    }

    [context addCurveToPoint: CGPointMake(942,258) controlPoint1: CGPointMake(964,340) controlPoint2: CGPointMake(926,303)];
    [context addCurveToPoint: CGPointMake(996,211) controlPoint1: CGPointMake(959,213) controlPoint2: CGPointMake(992,211)];
    [context addCurveToPoint: CGPointMake(1050,259) controlPoint1: CGPointMake(1001,211) controlPoint2: CGPointMake(1046,207)];

    [strokeColor setStroke];
    context.lineWidth = 4;
    [context stroke];
}

@end