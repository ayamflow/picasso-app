//
//  QuestionModel.m
//  Picasso
//
//  Created by RENARD Julian on 11/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "QuestionModel.h"

@implementation QuestionModel

- (id)initWithData:(NSDictionary *)data {
    self.questionId = [data[@"id"] integerValue];
    self.question = data[@"question"];
    self.choice_1 = data[@"choice_1"];
    self.choice_2 = data[@"choice_2"];
    
    return [super init];
}

@end