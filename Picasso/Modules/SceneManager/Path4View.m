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

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.startPoint = CGPointMake(378, 190);
        self.endPoint = CGPointMake(314, 176);
    }
    return self;
}

- (UIBezierPath *)getStartPath {
    UIBezierPath* context = [UIBezierPath bezierPath];
    [context moveToPoint: CGPointMake(378,190)];
    return context;
}

- (UIBezierPath *)getEndPath {
    UIBezierPath* context = [UIBezierPath bezierPath];
    [context moveToPoint: CGPointMake(378,190)];
    [context addCurveToPoint: CGPointMake(314,176) controlPoint1: CGPointMake(378,190) controlPoint2: CGPointMake(357,173)];
    return context;
}

@end