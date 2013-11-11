//
//  DataManager.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "DataManager.h"
#import "GameModel.h"
#import "Constants.h"

@interface DataManager ()

@property (strong, nonatomic) NSArray *scenes;
@property (strong, nonatomic) NSArray *works;

@end

@implementation DataManager

+ (id)sharedInstance {
    static DataManager *sharedInstance = nil;
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

- (id)init {
    if(self = [super init]) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        NSData *picassoData = [[NSData alloc] initWithContentsOfURL:url];
        NSError *error;
        NSDictionary *picassoDictionnary = [NSJSONSerialization JSONObjectWithData:picassoData options:kNilOptions error:&error];
        if(error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSArray *scenes = picassoDictionnary[@"scenes"];
            NSInteger scenesNumber = [scenes count];
			NSMutableArray *scenesArray = [[NSMutableArray alloc] initWithCapacity:scenesNumber];

            NSArray *works = picassoDictionnary[@"works"];
            NSInteger worksNumber = [works count];
			NSMutableArray *worksArray = [[NSMutableArray alloc] initWithCapacity:worksNumber];

            for(int i = 0; i < scenesNumber; i++) {
                SceneModel *scene = [[SceneModel alloc] initWithData:[scenes objectAtIndex:i]];
                [scenesArray addObject:scene];

                WorkModel *work = [[WorkModel alloc] initWithData:[works objectAtIndex:i]];
                [worksArray addObject:work];
            }

            self.scenes = [NSArray arrayWithArray:scenesArray];
            self.works = [NSArray arrayWithArray:worksArray];
        }
    }
    return self;
}

/* API */

- (GameModel *)getGameModel {
	return [GameModel sharedInstance];
}

- (SceneModel *)getSceneWithNumber:(NSInteger) number {
    return [self.scenes objectAtIndex:number];
}

- (void)unlockSceneTo:(NSInteger)number {
	for(int i = 0; i < number; i++) {
		[self unlockSceneWithNumber:i];
    }
}

- (void)unlockSceneWithNumber:(NSInteger)number {
    SceneModel *scene = [self.scenes objectAtIndex:number];
    NSDictionary *unlockedSceneDictionnary = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:number] forKey:@"number"];
	[[NSNotificationCenter defaultCenter] postNotificationName:[MPPEvents SceneUnlockedEvent] object:self userInfo:unlockedSceneDictionnary];
    scene.unlocked = YES;
}

-(SceneModel *)getCurrentSceneModel {
    NSInteger currentScene = [[GameModel sharedInstance] currentScene];
    return [self.scenes objectAtIndex:currentScene];
}


- (NSInteger)getScenesNumber {
    return [self.scenes count];
}

- (WorkModel *)getWorkWithNumber:(NSInteger) number {
    return [self.works objectAtIndex:number];
}

- (WorkModel *)getWorkWithId:(NSString *)workId {
    WorkModel *work;
    for(int i = 0; i < [self.works count]; i++) {
        work = [self.works objectAtIndex:i];
        if([work.workId isEqualToString:workId]) {
            return work;
        }
    }
    return nil;
}

- (NSInteger)getWorksNumber {
    return [self.works count];
}

@end
