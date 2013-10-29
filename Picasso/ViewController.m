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

@property (strong, nonatomic) SceneManager *sceneManager;
@property (strong, nonatomic) Timeline *timeline;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    
    // Init and launch sceneManager
    self.sceneManager = [[SceneManager alloc] init];
    [self.view addSubview:self.sceneManager.view];
    [self.sceneManager showSceneWithNumber:0];
    
    self.timeline = [[Timeline alloc] init];
    [self.view addSubview:self.timeline.view];
    self.timeline.delegate = self.sceneManager;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
