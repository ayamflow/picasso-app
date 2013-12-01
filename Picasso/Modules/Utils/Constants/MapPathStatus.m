//
//  MapPathStatus.m
//  Picasso
//
//  Created by Florian Morel on 01/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "MapPathStatus.h"

@implementation MapPathStatus

+ (NSInteger)PathNotStartedStatus {
    return 0;
}

+ (NSInteger)PathStartedStatus {
    return 1;
}

+ (NSInteger)PathCompletedStatus {
    return 2;
}

@end
