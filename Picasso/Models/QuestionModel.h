//
//  QuestionModel.h
//  Picasso
//
//  Created by RENARD Julian on 11/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject

@property (assign, nonatomic) NSInteger questionId;
@property (strong, nonatomic) NSString *question;
@property (strong, nonatomic) NSString *choice_1;
@property (strong, nonatomic) NSString *choice_2;
@property (strong, nonatomic) NSString *choice_correct;
@property (strong, nonatomic) NSString *explanation;

- (id)initWithData:(NSDictionary *)data;

@end