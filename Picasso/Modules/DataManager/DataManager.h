//
//  DataManager.h
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SceneModel.h"
#import "WorkModel.h"
#import "GameModel.h"

@interface DataManager : NSObject

@property (strong, nonatomic) NSArray *scenes;
@property (strong, nonatomic) NSArray *works;

+ (id)sharedInstance;

- (GameModel *)getGameModel;
- (SceneModel *)getSceneWithNumber:(NSInteger)number;
-(SceneModel *)getCurrentSceneModel;
- (WorkModel *)getWorkWithId:(NSString *)workId;
- (WorkModel *)getWorkWithNumber:(NSInteger)number;
- (void)unlockSceneTo:(NSInteger)number;
- (void)unlockSceneWithNumber:(NSInteger)number;
- (void)unlockWorkWithNumber:(NSInteger)number;
- (void)unlockWorkTo:(NSInteger)number;
- (NSInteger)getScenesNumber;
- (NSInteger)getWorksNumber;

@end
