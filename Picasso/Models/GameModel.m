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
//        [self deletePList];
//        self.introCompleted = YES; // Uncomment to skip the intro
        [self load];
        [[DataManager sharedInstance] unlockSceneTo:self.lastUnlockedScene];
        if(self.lastUnlockedWork > -1) {
            [[DataManager sharedInstance] unlockWorkTo:self.lastUnlockedWork];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sceneUnlocked:) name:[MPPEvents SceneUnlockedEvent] object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(workUnlocked:) name:[MPPEvents WorkUnlockedEvent] object:nil];
    }
    return self;
}

- (void)sceneUnlocked:(NSNotification *)notification {
    NSInteger newUnlockedScene = [[notification.userInfo objectForKey:@"number"] integerValue];
    if(newUnlockedScene > self.lastUnlockedScene) {
        self.lastUnlockedScene = newUnlockedScene;
    }
}

- (void)workUnlocked:(NSNotification *)notification {
    NSInteger newUnlockedWork = [[notification.userInfo objectForKey:@"number"] integerValue];
    if(newUnlockedWork > self.lastUnlockedWork) {
        self.lastUnlockedWork = newUnlockedWork;
    }
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
        savedData = [NSArray arrayWithObjects: [NSNumber numberWithInteger: 0], [NSNumber numberWithInteger: 0], [NSNumber numberWithFloat: 0.0], [NSNumber numberWithInteger:-1], nil];
    }
    self.currentScene = [[savedData objectAtIndex:0] integerValue];
    self.lastUnlockedScene = [[savedData objectAtIndex:1] integerValue];
    self.sceneCurrentTime = [[savedData objectAtIndex:2] floatValue];
//    self.lastUnlockedWork = [[savedData objectAtIndex:3] integerValue];
    self.lastUnlockedWork = 5;
}

- (NSString *)getSavePlistPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:kSavePath];
}

- (void)deletePList {
    NSString *savePlist = [self getSavePlistPath];
    NSLog(@"[GameMdel] Delete plist");
    
    NSError *error;
    if(![[NSFileManager defaultManager] removeItemAtPath:savePlist error:&error])
    {
        NSLog(@"[GmeModel] No plist to delete");
    }
}

@end