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
#import "QuestionModel.h"

@interface DataManager : NSObject

@property (strong, nonatomic) NSArray *scenes;
@property (strong, nonatomic) NSArray *works;
@property (strong, nonatomic) NSArray *questions;

+ (id)sharedInstance;

- (GameModel *)getGameModel;
- (SceneModel *)getSceneWithNumber:(NSInteger)number;
-(SceneModel *)getCurrentSceneModel;
- (NSMutableArray *)getWorksWithScene:(NSInteger)sceneNumber;
- (WorkModel *)getWorkWithId:(NSString *)workId;
- (WorkModel *)getWorkWithNumber:(NSInteger)number;
- (QuestionModel *)getRandomQuestion;
- (void)unlockSceneTo:(NSInteger)number;
- (void)unlockSceneWithNumber:(NSInteger)number;
- (void)unlockWorkWithNumber:(NSInteger)number;
- (void)unlockWorkTo:(NSInteger)number;
- (NSInteger)getScenesNumber;
- (NSInteger)getWorksNumber;

@end
