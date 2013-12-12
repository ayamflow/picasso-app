//
//  WorkModel.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "WorkModel.h"
#import "DataManager.h"

@implementation WorkModel

- (id)initWithData:(NSDictionary *)data {
    
    self.workId = [data[@"id"] integerValue];
    self.title = data[@"title"];
    self.description = data[@"description"];
    self.sceneNumber = [data[@"sceneNumber"] integerValue];
    self.year = data[@"year"];
    self.h = data[@"h"];
    self.l = data[@"l"];
    self.technical = data[@"technical"];
    self.unlocked = NO;
    
    return [super init];
}

- (void)unlockWork {
    self.unlocked = YES;
    [[DataManager sharedInstance] unlockWorkWithNumber:self.workId];
}

@end