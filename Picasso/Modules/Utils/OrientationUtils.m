//
//  OrientationUtils.m
//  Picasso
//
//  Created by MOREL Florian on 30/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "OrientationUtils.h"

@implementation OrientationUtils

static int Landscape = 0;
static int Portrait = 1;

+ (int)deviceOrientation {
    return [[UIApplication sharedApplication] statusBarOrientation] <= 1 ? Portrait : Landscape;
}

+ (CGRect)deviceSize {
    CGRect window = [[UIScreen mainScreen] bounds];
    if ([self deviceOrientation] == Landscape) {
        return CGRectMake(0, 0, window.size.height, window.size.width);
    }
    // else if Portrait
    return window;
}

+ (CGRect)nativeDeviceSize {
    return[[UIScreen mainScreen] bounds];
}

+ (CGRect)nativeLandscapeDeviceSize {
    CGRect window = [[UIScreen mainScreen] bounds];
    return CGRectMake(0, 0, window.size.height, window.size.width);
}

@end
