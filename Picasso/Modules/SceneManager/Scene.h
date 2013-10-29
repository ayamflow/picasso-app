//
//  SceneViewController.h
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MotionVideoPlayer.h"
#import "SceneModel.h"
#import "SceneManaging.h"

@interface Scene : UIViewController

@property (strong, nonatomic) MotionVideoPlayer *player;
@property (strong, nonatomic) SceneModel *model;
@property (strong, nonatomic) NSArray *trackersImage;
@property (weak, nonatomic) id<SceneManaging> delegate;

- (id)initWithModel:(SceneModel *)sceneModel;
//- (void)initPlayerWithURL:(NSURL *)URL;
- (void)stop;

@end
