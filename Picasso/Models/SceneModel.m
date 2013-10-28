//
//  SceneModel.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "SceneModel.h"

@implementation SceneModel

- (id)initWithData:(NSDictionary *)data {

    self.sceneId = data[@"sceneId"];
    self.number = [data[@"number"] integerValue];
    self.videoType = data[@"videoType"];
    self.title = data[@"title"];
    self.trackers = data[@"trackers"];
    self.description = data[@"description"];
    
    return [super init];
}


@end
