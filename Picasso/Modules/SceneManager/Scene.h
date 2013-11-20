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
#import "SceneManagerDelegate.h"

@interface Scene : UIViewController

@property (strong, nonatomic) SceneModel *model;
@property (strong, nonatomic) NSArray *trackersImage;
@property (weak, nonatomic) id<SceneManagerDelegate> delegate;

@property (strong, nonatomic) UILabel *sceneTitle;
@property (strong, nonatomic) UILabel *dateTitle;
@property (strong, nonatomic) UIImageView *dateImageView;

- (id)initWithModel:(SceneModel *)sceneModel;
- (id)initWithModel:(SceneModel *)sceneModel andPosition:(CGPoint)position;
- (void)stop;

@end
