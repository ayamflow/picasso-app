//
//  ViewController.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "ViewController.h"
#import "DataManager.h"
#import "SceneManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Getting first scene
    DataManager *dataManager = [DataManager sharedInstance];
    SceneModel *startScene = [dataManager getSceneWithId:@"scene-1"];

    // Init and launch sceneManager
    SceneManager *sceneManager = [[SceneManager alloc] init];
    [self.view addSubview:sceneManager.view];
    [sceneManager createNewSceneWithData:startScene];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
