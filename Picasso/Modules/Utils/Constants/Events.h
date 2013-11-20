//
//  Events.h
//  Picasso
//
//  Created by Hellopath on 19/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPPEvents : NSObject

+ (NSString *)ResetSliderEvent;
+ (NSString *)SliderHasMovedEvent;
+ (NSString *)UpdateRotationEvent;
+ (NSString *)SceneUnlockedEvent;
+ (NSString *)MenuShownEvent;

+ (NSString *)TransitionInCompleteEvent;
+ (NSString *)TransitionOutCompleteEvent;

@end