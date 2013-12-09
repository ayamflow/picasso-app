//
//  SceneInterstitialViewController.h
//  Picasso
//
//  Created by MOREL Florian on 29/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneSlider.h"
#import "SceneModel.h"

@interface SceneInterstitial : UIViewController

@property (strong, nonatomic) SceneSlider *slidingButton;

- (id)initWithModel:(SceneModel *)sceneModel;

@end
