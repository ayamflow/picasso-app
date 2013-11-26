//
//  WorkModel.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "WorkModel.h"

@implementation WorkModel

- (id)initWithData:(NSDictionary *)data {
    
    self.workId = data[@"id"];
    self.title = data[@"title"];
    self.description = data[@"description"];
    self.year = data[@"year"];
    self.h = data[@"h"];
    self.l = data[@"l"];
    self.technical = data[@"technical"];
    
    return [super init];
}

@end
