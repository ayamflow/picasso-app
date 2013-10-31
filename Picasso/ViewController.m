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
#import "SceneInterstitial.h"
#import "Menu.h"

@interface ViewController ()

@property (strong, nonatomic) SceneManager *sceneManager;
@property (strong, nonatomic) Timeline *timeline;
@property (strong, nonatomic) Menu *menu;

@property (assign, nonatomic) BOOL menuShown;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    /* TODO */
    /*
     1- show splash
     2- show menu
     3- link menu to each section
     */
    
    self.menuShown = NO;
    self.view.backgroundColor = [UIColor blackColor];
    
    // Init and launch sceneManager
/*    self.sceneManager = [[SceneManager alloc] init];
    [self.view addSubview:self.sceneManager.view];
    [self.sceneManager showSceneWithNumber:0];
    
    [self createMenu];
 */
}

- (void)createMenu {
    if(self.menu == nil) {
        self.menu = [[Menu alloc] init];
        [self.view addSubview:self.menu.view];
        
//        [self addChildViewController:self.menu];
//        [self.menu didMoveToParentViewController:self];
        
        self.menu.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.menuShown = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
