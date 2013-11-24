//
//  MenuViewController.m
//  Picasso
//
//  Created by MOREL Florian on 30/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "SceneManager.h"
#import "MenuLandscape.h"
#import "OrientationUtils.h"
#import "Timeline.h"
#import "DataManager.h"
#import "SceneChooser.h"
#import "UIViewPicasso.h"

#define BUTTON_HEIGHT 30

@interface MenuLandscape ()

@property (strong, nonatomic) UIImageView *logo;
@property (strong, nonatomic) UIColor *textColor;
//@property (strong, nonatomic) Timeline *timeline;
@property (strong, nonatomic) UIView *timeline;
@property (strong, nonatomic) UIView *progressBar;
@property (strong, nonatomic) UIView *overlay;

@property (assign, nonatomic) BOOL orientationWasLandscape;

// Transitions
@property (assign, nonatomic) NSInteger transitionsNumber;
@property (assign, nonatomic) NSInteger transitionsDone;

@end

@implementation MenuLandscape

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    self.textColor = [UIColor colorWithRed:0.44 green:0.44 blue:0.44 alpha:1.0];

//    [self initOverlay];
//    [self initLogo];
//    [self initButtons];
//    [self initTimeline];

//     [self transitionIn];
}

- (void)initOverlay {
    CGRect overlayFrame = UIInterfaceOrientationIsLandscape(self.previousOrientation) ? [OrientationUtils nativeLandscapeDeviceSize] : [OrientationUtils nativeDeviceSize];
    self.overlay = [[UIView alloc] initWithFrame:overlayFrame];
    self.overlay.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    [self.view addSubview:self.overlay];
    [self.view sendSubviewToBack:self.overlay];
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

- (void)transitionIn {
    float height = UIInterfaceOrientationIsLandscape(self.previousOrientation) ? [OrientationUtils nativeLandscapeDeviceSize].size.height : [OrientationUtils nativeDeviceSize].size.height;

    self.overlay.alpha = 0;
    [self.exploreButton moveTo:CGPointMake(self.exploreButton.frame.origin.x, self.exploreButton.frame.origin.y - height)];
    [self.galleryButton moveTo:CGPointMake(self.galleryButton.frame.origin.x, self.galleryButton.frame.origin.y - height)];
    [self.museumButton moveTo:CGPointMake(self.museumButton.frame.origin.x, self.museumButton.frame.origin.y - height)];

    [self transitionInOverlay];
    [self transitionInButtons];
}

- (void)transitionInOverlay {
	[UIView animateWithDuration:1 animations:^{
        self.overlay.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)transitionInButtons {
	[self translateElementIn:self.exploreButton at:0 withDuration:1];
	[self translateElementIn:self.galleryButton at:0.05 withDuration:1];
    [self translateElementIn:self.museumButton at:0.1 withDuration:1];
}

- (void)translateElementIn:(UIView *)view at:(NSTimeInterval)startTime withDuration:(NSTimeInterval)duration {
    CGRect screenSize = UIInterfaceOrientationIsLandscape(self.previousOrientation) ? [OrientationUtils nativeLandscapeDeviceSize] : [OrientationUtils nativeDeviceSize];

    self.transitionsNumber++;
    view.layer.position = CGPointMake(view.layer.position.x, view.layer.position.y - screenSize.size.height);
    [UIView animateWithDuration:duration delay:startTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.layer.position = CGPointMake(view.layer.position.x, view.layer.position.y  + screenSize.size.height);
    } completion:^(BOOL finished) {
        [self transitionInComplete];
    }];
}

- (void)transitionInComplete {
    if(++self.transitionsDone == self.transitionsNumber) {
	    NSLog(@"transitionInComplete");
    }
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
        [self.navigationController pushViewController:sceneManager animated:NO];
    }
    else {
        [self.navigationController popViewControllerAnimated:NO];
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
