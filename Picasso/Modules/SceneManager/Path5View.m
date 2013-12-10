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

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.startPoint = CGPointMake(297, 184);
        self.endPoint = CGPointMake(387, 350);
    }
    return self;
}

- (UIBezierPath *)getStartPath {
    UIBezierPath* context =  [UIBezierPath bezierPath];
    [context moveToPoint: CGPointMake(297,184)];
    [context addCurveToPoint: CGPointMake(287,208) controlPoint1: CGPointMake(297,184) controlPoint2: CGPointMake(283,194)];
    [context addCurveToPoint: CGPointMake(332,229) controlPoint1: CGPointMake(291,225) controlPoint2: CGPointMake(321,229)];
    [context addCurveToPoint: CGPointMake(381,207) controlPoint1: CGPointMake(344,229) controlPoint2: CGPointMake(378,218)];
    [context moveToPoint: CGPointMake(391,188)];


    return context;
}

- (UIBezierPath *)getEndPath {
    UIBezierPath* context =  [UIBezierPath bezierPath];
    [context moveToPoint: CGPointMake(391, 188)];
    [context addCurveToPoint: CGPointMake(429,191) controlPoint1: CGPointMake(391,188) controlPoint2: CGPointMake(412,174)];
    [context addCurveToPoint: CGPointMake(419,253) controlPoint1: CGPointMake(455,217) controlPoint2: CGPointMake(439,245)];
    [context addCurveToPoint: CGPointMake(334,325) controlPoint1: CGPointMake(403,259) controlPoint2: CGPointMake(314,284)];
    [context addCurveToPoint: CGPointMake(387,350) controlPoint1: CGPointMake(347,352) controlPoint2: CGPointMake(387,350)];
    return context;
}

@end