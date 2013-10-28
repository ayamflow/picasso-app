//
//  ViewController.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "ViewController.h"
#import "DataManager.h"
#import "SceneViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Testing DataManager singleton
    DataManager *dataManager = [DataManager sharedInstance];
    
    SceneViewController *scene = [[SceneViewController alloc] init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"scene-1" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [scene initPlayerWithURL:url];
    [self.view addSubview:scene.view];
    scene.player.rate = 1.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
