//
//  MenuViewController.m
//  Picasso
//
//  Created by MOREL Florian on 30/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "SceneManager.h"
#import "Menu.h"
#import "OrientationUtils.h"
#import "Timeline.h"
#import "DataManager.h"
#import "SceneChooser.h"

#define BUTTON_HEIGHT 30

@interface Menu ()

@property (strong, nonatomic) UIImageView *logo;
@property (strong, nonatomic) UIColor *textColor;
//@property (strong, nonatomic) Timeline *timeline;
@property (strong, nonatomic) UIView *timeline;
@property (strong, nonatomic) UIView *progressBar;

@end

@implementation Menu

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
    self.textColor = [UIColor colorWithRed:0.44 green:0.44 blue:0.44 alpha:1.0];
    
    [self initLogo];
    [self initButtons];
//    [self initTimeline];
}

- (void)initLogo {
    CGRect screenSize = [OrientationUtils deviceSize];
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    self.logo = [[UIImageView alloc] initWithImage:logoImage];
    [self.logo setCenter:CGPointMake(screenSize.size.width / 2, self.logo.frame.size.height)];
    [self.view addSubview:self.logo];
}

- (void)initButtons {
    [self.backButton addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.exploreButton addTarget:self action:@selector(navigateToExploreMode) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initTimeline {
    CGRect screenSize = [OrientationUtils deviceSize];
    
    // Old Timeline with specified class (broken frame, see below)
/*    self.timeline = [[Timeline alloc] init];
    [self.timeline.view setCenter:CGPointMake(screenSize.size.width / 2, screenSize.size.height - BUTTON_HEIGHT * 1.5)];
    [self.view addSubview:self.timeline.view];*/
    
    DataManager *dataManager = [DataManager sharedInstance];
    NSInteger scenesNumber = [dataManager getScenesNumber];
    NSInteger spaceBetweenScenes = 20;
    
    // Create progress bar first
    self.progressBar = [[UIView alloc] initWithFrame:CGRectMake(screenSize.size.width / 2 - (scenesNumber * spaceBetweenScenes) / 2 - 4, screenSize.size.height - BUTTON_HEIGHT * 1.5 + 11, (scenesNumber - 1) * (22 + spaceBetweenScenes), 2)];
    [self.view addSubview: self.progressBar];
    [self.progressBar setBackgroundColor:[UIColor blackColor]];
    
    // Then the timeline itself
    
    NSMutableArray *scenes = [[NSMutableArray alloc] initWithCapacity:scenesNumber];
    NSString *path = [[NSBundle mainBundle] pathForResource: @"timeline-button" ofType: @"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    
    self.timeline = [[UIView alloc] initWithFrame:screenSize];
    
    for(int i = 0; i < scenesNumber; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(touchEnded:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(i * spaceBetweenScenes, 0, image.size.width, image.size.height)];
        [button setTag:i];
        [self.timeline addSubview:button];
        [scenes addObject:button];
    }
    
    UIButton *refButton = [scenes objectAtIndex:0];
    [self.timeline setFrame:CGRectMake(screenSize.size.width / 2 - (scenesNumber * spaceBetweenScenes) / 2, screenSize.size.height - BUTTON_HEIGHT * 1.5, (scenesNumber - 1) * (refButton.frame.size.width + spaceBetweenScenes), refButton.frame.size.height)];
//    [self.timeline setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.timeline];
}

- (void)hideMenu {
    if(self.wasInExploreMode) {
        SceneManager *sceneManager = [self.storyboard instantiateViewControllerWithIdentifier:@"SceneManager"];
        [self.navigationController pushViewController:sceneManager animated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)navigateToExploreMode {
    SceneChooser *sceneChooser = [self.storyboard instantiateViewControllerWithIdentifier:@"SceneChooser"];
    [self.navigationController pushViewController:sceneChooser animated:NO];
}

-(void)touchEnded:(id)sender {
//    NSLog(@"[Timeline] Touch #%li", [sender tag]);
    //    [self.delegate showSceneWithNumber:[sender tag]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
