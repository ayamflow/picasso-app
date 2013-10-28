//
//  SceneManager.h
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneModel.h"
#import "SceneManaging.h"

@interface SceneManager : UIViewController <SceneManaging>

- (void)createNewSceneWithData:(SceneModel *)sceneModel;

@end
