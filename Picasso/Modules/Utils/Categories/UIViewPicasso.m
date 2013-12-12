//
//  UIViewPicasso.m
//  Picasso
//
//  Created by Hellopath on 20/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "UIViewPicasso.h"

@implementation UIView (Picasso)

- (void)moveTo:(CGPoint)point {
    CGRect frame = self.frame;
    frame.origin = point;
    self.frame = frame;
}

@end
