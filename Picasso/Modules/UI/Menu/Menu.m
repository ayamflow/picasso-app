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
#import "UIViewPicasso.h"

#define BUTTON_HEIGHT 30

@interface Menu ()

@property (strong, nonatomic) UIImageView *logo;
@property (strong, nonatomic) UIColor *textColor;
//@property (strong, nonatomic) Timeline *timeline;
@property (strong, nonatomic) UIView *timeline;
@property (strong, nonatomic) UIView *progressBar;

@property (assign, nonatomic) BOOL orientationWasLandscape;

@end

@implementation Menu

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
    [self.closeButton addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.exploreButton addTarget:self action:@selector(navigateToExploreMode) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backButton moveTo:CGPointMake([OrientationUtils nativeDeviceSize].size.width / 2 - self.backButton.frame.size.width / 2, [OrientationUtils nativeDeviceSize].size.height - self.backButton.frame.size.height)];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        if(self.orientationWasLandscape) return;
		[self updatePositionToLandscape];
        self.orientationWasLandscape = YES;
    }
	else if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        [self updatePositionToPortrait];
        self.orientationWasLandscape = NO;
    }
}

- (void)updatePositionToPortrait {
    float topPosition = [OrientationUtils nativeLandscapeDeviceSize].size.height / 2;
    float leftPosition = [OrientationUtils nativeDeviceSize].size.width / 2;
    float topIncrement = self.exploreButton.frame.size.height + 10.0;
    
    [self.exploreButton moveTo:CGPointMake(leftPosition - self.exploreButton.frame.size.width / 2, topPosition)];
    [self.galleryButton moveTo:CGPointMake(leftPosition - self.exploreButton.frame.size.width / 2, topPosition + topIncrement / 2)];
    [self.museumButton moveTo:CGPointMake(leftPosition - self.exploreButton.frame.size.width / 2, topPosition + topIncrement)];
    [self.backButton moveTo:CGPointMake(leftPosition - self.exploreButton.frame.size.width / 2, topPosition + topIncrement * 1.5)];
    
    [self.closeButton moveTo:CGPointMake([OrientationUtils nativeDeviceSize].size.width / 2 - self.closeButton.frame.size.width / 2, [OrientationUtils nativeDeviceSize].size.height - self.closeButton.frame.size.height)];
}

- (void)updatePositionToLandscape {
    float topPosition = [OrientationUtils nativeDeviceSize].size.height * 2 / 3;
    float leftPosition = ([OrientationUtils nativeLandscapeDeviceSize].size.width / 2) - self.exploreButton.frame.size.width * 1.5 - 10.0;

    [self.exploreButton moveTo:CGPointMake(leftPosition, topPosition)];
    [self.galleryButton moveTo:CGPointMake(leftPosition + self.exploreButton.frame.size.width + 10.0, topPosition)];
    [self.museumButton moveTo:CGPointMake(leftPosition + 2 * (self.exploreButton.frame.size.width + 10.0), topPosition)];
    
    [self.closeButton moveTo:CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - self.closeButton.frame.size.width / 2, [OrientationUtils nativeDeviceSize].size.height - self.closeButton.frame.size.height)];
}

/*- (void)initTimeline {
    CGRect screenSize = [OrientationUtils deviceSize];
    
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
}*/

- (void)hideMenu {
    if(self.wasInExploreMode && self.wasInSceneMode) {
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

@end
