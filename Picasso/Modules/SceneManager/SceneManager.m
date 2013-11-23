//
//  SceneManager.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "SceneManager.h"
#import "Scene.h"
#import "SceneModel.h"
#import "DataManager.h"
#import "UIViewControllerPicasso.h"
#import "SceneInterstitial.h"
#import "OrientationUtils.h"
#import "MenuButton.h"
#import "UIViewControllerPicasso.h"

@interface SceneManager ()

@property (strong, nonatomic) Scene *oldScene;
@property (strong, nonatomic) SceneInterstitial *interstitial;
@property (assign, nonatomic) NSInteger scenesNumber;
@property (strong, nonatomic) MenuButton *menuButton;

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

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    DataManager *dataManager = [DataManager sharedInstance];
    self.scenesNumber = [dataManager getScenesNumber];
    
    // Auto launch
    [self showSceneWithNumber:[[dataManager getGameModel] currentScene]];
	[self initMenu];
}

- (void)initMenu {
    self.menuButton = [[MenuButton alloc] initWithExploreMode:YES];
    [self addChildViewController:self.menuButton];
    [self.view addSubview:self.menuButton.view];
    [self.view bringSubviewToFront:self.menuButton.view];
    CGRect frame = self.menuButton.view.frame;
    frame.origin.x = [OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - self.menuButton.view.frame.size.width / 2;
    self.menuButton.view.frame = frame;
}

- (void)showMenuWithExploreMode:(BOOL)isExploreMode andSceneMode:(BOOL)isSceneMode{
    NSLog(@"showMenu");
    [self.currentScene stop];
    [self showMenuWithOrientation:self.interfaceOrientation andExploreMode:YES andSceneMode:YES];
//    [super showMenuWithExploreMode:YES andSceneMode:YES];
}

- (void)showSceneWithNumber:(NSInteger)number {
    // update oldScene
    if(self.currentScene) {
        [self.currentScene stop];
        [self.currentScene.view removeFromSuperview];
        self.oldScene = self.currentScene;
    }
    
    // create a new scene into *currentScene
    [self createSceneWithNumber:number andPosition:CGPointMake(0, 0)];
}

- (void)createSceneWithNumber:(NSInteger)number andPosition:(CGPoint)position {
    DataManager *dataManager = [DataManager sharedInstance];
    SceneModel *sceneModel = [dataManager getSceneWithNumber:number];

    self.oldScene = self.currentScene;
    self.currentScene = [[Scene alloc] initWithModel:sceneModel andPosition:position];
    self.currentScene.delegate = self;
    [self addChildViewController:self.currentScene];
    [self.view addSubview:self.currentScene.view];
    [self.view bringSubviewToFront:self.menuButton.view];
}

- (void)removeLastSeenScene {
//    NSLog(@"[SceneManager] RemoveLastSeenScene #%li", (long)self.oldScene.model.number);
    if(self.oldScene) {
        [self.oldScene stop];
        [self.oldScene.view removeFromSuperview];
        [self.oldScene removeFromParentViewController];
        self.oldScene.delegate = nil;
        self.oldScene = nil;
    }
}

- (void)showInterstitial {
    if(self.interstitial != nil) [self removeInterstitial];
    self.interstitial = [[SceneInterstitial alloc] initWithModel:self.currentScene.model];
    self.interstitial.slidingButton.delegate = self;
    [self.view addSubview:self.interstitial.view];
//	[self.navigationController presentViewController:self.interstitial animated:NO completion:nil];
}

- (void)removeInterstitial {
    [self.interstitial.view removeFromSuperview];
    self.interstitial = nil;
}

- (void)skipInterstitial {
    [[[DataManager sharedInstance] getGameModel] setSceneCurrentTime:0.0];
    [self createSceneWithNumber:[self getNextSceneNumber] andPosition:CGPointMake(0, self.currentScene.view.frame.size.height)];
    [UIView animateWithDuration:0.4f animations:^{
        // Move old scene & interstitial out of the screen
        CGPoint oldScenePosition = CGPointMake(0, -self.oldScene.view.frame.size.height);
        CGRect oldSceneFrame = self.oldScene.view.frame;
        oldSceneFrame.origin = oldScenePosition;
        self.oldScene.view.frame = oldSceneFrame;
        self.interstitial.view.frame = oldSceneFrame;
        // Move new scene into the screen
        CGPoint currentScenePosition = CGPointMake(0, 0);
        CGRect currentSceneFrame = self.currentScene.view.frame;
        currentSceneFrame.origin = currentScenePosition;
        self.currentScene.view.frame = currentSceneFrame;
    } completion:^(BOOL finished) {
        [self removeLastSeenScene];
        [self removeInterstitial];
    }];
}

// Implementation of the SceneManaging Protocol

- (void)fadeCurrentSceneToBlack {
    [UIView animateWithDuration:0.5f animations:^{
        [self.currentScene.view setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self showInterstitial];
    }];
}

- (void)showNextScene {
    [[[DataManager sharedInstance] getGameModel] setCurrentScene:[self getNextSceneNumber]];
    [self showSceneWithNumber:[self getNextSceneNumber]];
}

- (void)showPreviousScene {
    [[[DataManager sharedInstance] getGameModel] setCurrentScene:[self getPreviousSceneNumber]];
    [self showSceneWithNumber:[self getPreviousSceneNumber]];
}

- (NSInteger)getNextSceneNumber {
    return self.currentScene.model.number < self.scenesNumber - 1 ? self.currentScene.model.number + 1 : 0;
}

- (NSInteger)getPreviousSceneNumber {
    return self.currentScene.model.number > 0 ? self.currentScene.model.number - 1 : self.scenesNumber - 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end