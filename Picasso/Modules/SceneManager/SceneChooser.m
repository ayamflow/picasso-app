//
//  SceneChooserViewController.m
//  Picasso
//
//  Created by MOREL Florian on 31/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "SceneChooser.h"
#import "DataManager.h"
#import "SceneManager.h"
#import "Constants.h"

@interface SceneChooser ()



@end

@implementation SceneChooser

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
	self.view.backgroundColor = [UIColor clearColor];
    [self initButtons];
}

- (void)initButtons {
    DataManager *dataManager = [DataManager sharedInstance];
    int scenesNumber = [dataManager getScenesNumber];

    for(int i = 0; i < scenesNumber; i++) {
        SceneModel *sceneModel = [dataManager getSceneWithNumber:i];
        UIButton *sceneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        sceneButton.layer.cornerRadius = 0.0;
        sceneButton.layer.borderWidth = 2.0;
        sceneButton.layer.borderColor = [UIColor textColor].CGColor;
        sceneButton.titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Bold" size:15.0];
        [sceneButton setTitle:[NSString stringWithFormat:@"%i", i + 1] forState:UIControlStateNormal];
        [sceneButton setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
        if(!sceneModel.unlocked) {
            sceneButton.alpha = 0.2;
        }
        [sceneButton setFrame:CGRectMake(i * 62, 250, 42, 42)];
        sceneButton.tag = i;
        [sceneButton addTarget:self action:@selector(sceneButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:sceneButton];
    }
}

-(void)sceneButtonTouched:(id)sender {
    [[DataManager sharedInstance] getGameModel].currentScene = [sender tag];

    SceneManager *scene = [self.storyboard instantiateViewControllerWithIdentifier:@"SceneManager"];
    [self.navigationController pushViewController:scene animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
