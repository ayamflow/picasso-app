//
//  SceneModel.h
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SceneModel : NSObject

@property (assign, nonatomic) int number;
@property (strong, nonatomic) NSString *sceneId;
@property (strong, nonatomic) NSString *videoType;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *trackers;
@property (strong, nonatomic) NSString *description;

- (id)initWithData:(NSDictionary *)data;

@end
