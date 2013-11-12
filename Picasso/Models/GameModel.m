//
//  GameModel.m
//  Picasso
//
//  Created by Florian Morel on 04/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "GameModel.h"
#import "DataManager.h"
#import "Constants.h"

#define kSavePath @"PicassoSave.plist"
#define kCurrentScene @"currentScene"
#define kLastUnlockedScene @"lastUnlockedScene"
#define kSceneCurrentTime @"sceneCurrentTime"

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
        NSLog(@"[GameModel] init");
        [self load];
        [[DataManager sharedInstance] unlockSceneTo:self.lastUnlockedScene];
//        NSLog(@"[GameModel] save loaded -> currentScene: %li, lastUnlockedScene: %li, sceneCurrentTime: %f", self.currentScene, (long)self.lastUnlockedScene, self.sceneCurrentTime);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sceneUnlocked:) name:[MPPEvents SceneUnlockedEvent] object:nil];
    }

    return self;
}

- (void)sceneUnlocked:(NSNotification *)notification {
    self.lastUnlockedScene = [[notification.userInfo objectForKey:@"number"] integerValue];
}

- (void)save {
    NSString *savePlist = [self getSavePlistPath];

    NSArray *savedData = [NSArray arrayWithObjects: [NSNumber numberWithInteger: self.currentScene], [NSNumber numberWithInteger: self.lastUnlockedScene], [NSNumber numberWithFloat: self.sceneCurrentTime ], nil];
    [savedData writeToFile:savePlist atomically:YES];
}

- (void)load {
    NSString *savePlist = [self getSavePlistPath];

    NSArray *savedData = [NSArray arrayWithContentsOfFile:savePlist];
    self.currentScene = [[savedData objectAtIndex:0] integerValue] || 0;
    self.lastUnlockedScene = [[savedData objectAtIndex:1] integerValue] || 0;
    self.sceneCurrentTime = [[savedData objectAtIndex:2] floatValue] || 0.0;
}

- (NSString *)getSavePlistPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:kSavePath];
}

@end
