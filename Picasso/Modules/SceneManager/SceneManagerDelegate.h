//
//  SceneManaging.h
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SceneManagerDelegate <NSObject>

@required

- (void)showNextScene;
- (void)showPreviousScene;
- (void)showSceneWithNumber:(NSInteger)number;
- (void)showInterstitial;

@end
