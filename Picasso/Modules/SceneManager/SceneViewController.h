//
//  SceneViewController.h
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MotionVideoPlayer.h"

@interface SceneViewController : UIViewController

@property (strong, nonatomic) MotionVideoPlayer *player;

- (void)initPlayerWithURL:(NSURL *)URL;

@end
