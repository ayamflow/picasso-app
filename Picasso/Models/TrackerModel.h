//
//  TrackerModel.h
//  Picasso
//
//  Created by MOREL Florian on 29/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackerModel : NSObject

@property (strong, nonatomic) NSString *workId;
@property (strong, nonatomic) NSArray *positions;

- (id)initWithData:(NSDictionary *)data;

@end
