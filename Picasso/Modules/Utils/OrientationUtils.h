//
//  OrientationUtils.h
//  Picasso
//
//  Created by MOREL Florian on 30/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrientationUtils : NSObject

+ (int)deviceOrientation;
+ (CGRect)deviceSize;
+ (CGRect)nativeDeviceSize;
+ (CGRect)nativeLandscapeDeviceSize;
+ (BOOL)isRetina;
+ (NSInteger)screenScale;

@end
