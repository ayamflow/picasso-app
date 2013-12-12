//
//  LineDrawView.m
//  Picasso
//
//  Created by Hellopath on 03/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "LineDrawView.h"

@implementation LineDrawView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.8];
    UIBezierPath* context = [UIBezierPath bezierPath];
    
    [context moveToPoint: self.startPoint];
     [context addLineToPoint: self.endPoint];
    [strokeColor setStroke];
    [context stroke];
}

@end
