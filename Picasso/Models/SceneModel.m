//
//  SceneModel.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "SceneModel.h"
#import "TrackerModel.h"

@implementation SceneModel

- (id)initWithData:(NSDictionary *)data {
    if(self = [super init]) {
        self.sceneId = data[@"sceneId"];
        self.number = [data[@"number"] integerValue];
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
    }
    return self;
}

@end
