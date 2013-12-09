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

    if(self.status == [MapPathStatus PathNotStartedStatus]) {
        CGFloat dash[] = {2, 3};
        [context setLineDash:dash count:2 phase:2];
        context.lineWidth = 1;
    }
    else {
        context.lineWidth = 4;
    }

    [context moveToPoint: CGPointMake(307,177)];
    [context addCurveToPoint: CGPointMake(291,216) controlPoint1: CGPointMake(293,183) controlPoint2: CGPointMake(277,198)];
    [context addCurveToPoint: CGPointMake(348,226) controlPoint1: CGPointMake(305,234) controlPoint2: CGPointMake(348,226)];
    [context addCurveToPoint: CGPointMake(390,191) controlPoint1: CGPointMake(348,226) controlPoint2: CGPointMake(382,220)];
    [context addCurveToPoint: CGPointMake(429,189) controlPoint1: CGPointMake(390,191) controlPoint2: CGPointMake(409,173)];
    [context addCurveToPoint: CGPointMake(440,231) controlPoint1: CGPointMake(449,205) controlPoint2: CGPointMake(440,231)];
    
    if(self.status != [MapPathStatus PathCompletedStatus]) {
        [strokeColor setStroke];
        [context stroke];
        
        CGFloat dash[] = {2, 3};
        [context setLineDash:dash count:2 phase:2];
        [context moveToPoint: CGPointMake(440, 231)];
        context.lineWidth = 1;
    }
//    else {
//        context.lineWidth = 4;
//    }

    [context addCurveToPoint: CGPointMake(420,251) controlPoint1: CGPointMake(440,231) controlPoint2: CGPointMake(432,249)];
    [context addCurveToPoint: CGPointMake(336,296) controlPoint1: CGPointMake(357,272) controlPoint2: CGPointMake(336,296)];
    [context addLineToPoint: CGPointMake(336,296)];
    [context addCurveToPoint: CGPointMake(340,333) controlPoint1: CGPointMake(334,301) controlPoint2: CGPointMake(323,320)];
    [context addCurveToPoint: CGPointMake(390,348) controlPoint1: CGPointMake(364,355) controlPoint2: CGPointMake(387,348)];
    
    [strokeColor setStroke];
    [context stroke];
}

@end
