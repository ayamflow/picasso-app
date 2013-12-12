//
//  Path6View.m
//  Picasso
//
//  Created by Florian Morel on 01/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Path6View.h"
#import "MapPathStatus.h"

@implementation Path6View

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.startPoint = CGPointMake(407, 351);
        self.endPoint = CGPointMake(420,355);
    }
    return self;
}

- (UIBezierPath *)getStartPath {
    UIBezierPath* context =  [UIBezierPath bezierPath];
    [context moveToPoint: CGPointMake(407,351)];
    return context;
}

- (UIBezierPath *)getEndPath {
    UIBezierPath* context =  [UIBezierPath bezierPath];
    [context moveToPoint: CGPointMake(407,351)];
    [context addLineToPoint: CGPointMake(420,355)];
    return context;
}

@end

