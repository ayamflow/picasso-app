//
//  Path1View.m
//  Picasso
//
//  Created by Florian Morel on 01/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Path3View.h"
#import "MapPathStatus.h"

@implementation Path3View

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.startPoint = CGPointMake(387, 191);
        self.endPoint = CGPointMake(364, 185);
    }
    return self;
}

- (UIBezierPath *)getStartPath {
    UIBezierPath* context = [UIBezierPath bezierPath];
    [context moveToPoint: self.startPoint];
    return context;
}

- (UIBezierPath *)getEndPath {
    UIBezierPath* context = [UIBezierPath bezierPath];
    [context moveToPoint: self.startPoint];
    [context addLineToPoint:self.endPoint];
    return context;
}

@end