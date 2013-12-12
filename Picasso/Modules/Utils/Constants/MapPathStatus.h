//
//  MapPathStatus.h
//  Picasso
//
//  Created by Florian Morel on 01/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapPathStatus : NSObject

+ (NSInteger)PathNotStartedStatus;
+ (NSInteger)PathStartedStatus;
+ (NSInteger)PathCompletedStatus;

@end
