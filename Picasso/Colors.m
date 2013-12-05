//
//  Colors.m
//  Picasso
//
//  Created by Hellopath on 19/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Colors.h"

@implementation UIColor (Picasso)

+ (UIColor *)backgroundColor {
    return [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
}

+ (UIColor *)textColor {
    return [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
}

+ (UIColor *)lightColor {
    return [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.0];
}

+ (UIColor *)darkColor {
    return [UIColor colorWithRed:0.07 green:0.07 blue:0.07 alpha:1.0];
}

+ (UIColor *)darkerColor {
    return [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:1.0];
}

+ (UIColor *)sliderColor {
    return [UIColor colorWithRed:0.25 green:0.30 blue:0.37 alpha:1.0];
}

@end