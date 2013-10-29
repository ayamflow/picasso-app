//
//  SceneManaging.h
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SceneManaging <NSObject>

@required

- (void)showNextScene;
- (void)showPreviousScene;
- (void)showSceneWithNumber:(int)number;
- (void)fadeCurrentSceneToBlack;

@end
