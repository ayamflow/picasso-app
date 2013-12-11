//
//  MapPathView.m
//  Picasso
//
//  Created by Florian Morel on 01/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "MapPathView.h"
#import "MapPathStatus.h"

@implementation MapPathView

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIBezierPath *)getStartPath {
    return [UIBezierPath bezierPath];    
}

- (UIBezierPath *)getEndPath {
    return [UIBezierPath bezierPath];
}

- (void)drawRect:(CGRect)rect {
    if(self.animated || self.onlyPoints) {
        // Draw black dots
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(contextRef, 0, 0, 0, 1.0);
        CGFloat circleSize = 8;
        CGContextFillEllipseInRect(contextRef, CGRectMake(self.startPoint.x - circleSize / 2, self.startPoint.y - circleSize / 2, circleSize, circleSize));
        CGContextFillEllipseInRect(contextRef, CGRectMake(self.endPoint.x - circleSize / 2, self.endPoint.y - circleSize / 2, circleSize, circleSize));
    }
    else {
        [self drawPath];
    }
}

- (void)drawPath {
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIBezierPath* context = [self getStartPath];
    
    if(self.status == [MapPathStatus PathNotStartedStatus]) {
        CGFloat dash[] = {2, 3};
        [context setLineDash:dash count:2 phase:2];
        context.lineWidth = 1;
    }
    else {
        context.lineWidth = 4;
    }
    
    [strokeColor setStroke];
    [context stroke];
    context = [self getEndPath];
    
    if(self.status != [MapPathStatus PathCompletedStatus]) {
        CGFloat dash[] = {2, 3};
        [context setLineDash:dash count:2 phase:2];
        context.lineWidth = 1;
    }
    else {
        context.lineWidth = 4;
    }
    
    [strokeColor setStroke];
    [context stroke];
    
    // Draw black dots
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 1.0);
    CGFloat circleSize = 8;
    CGContextFillEllipseInRect(contextRef, CGRectMake(150, 325, circleSize, circleSize));
    CGContextFillEllipseInRect(contextRef, CGRectMake(310, 420, circleSize, circleSize));
}

- (void)animatePath {
    if(self.pathLayer == nil) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [self getStartPath];
        [path appendPath:[self getEndPath]];
        shapeLayer.path = [path CGPath];
        shapeLayer.lineWidth = 1;
        shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:3], nil];
        shapeLayer.strokeColor = [[UIColor blackColor] CGColor];
        shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        shapeLayer.lineJoin = kCALineJoinBevel;
        [self.layer addSublayer:shapeLayer];
        self.pathLayer = shapeLayer;
    }

    // Animating the dots
/*    CGFloat circleSize = 4;
    UIBezierPath *circle = [UIBezierPath bezierPath];
    [circle addArcWithCenter:self.startPoint radius:circleSize startAngle:0.0 endAngle:M_PI * 2.0 clockwise:YES];
    CAShapeLayer *startCircle = [CAShapeLayer layer];
    startCircle.path = [circle CGPath];
    startCircle.fillColor = [[UIColor blackColor] CGColor];
    [self.layer addSublayer:startCircle];*/

    [CATransaction begin];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.6;
    pathAnimation.fromValue = @(0.0f);
    pathAnimation.toValue = @(1.0f);
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    [CATransaction commit];
}

@end