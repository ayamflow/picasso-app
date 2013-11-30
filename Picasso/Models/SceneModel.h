//
//  SceneModel.h
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SceneModel : NSObject

@property (assign, nonatomic) NSInteger number;
@property (strong, nonatomic) NSString *sceneId;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *videoType;
@property (assign, nonatomic) BOOL unlocked;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *trackers;
@property (strong, nonatomic) NSArray *trackerStarts;
@property (strong, nonatomic) NSString *description;

- (id)initWithData:(NSDictionary *)data;
- (void)unlockScene;

@end
