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

@interface DataManager : NSObject

@property (strong, nonatomic) NSArray *scenes;
@property (strong, nonatomic) NSArray *works;

+ (id)sharedInstance;

- (SceneModel *)getSceneWithId:(NSString *)sceneId;
- (SceneModel *)getSceneWithNumber:(int)number;
- (WorkModel *)getWorkWithId:(NSString *)workId;
- (int)getScenesNumber;
- (int)getWorksNumber;

@end
