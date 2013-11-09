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
#import "SceneInterstitial.h"

@interface SceneManager ()

@property (strong, nonatomic) Scene *oldScene;
@property (strong, nonatomic) Scene *currentScene;
@property (strong, nonatomic) SceneInterstitial *interstitial;
@property (assign, nonatomic) int scenesNumber;

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
    
    DataManager *dataManager = [DataManager sharedInstance];
    self.scenesNumber = [dataManager getScenesNumber];
    
    // Auto launch if needed
    [self showSceneWithNumber:[dataManager getGameModel].currentScene];
}

- (void)showSceneWithNumber:(int)number {
    // update oldScene
    if(self.currentScene) {
        [self.currentScene stop];
        [self.currentScene.view removeFromSuperview];
        self.oldScene = self.currentScene;
    }
    
    // create a new scene into *currentScene
    [self createSceneWithNumber:number andPosition:CGPointMake(0, 0)];
}

- (void)createSceneWithNumber:(int)number andPosition:(CGPoint)position {
    DataManager *dataManager = [DataManager sharedInstance];
    SceneModel *sceneModel = [dataManager getSceneWithNumber:number];
    
    self.oldScene = self.currentScene;
    self.currentScene = [[Scene alloc] initWithModel:sceneModel andPosition:position];
    self.currentScene.delegate = self;
    [self.view addSubview:self.currentScene.view];
    NSLog(@"new scene #%i", self.currentScene.model.number);
}

- (void)removeLastSeenScene {
    if(self.oldScene) {
        [self.oldScene stop];
        [self.oldScene.view removeFromSuperview];
        self.oldScene = nil;
    }
}

- (NSString *)getSceneIdFormat:(int)number {
    return [NSString stringWithFormat:@"scene-%i", number];
}

- (void)showInterstitial {
    if(self.interstitial != nil) [self removeInterstitial];
    self.interstitial = [[SceneInterstitial alloc] initWithDescription:self.currentScene.model.description];
    self.interstitial.slidingButton.delegate = self;
    [self.view addSubview:self.interstitial.view];
}

- (void)removeInterstitial {
    [self.interstitial.view removeFromSuperview];
    self.interstitial = nil;
}

- (void)skipInterstitial {
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
    [self showSceneWithNumber:[self getNextSceneNumber]];
}

- (void)showPreviousScene {
    [self showSceneWithNumber:[self getPreviousSceneNumber]];
}

- (int)getNextSceneNumber {
    return self.currentScene.model.number < self.scenesNumber - 1 ? self.currentScene.model.number + 1 : 0;
}

- (int)getPreviousSceneNumber {
    return self.currentScene.model.number > 0 ? self.currentScene.model.number - 1 : self.scenesNumber - 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end