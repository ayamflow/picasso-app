//
//  MapPathView.h
//  Picasso
//
//  Created by Florian Morel on 01/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapPathView : UIView

@property (assign, nonatomic) NSInteger status;
@property (strong, nonatomic) CAShapeLayer *pathLayer;
@property (strong, nonatomic) CAShapeLayer *endPathLayer;
@property (assign, nonatomic) BOOL animated;
@property (assign, nonatomic) BOOL onlyPoints;
@property (assign, nonatomic) CGPoint startPoint;
@property (assign, nonatomic) CGPoint endPoint;

- (UIBezierPath *)getStartPath;
- (UIBezierPath *)getEndPath;
- (void)drawPath;
- (void)animatePath;

@end
