//
//  SceneSlider.h
//  Picasso
//
//  Created by MOREL Florian on 30/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SceneSlider : UIViewController

@property (assign, nonatomic) float sliderDistance;

- (id)initWithFrame:(CGRect)frame andAmplitude:(CGFloat)amplitude andThreshold:(CGFloat)threshold;

@end
