//
//  SceneManager.h
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneModel.h"
#import "Scene.h"
#import "SceneManagerDelegate.h"

@interface SceneManager : UIViewController <SceneManagerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) Scene *currentScene;
@property (assign, nonatomic) BOOL shouldResume;

@end
