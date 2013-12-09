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

    if(self.status == [MapPathStatus PathNotStartedStatus]) {
        CGFloat dash[] = {2, 3};
        [context setLineDash:dash count:2 phase:2];
        context.lineWidth = 1;
    }
    else {
        context.lineWidth = 4;
    }

    [context moveToPoint: CGPointMake(175,522)];
    [context addCurveToPoint: CGPointMake(195,417) controlPoint1: CGPointMake(175,522) controlPoint2: CGPointMake(225,485)];
    [context addCurveToPoint: CGPointMake(142,381) controlPoint1: CGPointMake(195,417) controlPoint2: CGPointMake(183,397)];
    [context addCurveToPoint: CGPointMake(104,351) controlPoint1: CGPointMake(101,365) controlPoint2: CGPointMake(102,363)];
    [context addCurveToPoint: CGPointMake(154,329) controlPoint1: CGPointMake(106,340) controlPoint2: CGPointMake(135,330)];
    [context addCurveToPoint: CGPointMake(239,357) controlPoint1: CGPointMake(172,327) controlPoint2: CGPointMake(213,334)];
    [context addCurveToPoint: CGPointMake(261,387) controlPoint1: CGPointMake(255,373) controlPoint2: CGPointMake(261,387)];
    
    if(self.status != [MapPathStatus PathCompletedStatus]) {
        [strokeColor setStroke];
        [context stroke];
        
        CGFloat dash[] = {2, 3};
        [context setLineDash:dash count:2 phase:2];
        [context moveToPoint: CGPointMake(261,387)];
        context.lineWidth = 1;
    }
    
    [context addCurveToPoint: CGPointMake(290,419) controlPoint1: CGPointMake(261,387) controlPoint2: CGPointMake(274,411)];
    [context addCurveToPoint: CGPointMake(336,415) controlPoint1: CGPointMake(299,424) controlPoint2: CGPointMake(312,429)];
    [context addCurveToPoint: CGPointMake(335,351) controlPoint1: CGPointMake(354,399) controlPoint2: CGPointMake(364,376)];
    [context addCurveToPoint: CGPointMake(327,263) controlPoint1: CGPointMake(279,305) controlPoint2: CGPointMake(327,263)];
    [context addLineToPoint: CGPointMake(361,237)];
    [context addCurveToPoint: CGPointMake(385,201) controlPoint1: CGPointMake(361,237) controlPoint2: CGPointMake(383,227)];

    [strokeColor setStroke];
    [context stroke];

    // Draw black dots
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 1.0);
    CGFloat circleSize = 8;
    CGContextFillEllipseInRect(contextRef, CGRectMake(150, 325, circleSize, circleSize));
    CGContextFillEllipseInRect(contextRef, CGRectMake(310, 420, circleSize, circleSize));

}

@end