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
    
    // Draw corogne/barcelone black dots
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 1.0);
    CGFloat circleSize = 8;
    CGContextFillEllipseInRect(contextRef, CGRectMake(150, 325, circleSize, circleSize));
    CGContextFillEllipseInRect(contextRef, CGRectMake(310, 418, circleSize, circleSize));
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
    
//    CAShapeLayer *startCircle = [self getCircleShapeAtPoint:self.startPoint];
//    [self.layer addSublayer:startCircle];
//    CAShapeLayer *endCircle = [self getCircleShapeAtPoint:self.endPoint];
//    [self.layer addSublayer:endCircle];
    
    [CATransaction begin];
    /*int i = 0;
    CABasicAnimation *circleAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    circleAnim.fromValue = @(0.0);
    circleAnim.toValue = @(1.0);
    circleAnim.duration = 0.1;
    circleAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    for(CAShapeLayer *circle in @[startCircle, endCircle]) {
        circleAnim.beginTime = CACurrentMediaTime() + i++ * 0.6;
        [startCircle addAnimation:circleAnim forKey:circleAnim.keyPath];
    }*/
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.6;
    pathAnimation.fromValue = @(0.0f);
    pathAnimation.toValue = @(1.0f);
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    [CATransaction commit];
}

- (CAShapeLayer *)getCircleShapeAtPoint:(CGPoint)point {
    CGFloat circleSize = 8;
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.fillColor = [UIColor blackColor].CGColor;
    circle.anchorPoint = CGPointMake(0.5, 0.5);
    CGRect bounds = CGRectMake(point.x - circleSize / 2, point.y - circleSize / 2, circleSize, circleSize);
    circle.path = [UIBezierPath bezierPathWithOvalInRect:bounds].CGPath;
//    circle.bounds = bounds;
    return circle;
}

@end