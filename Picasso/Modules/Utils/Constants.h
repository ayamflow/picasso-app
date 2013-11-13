//
//  Constants.h
//  Picasso
//
//  Created by Hellopath on 08/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (Picasso)

// Colors
+ (UIColor *)backgroundColor;
+ (UIColor *)textColor;
+ (UIColor *)lightColor;
+ (UIColor *)darkColor;
+ (UIColor *)sliderColor;

@end

@interface MPPEvents : NSObject

+ (NSString *)ResetSliderEvent;
+ (NSString *)SliderHasMovedEvent;
+ (NSString *)UpdateRotationEvent;
+ (NSString *)SceneUnlockedEvent;
+ (NSString *)MenuShownEvent;

@end

@interface UINavigationController (Picasso)

- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;

@end

@interface UIViewController (Picasso)

- (void)rotateToLandscapeOrientation;
- (void)showMenuWithExploreMode:(BOOL)isExploreMode andSceneMode:(BOOL)isSceneMode;

@end