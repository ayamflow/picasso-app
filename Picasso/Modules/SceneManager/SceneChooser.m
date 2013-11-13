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
#import "OrientationUtils.h"
#import "OpacityTransition.h"
#import "MenuButton.h"

@interface SceneChooser ()

@property (strong, nonatomic) NSArray *sceneButtons;
@property (strong, nonatomic) MenuButton *menuButton;

@end

@implementation SceneChooser

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"init with nib name");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor clearColor];
    [self rotateToLandscapeOrientation];

    [self initTitle];
    [self initButtons];
    [self initMenu];
}

- (void)initTitle {
    self.titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-bold" size:15.0];
    self.titleLabel.layer.borderColor = [UIColor textColor].CGColor;
    self.titleLabel.layer.borderWidth = 2.0;
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.size = CGSizeMake(self.titleLabel.frame.size.width + 25.0, 42.0);
    self.titleLabel.frame = titleFrame;
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    float leftPosition = ([OrientationUtils nativeDeviceSize].size.height - self.titleImage.frame.size.width - self.titleLabel.frame.size.width - 10.0) / 2 + self.titleImage.frame.size.width / 2;
    float topPosition = 90.0;
    self.titleImage.layer.position = CGPointMake(leftPosition, topPosition);
    self.titleLabel.layer.position = CGPointMake(leftPosition + self.titleImage.frame.size.width * 3 + 10.0, topPosition);
}

- (void)initMenu {
    self.menuButton = [[MenuButton alloc] initWithExploreMode:YES andPosition:CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - self.menuButton.view.frame.size.width / 2, self.menuButton.view.frame.size.height)];
    [self addChildViewController:self.menuButton];
    [self.view addSubview:self.menuButton.view];
    [self.view bringSubviewToFront:self.menuButton.view];
}

- (void)initButtons {
    DataManager *dataManager = [DataManager sharedInstance];
    NSInteger scenesNumber = [dataManager getScenesNumber];

    NSMutableArray *tempButtonsArray = [[NSMutableArray alloc] initWithCapacity:scenesNumber];

    float buttonSize = 42.0;
    float buttonMargin = 10.0;
    float leftPosition = ([OrientationUtils nativeLandscapeDeviceSize].size.width - scenesNumber * buttonSize - (scenesNumber - 1) * buttonMargin) / 2;
    
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
        else {
            sceneButton.tag = i;
            [sceneButton addTarget:self action:@selector(sceneButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        }
        [sceneButton setFrame:CGRectMake(leftPosition + i * (buttonSize + buttonMargin), 195.0, buttonSize, buttonSize)];
        [self.view addSubview:sceneButton];
        [tempButtonsArray addObject:sceneButton];
    }

    self.sceneButtons = [NSArray arrayWithArray:tempButtonsArray];
}

-(void)sceneButtonTouched:(id)sender {
    [[DataManager sharedInstance] getGameModel].currentScene = [sender tag];

    SceneManager *sceneManager = [self.storyboard instantiateViewControllerWithIdentifier:@"SceneManager"];
    [self.navigationController.view.layer addAnimation:[OpacityTransition getOpacityTransition] forKey:kCATransition];
    [self.navigationController pushViewController:sceneManager animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
