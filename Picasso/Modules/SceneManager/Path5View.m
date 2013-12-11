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
        self.startPoint = CGPointMake(297, 183);
        self.endPoint = CGPointMake(386, 350);
    }
    return self;
}

- (UIBezierPath *)getStartPath {
    UIBezierPath* context =  [UIBezierPath bezierPath];
    [context moveToPoint: CGPointMake(297,183)];
    [context addCurveToPoint: CGPointMake(286,208) controlPoint1: CGPointMake(297,183) controlPoint2: CGPointMake(283,193)];
    [context addCurveToPoint: CGPointMake(331,229) controlPoint1: CGPointMake(290,225) controlPoint2: CGPointMake(320,228)];
    [context addCurveToPoint: CGPointMake(384,196) controlPoint1: CGPointMake(344,229) controlPoint2: CGPointMake(386,218)];
    [context addCurveToPoint: CGPointMake(390,188) controlPoint1: CGPointMake(384,190) controlPoint2: CGPointMake(384,189)];


    return context;
}

- (UIBezierPath *)getEndPath {
    UIBezierPath* context =  [UIBezierPath bezierPath];
    [context moveToPoint: CGPointMake(390,188)];
    [context addCurveToPoint: CGPointMake(428,190) controlPoint1: CGPointMake(390,188) controlPoint2: CGPointMake(412,174)];
    [context addCurveToPoint: CGPointMake(418,252) controlPoint1: CGPointMake(454,216) controlPoint2: CGPointMake(438,244)];
    [context addCurveToPoint: CGPointMake(333,324) controlPoint1: CGPointMake(402,258) controlPoint2: CGPointMake(313,283)];
    [context addCurveToPoint: CGPointMake(386,350) controlPoint1: CGPointMake(346,352) controlPoint2: CGPointMake(386,350)];
    return context;
}

@end