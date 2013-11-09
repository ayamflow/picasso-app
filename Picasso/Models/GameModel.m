//
//  GameModel.m
//  Picasso
//
//  Created by Florian Morel on 04/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel

+ (id)sharedInstance {
    static GameModel *sharedInstance = nil;
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}
- (id)init {
    if(self = [super init]) {
	    self.currentScene = 0;
        self.sceneCurrentTime = 0.0;
    }

    return self;
}

@end
