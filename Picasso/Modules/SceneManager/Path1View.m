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

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.startPoint = CGPointMake(180, 517);
        self.endPoint = CGPointMake(388,208);
    }
    return self;
}

- (UIBezierPath *)getStartPath {
    UIBezierPath* context = [UIBezierPath bezierPath];
    [context moveToPoint: CGPointMake(180,517)];
    [context addCurveToPoint: CGPointMake(200,432) controlPoint1: CGPointMake(180,517) controlPoint2: CGPointMake(215,482)];
    [context addCurveToPoint: CGPointMake(117,372) controlPoint1: CGPointMake(189,397) controlPoint2: CGPointMake(148,382)];
    [context addCurveToPoint: CGPointMake(106,347) controlPoint1: CGPointMake(103,367) controlPoint2: CGPointMake(101,356)];
    [context addCurveToPoint: CGPointMake(119,337) controlPoint1: CGPointMake(109,340) controlPoint2: CGPointMake(119,337)];
    [context addCurveToPoint: CGPointMake(208,339) controlPoint1: CGPointMake(114,340) controlPoint2: CGPointMake(154,317)];
    [context addCurveToPoint: CGPointMake(262,388) controlPoint1: CGPointMake(243,353) controlPoint2: CGPointMake(255,375)];
    return context;
}

- (UIBezierPath *)getEndPath {
    UIBezierPath* context = [UIBezierPath bezierPath];
    [context moveToPoint:CGPointMake(262,388)];
    [context addCurveToPoint: CGPointMake(295,422) controlPoint1: CGPointMake(268,400) controlPoint2: CGPointMake(282,419)];
    [context addCurveToPoint: CGPointMake(351,387) controlPoint1: CGPointMake(311,424) controlPoint2: CGPointMake(344,425)];
    [context addCurveToPoint: CGPointMake(329,347) controlPoint1: CGPointMake(354,369) controlPoint2: CGPointMake(339,354)];
    [context addCurveToPoint: CGPointMake(336,257) controlPoint1: CGPointMake(303,327) controlPoint2: CGPointMake(295,283)];
    [context addCurveToPoint: CGPointMake(388,208) controlPoint1: CGPointMake(384,224) controlPoint2: CGPointMake(388,208)];
    return context;
}

@end