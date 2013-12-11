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
#import "MotionVideoPlayerDelegate.h"

@interface Scene : UIViewController <UIGestureRecognizerDelegate, MotionVideoPlayerDelegate>

@property (strong, nonatomic) SceneModel *model;
@property (strong, nonatomic) NSArray *trackersImage;
@property (weak, nonatomic) id<SceneManagerDelegate> delegate;

- (id)initWithModel:(SceneModel *)sceneModel;
- (void)stop;
- (void)resume;

@end
