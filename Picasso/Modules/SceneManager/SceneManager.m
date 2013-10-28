//
//  SceneManager.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "SceneManager.h"

@interface SceneManager ()

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

- (void)createNewSceneWithData:(NSDictionary *)data {
    // update oldScene
    // create a new scene into *currentScene
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

// Protocol definition (catches messages from each SceneViewController

@protocol SceneDelegate <NSObject>

@required

- (void)showNextScene;

- (void)showPreviousScene;

@end