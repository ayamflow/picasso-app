//
//  TrackerModel.m
//  Picasso
//
//  Created by MOREL Florian on 29/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "TrackerModel.h"

@implementation TrackerModel

- (id)initWithData:(NSDictionary *)data {
    if(self = [super init]) {
        self.workId = [data[@"workId"] integerValue];
        self.positions = data[@"positions"];
    }
    return self;
}

@end
