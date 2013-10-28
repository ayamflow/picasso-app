//
//  DataManager.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "DataManager.h"

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
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSData *picassoData = [[NSData alloc] initWithContentsOfURL:url];
    NSError *error;
    NSDictionary *picassoDictionnary = [NSJSONSerialization JSONObjectWithData:picassoData options:kNilOptions error:&error];
    if(error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    else {
        self.scenes = picassoDictionnary[@"scenes"];
        self.works = picassoDictionnary[@"works"];
    }
    return [super init];
}

/* API */

- (SceneModel *)getSceneWithId:(NSString *)sceneId {
    NSDictionary *scene;
    for(int i = 0; i < [self.scenes count]; i++) {
        scene = [self.scenes objectAtIndex:i];
        if([[scene valueForKey:@"sceneId"] isEqualToString:sceneId]) {
            return [[SceneModel alloc] initWithData:scene];
        }
    }
    return nil;
}

- (WorkModel *)getWorkWithId:(NSString *)workId {
    NSDictionary *work;
    for(int i = 0; i < [self.works count]; i++) {
        work = [self.works objectAtIndex:i];
        if([[work valueForKey:@"workId"] isEqualToString:workId]) {
            return [[WorkModel alloc] initWithData:work];
        }
    }
    return nil;
}

@end
