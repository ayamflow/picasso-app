//
//  SceneManager.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "SceneManager.h"
#import "Scene.h"
#import "SceneChooser.h"
#import "SceneModel.h"
#import "DataManager.h"
#import "UIViewControllerPicasso.h"
#import "SceneInterstitial.h"
#import "OrientationUtils.h"
#import "UIViewPicasso.h"
#import "UIViewControllerPicasso.h"
#import "Events.h"

@interface SceneManager ()

@property (strong, nonatomic) Scene *oldScene;
@property (strong, nonatomic) SceneInterstitial *interstitial;
@property (assign, nonatomic) NSInteger scenesNumber;

@end

@implementation SceneManager

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = [OrientationUtils nativeLandscapeDeviceSize];
    self.view.backgroundColor = [UIColor clearColor];
    [self updateRotation];
    [[MotionVideoPlayer sharedInstance] rotatePlayerToLandscape];

    DataManager *dataManager = [DataManager sharedInstance];
    self.scenesNumber = [dataManager getScenesNumber];
    
    // Auto launch
    [self showSceneWithNumber:[[dataManager getGameModel] currentScene]];   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSceneChooser) name:[MPPEvents ShowSceneChooserEvent] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigateBackToHome) name:[MPPEvents BackToHomeEvent] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skipInterstitial) name:[MPPEvents SkipInterstitialEvent] object:nil];
}

- (void)showSceneChooser {
    SceneChooser *sceneChooser = [[SceneChooser alloc] init];
    [self addChildViewController:sceneChooser];
    sceneChooser.view.alpha = 0;
    [self.view addSubview:sceneChooser.view];
    [self.view bringSubviewToFront:sceneChooser.view];
    sceneChooser.view.frame = self.view.frame;
    [sceneChooser.view moveTo:CGPointMake(sceneChooser.view.frame.origin.x, sceneChooser.view.frame.origin.y + 30)];
    [UIView animateWithDuration:0.4 animations:^{
        sceneChooser.view.alpha = 1;
        [sceneChooser.view moveTo:CGPointMake(sceneChooser.view.frame.origin.x, sceneChooser.view.frame.origin.y - 30)];
    }];
}

- (void)showSceneWithNumber:(NSInteger)number {
    // update oldScene
    if(self.currentScene) {
        [self.currentScene stop];
        [self.currentScene.view removeFromSuperview];
        self.oldScene = self.currentScene;
    }
    
    // create a new scene into *currentScene
    [self createSceneWithNumber:number];
}

- (void)createSceneWithNumber:(NSInteger)number {
    DataManager *dataManager = [DataManager sharedInstance];
    SceneModel *sceneModel = [dataManager getSceneWithNumber:number];

    self.oldScene = self.currentScene;
    [[dataManager getGameModel] setCurrentScene:number];
    self.currentScene = [[Scene alloc] initWithModel:sceneModel];
    self.currentScene.view.frame = self.view.frame;
    self.currentScene.delegate = self;
    [self addChildViewController:self.currentScene];
    [self.view addSubview:self.currentScene.view];
}

- (void)removeLastSeenScene {
//    NSLog(@"[SceneManager] RemoveLastSeenScene #%li", (long)self.oldScene.model.number);
    if(self.oldScene) {
        [self.oldScene stop];
        [self.oldScene.view removeFromSuperview];
        [self.oldScene removeFromParentViewController];
        self.oldScene.delegate = nil;
    }
}

- (void)showInterstitial {
    if(self.interstitial != nil) [self removeInterstitial];
    self.interstitial = [[SceneInterstitial alloc] initWithModel:self.currentScene.model];
    [self.view addSubview:self.interstitial.view];
}

- (void)removeInterstitial {
    [self.interstitial.view removeFromSuperview];
    self.interstitial = nil;
}

- (void)skipInterstitial {
    [[[DataManager sharedInstance] getGameModel] setSceneCurrentTime:0.0];
    [self createSceneWithNumber:[self getNextSceneNumber]];
    [self.currentScene.view moveTo:CGPointMake(0, [OrientationUtils nativeLandscapeDeviceSize].size.height)];
    [UIView animateWithDuration:0.4 animations:^{
        // Move old scene & interstitial out of the screen
        [self.oldScene.view moveTo:CGPointMake(0, -[OrientationUtils nativeLandscapeDeviceSize].size.height)];
        [self.interstitial.view moveTo:CGPointMake(0, -[OrientationUtils nativeLandscapeDeviceSize].size.height)];
        // Move new scene into the screen
        [self.currentScene.view moveTo:CGPointMake(0, 0)];
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

@end