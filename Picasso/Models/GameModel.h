//
//  GameModel.h
//  Picasso
//
//  Created by Florian Morel on 04/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameModel : NSObject <NSCoding>

@property (assign, nonatomic) int currentScene;
@property (assign, nonatomic) int lastUnlockedScene;
@property (assign, nonatomic) float sceneCurrentTime;

+ (id)sharedInstance;
- (void)save;

@end
