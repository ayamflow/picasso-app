//
//  GameModel.m
//  Picasso
//
//  Created by Florian Morel on 04/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "GameModel.h"
#import "DataManager.h"

#define kSaveExists @"saveExists"
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
        if([self checkIfSaveExists]) {
            [self load];
            [[DataManager sharedInstance] unlockSceneTo:self.lastUnlockedScene];
            NSLog(@"[GameModel] save exists-> currentScene: %i, lastUnlockedScene: %i, sceneCurrentTime: %f", self.currentScene, self.lastUnlockedScene, self.sceneCurrentTime);
        }
        else {
            NSLog(@"[GameModel] save doesn't exist");
			self.currentScene = 0;
            self.lastUnlockedScene = 0;
            self.sceneCurrentTime = 0;
        }
    }

    return self;
}

- (id)initWithCurrentScene:(int)currentScene andLastUnlockedScene:(int)unlockedScene andSceneCurrentTime:(float)currentTime {
    if(self = [super init]) {
        self.currentScene = currentScene;
        self.sceneCurrentTime = currentTime;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeInt:self.currentScene forKey:kCurrentScene];
	[aCoder encodeInt:self.lastUnlockedScene forKey:kLastUnlockedScene];
    [aCoder encodeFloat:self.sceneCurrentTime forKey:kSceneCurrentTime];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	int currentScene = [aDecoder decodeIntForKey:kCurrentScene];
	int lastUnlockedScene = [aDecoder decodeIntForKey:kLastUnlockedScene];
    float currentTime = [aDecoder decodeFloatForKey:kSceneCurrentTime];
    return [self initWithCurrentScene:currentScene andLastUnlockedScene:lastUnlockedScene andSceneCurrentTime:currentTime];
}

- (void)save {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:kSaveExists];
    [userDefaults setInteger:self.currentScene forKey:kCurrentScene ];
    [userDefaults setInteger:self.lastUnlockedScene forKey:kLastUnlockedScene];
    [userDefaults setFloat:self.sceneCurrentTime forKey:kSceneCurrentTime];
    [userDefaults synchronize];
}

- (void)load {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.currentScene = [userDefaults integerForKey:kCurrentScene];
    self.lastUnlockedScene = [userDefaults integerForKey:kLastUnlockedScene];
    self.sceneCurrentTime = [userDefaults floatForKey:kSceneCurrentTime];
}

- (BOOL)checkIfSaveExists {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSaveExists];
}

@end
