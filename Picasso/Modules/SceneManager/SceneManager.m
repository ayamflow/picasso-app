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

@interface SceneManager ()

@property (strong, nonatomic) Scene *oldScene;
@property (strong, nonatomic) Scene *currentScene;

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
}

- (void)createNewSceneWithData:(SceneModel *)sceneModel {
    // update oldScene
    if(self.currentScene) {
        [self.currentScene.view removeFromSuperview];
        self.oldScene =  self.currentScene;
    }
    // create a new scene into *currentScene
    self.currentScene = [[Scene alloc] initWithModel:sceneModel];
    self.currentScene.delegate = self;
    [self.view addSubview:self.currentScene.view];
}

- (void)showNextScene {
    NSLog(@"Show next scene");
}

- (void)showPreviousScene {
    NSLog(@"Show previous scene");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end