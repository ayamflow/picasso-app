//
//  Events.m
//  Picasso
//
//  Created by Hellopath on 19/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Events.h"

@implementation MPPEvents

+ (NSString *)ResetSliderEvent {
    return @"resetSlider";
}

+ (NSString *)SliderHasMovedEvent {
    return @"sliderHasMoved";
}

+ (NSString *)SceneUnlockedEvent {
    return @"sceneUnlocked";
}

+ (NSString *)UpdateRotationEvent {
    return @"updateRotation";
}

+ (NSString *)MenuShownEvent {
    return @"menuShown";
}

+ (NSString *)TransitionInCompleteEvent {
    return @"transitionInComplete";
}

+ (NSString *)TransitionOutCompleteEvent {
    return @"transitionOutComplete";
}

+ (NSString *)MenuExitEvent {
    return @"exitMenu";
}

+ (NSString *)BackToHomeEvent {
    return @"backToHome";
}

+ (NSString *)ShowSceneChooserEvent {
    return @"showSceneChooser";
}

+ (NSString *)SkipInterstitialEvent {
    return @"skipInterstitial";
}


@end