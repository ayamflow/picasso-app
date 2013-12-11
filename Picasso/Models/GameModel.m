//
//  GameModel.m
//  Picasso
//
//  Created by Florian Morel on 04/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "GameModel.h"
#import "DataManager.h"
#import "Events.h"

#define kSavePath @"PicassoSave.plist"

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
//        NSLog(@"[GameModel] init");
        [self load];
        [[DataManager sharedInstance] unlockSceneTo:self.lastUnlockedScene];
        [[DataManager sharedInstance] unlockWorkTo:self.lastUnlockedWork];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sceneUnlocked:) name:[MPPEvents SceneUnlockedEvent] object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(workUnlocked:) name:[MPPEvents WorkUnlockedEvent] object:nil];
    }
    return self;
}

- (void)sceneUnlocked:(NSNotification *)notification {
    self.lastUnlockedScene = [[notification.userInfo objectForKey:@"number"] integerValue];
}

- (void)workUnlocked:(NSNotification *)notification {
    self.lastUnlockedWork = [[notification.userInfo objectForKey:@"number"] integerValue];
}

- (void)save {
    NSString *savePlist = [self getSavePlistPath];

    NSArray *savedData = [NSArray arrayWithObjects: [NSNumber numberWithInteger: self.currentScene], [NSNumber numberWithInteger: self.lastUnlockedScene], [NSNumber numberWithFloat: self.sceneCurrentTime], [NSNumber numberWithInteger:self.lastUnlockedWork], nil];
    [savedData writeToFile:savePlist atomically:YES];
}

- (void)load {
    NSString *savePlist = [self getSavePlistPath];

    NSArray *savedData = [NSArray arrayWithContentsOfFile:savePlist];
    if(savedData == nil || [savedData count] < 4) {
        savedData = [NSArray arrayWithObjects: [NSNumber numberWithInteger: 0], [NSNumber numberWithInteger: 0], [NSNumber numberWithFloat: 0.0], [NSNumber numberWithInteger:0], nil];
    }
    self.currentScene = [[savedData objectAtIndex:0] integerValue] || 0;
    self.lastUnlockedScene = [[savedData objectAtIndex:1] integerValue] || 0;
    self.sceneCurrentTime = [[savedData objectAtIndex:2] floatValue] || 0.0;
    self.lastUnlockedWork = [[savedData objectAtIndex:3] integerValue] || 0;
}

- (NSString *)getSavePlistPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:kSavePath];
}

@end
