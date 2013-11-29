//
//  WorkModel.h
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkModel : NSObject

@property (strong, nonatomic) NSString *workId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *year;
@property (strong, nonatomic) NSString *h;
@property (strong, nonatomic) NSString *l;
@property (strong, nonatomic) NSString *technical;

- (id)initWithData:(NSDictionary *)data;

@end
