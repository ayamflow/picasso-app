//
//  SceneInterstitialViewController.h
//  Picasso
//
//  Created by MOREL Florian on 29/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneSlider.h"

@interface SceneInterstitial : UIViewController

@property (strong, nonatomic) SceneSlider *slidingButton;

- (id)initWithDescription:(NSString *)description;

@end
