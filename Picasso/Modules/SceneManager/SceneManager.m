//
//  SceneManager.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "SceneManager.h"
#import "Scene.h"
#import "SceneModel.h"
#import "DataManager.h"

@interface SceneManager ()

@property (strong, nonatomic) Scene *oldScene;
@property (strong, nonatomic) Scene *currentScene;
@property (assign, nonatomic) int currentSceneId;
@property (assign, nonatomic) int scenesNumber;

@end

@implementation SceneManager

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    DataManager *dataManager = [DataManager sharedInstance];
    self.scenesNumber = [dataManager getScenesNumber];
    
    // Auto launch if needed
//    [self showSceneWithNumber:0];
}

- (void)showSceneWithNumber:(int)number {
    DataManager *dataManager = [DataManager sharedInstance];
    SceneModel *sceneModel = [dataManager getSceneWithNumber:number];
    
    // update oldScene
    if(self.currentScene) {
        [self.currentScene.view removeFromSuperview];
        self.oldScene =  self.currentScene;
    }
    // create a new scene into *currentScene
    self.currentScene = [[Scene alloc] initWithModel:sceneModel];
    self.currentSceneId = self.currentScene.model.number;
    self.currentScene.delegate = self;
    [self.view addSubview:self.currentScene.view];
}

- (NSString *)getSceneIdFormat:(int)number {
    return [NSString stringWithFormat:@"scene-%i", number];
}
    
- (void)showNextScene {
    NSLog(@"Show next scene");
    int nextSceneId = self.currentSceneId < self.scenesNumber ? self.currentSceneId + 1 : 0;
    [self showSceneWithNumber:nextSceneId];
}

- (void)showPreviousScene {
    NSLog(@"Show previous scene");
    int previousSceneId = self.currentSceneId > 0 ? self.currentSceneId - 1 : self.scenesNumber - 1;
    [self showSceneWithNumber:previousSceneId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end