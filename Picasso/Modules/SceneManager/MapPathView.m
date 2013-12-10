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
        
        if(self.status == [MapPathStatus PathCompletedStatus]) { // 1 solid
            shapeLayer.lineWidth = 2;
        }
        else { // 1 dash
            shapeLayer.lineWidth = 1;
            shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:3], nil];
        }

        UIBezierPath *path = [self getStartPath];
        [path appendPath:[self getEndPath]];
        shapeLayer.path = [path CGPath];
        shapeLayer.strokeColor = [[UIColor blackColor] CGColor];
        shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        shapeLayer.lineJoin = kCALineJoinBevel;
        [self.layer addSublayer:shapeLayer];
        self.pathLayer = shapeLayer;
    }
    
/*    if(self.status == [MapPathStatus PathStartedStatus]) { // 1 dash + half solid
        if(self.endPathLayer == nil) {
            CAShapeLayer *endShapeLayer = [CAShapeLayer layer];
            endShapeLayer.lineWidth = 2;
            
            UIBezierPath *path = [self getStartPath];
            endShapeLayer.path = [path CGPath];
            
            endShapeLayer.path = [path CGPath];
            endShapeLayer.strokeColor = [[UIColor blackColor] CGColor];
            endShapeLayer.fillColor = [[UIColor clearColor] CGColor];
            endShapeLayer.lineJoin = kCALineJoinBevel;
            
            [self.layer addSublayer:endShapeLayer];
            self.endPathLayer = endShapeLayer;
            
            CABasicAnimation *endPathAnimation = [self getPathAnimationWithDuration:0.8];
            [self.endPathLayer addAnimation:endPathAnimation forKey:@"strokeEnd"];
        }
    }*/

    CABasicAnimation *pathAnimation = [self getPathAnimationWithDuration:1.6];
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}

- (CABasicAnimation *)getPathAnimationWithDuration:(NSTimeInterval)duration {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = duration;
    pathAnimation.fromValue = @(0.0f);
    pathAnimation.toValue = @(1.0f);
    return pathAnimation;
}

@end
