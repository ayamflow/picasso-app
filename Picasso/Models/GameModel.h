//
//  GameModel.h
//  Picasso
//
//  Created by Florian Morel on 04/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameModel : NSObject

@property (assign, nonatomic) NSInteger currentScene;
@property (assign, nonatomic) NSInteger lastUnlockedScene;
@property (assign, nonatomic) float sceneCurrentTime;

+ (id)sharedInstance;
- (void)save;

@end
