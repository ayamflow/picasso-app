//
//  SceneModel.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "SceneModel.h"
#import "TrackerModel.h"
#import "DataManager.h"

@implementation SceneModel

- (id)initWithData:(NSDictionary *)data {
    if(self = [super init]) {
        self.date = data[@"date"];
        self.number = [data[@"number"] integerValue];
        self.sceneId = [NSString stringWithFormat:@"scene-%li", self.number + 1];
        self.unlocked = [data[@"unlocked"] boolValue];
        self.videoType = data[@"videoType"];
        self.title = data[@"title"];
        self.description = data[@"description"];
        
        NSArray *trackersData = data[@"trackers"];
        NSMutableArray *trackers = [[NSMutableArray alloc] initWithCapacity:[trackersData count]];
        for(int i = 0; i < [trackersData count]; i++) {
            TrackerModel *trackerModel = [[TrackerModel alloc] initWithData:[trackersData objectAtIndex:i]];
            [trackers addObject:trackerModel];
        }
        self.trackers = [[NSArray alloc] initWithArray:trackers];
        self.trackerStarts = data[@"trackerStarts"];
    }
    return self;
}

- (void)unlockScene {
    self.unlocked = YES;
    [[DataManager sharedInstance] unlockSceneWithNumber: self.number];
}

@end
