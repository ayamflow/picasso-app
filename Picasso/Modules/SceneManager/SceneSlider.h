//
//  SceneSlider.h
//  Picasso
//
//  Created by MOREL Florian on 30/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidingButtonDelegate.h"

@interface SceneSlider : UIViewController

@property (weak, nonatomic) id<SlidingButtonDelegate> delegate;
@property (assign, nonatomic) float sliderDistance;

- (id)initWithFrame:(CGRect)frame andAmplitude:(float)amplitude andThreshold:(float)threshold;

@end
