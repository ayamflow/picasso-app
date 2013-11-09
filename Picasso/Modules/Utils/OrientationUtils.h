//
//  OrientationUtils.h
//  Picasso
//
//  Created by MOREL Florian on 30/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>

static int Landscape = 0;
static int Portrait = 1;

@interface OrientationUtils : NSObject

+ (int)deviceOrientation;
+ (CGRect)deviceSize;
+ (CGRect)nativeDeviceSize;
+ (CGRect)nativeLandscapeDeviceSize;

@end
