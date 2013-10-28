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
#import "Timeline.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Init and launch sceneManager
    SceneManager *sceneManager = [[SceneManager alloc] init];
    [self.view addSubview:sceneManager.view];
    [sceneManager showSceneWithNumber:0];
    
    Timeline *timeline = [[Timeline alloc] init];
    [self.view addSubview:timeline.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
