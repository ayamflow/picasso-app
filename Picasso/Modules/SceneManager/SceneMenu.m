//
//  SceneMenu.m
//  Picasso
//
//  Created by Florian Morel on 30/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "SceneMenu.h"
#import "OrientationUtils.h"
#import "UIViewControllerPicasso.h"
#import "UIViewPicasso.h"
#import "NavigationBarView.h"
#import "SceneModel.h"
#import "Events.h"
#import "Colors.h"
#import "DataManager.h"
#import "SceneChooserLandscape.h"
#import "SceneManager.h"
#import "MapView.h"
#import "StatsFooterView.h"

@interface SceneMenu ()

@property (strong, nonatomic) SceneModel *sceneModel;
@property (strong, nonatomic) SceneChooserLandscape *sceneChooser;
@property (strong, nonatomic) StatsFooterView *bottomInfos;
@property (strong, nonatomic) MapView *map;

@end

@implementation SceneMenu

- (id)initWithModel:(SceneModel *)model {
    if(self = [super init]) {
        self.sceneModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initBackground];
    [self initMap];
    [self initNavigationBar];
    [self initBottomInfos];
    
    [self.map scrollToIndex:self.sceneModel.number];
}

- (void)initBackground {
    UIView *background = [[UIView alloc] initWithFrame:[OrientationUtils nativeLandscapeDeviceSize]];
//    background.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    background.backgroundColor = [UIColor backgroundColor];
    [self.view addSubview:background];
}

- (void)initNavigationBar {
    self.navigationBar = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeLandscapeDeviceSize].size.width, 50) andTitle:[@"Explorer" uppercaseString] andShowExploreButton:YES];
    [self.navigationBar moveTo:CGPointMake(0, 15)];
    [self.navigationBar.exploreButton setImage:[UIImage imageNamed:@"menuPlay.png"] forState:UIControlStateNormal];
    [self.view addSubview:self.navigationBar];

    CGRect titleFrame = self.navigationBar.titleLabel.frame;
    titleFrame.size.width = [OrientationUtils nativeLandscapeDeviceSize].size.width / 2;
    titleFrame.origin.x = [OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - titleFrame.size.width / 2;
    self.navigationBar.titleLabel.frame = titleFrame;
    self.navigationBar.titleLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.navigationBar.titleLabel.layer.borderWidth = 0;

    [self.navigationBar.exploreButton addTarget:self action:@selector(exitMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar.backButton addTarget:self action:@selector(dispatchBackToHome) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dispatchBackToHome {
    [[NSNotificationCenter defaultCenter] postNotificationName:[MPPEvents BackToHomeEvent] object:nil];
}

- (void)initBottomInfos {
    self.bottomInfos = [[StatsFooterView alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeLandscapeDeviceSize].size.width, 20)];
    [self.view addSubview:self.bottomInfos];
    [self.bottomInfos moveTo:CGPointMake(0, [OrientationUtils nativeLandscapeDeviceSize].size.height - self.bottomInfos.frame.size.height)];
}

- (void)initMap {
    self.map = [[MapView alloc] initWithFrame:[OrientationUtils nativeLandscapeDeviceSize]];
    [self.view addSubview:self.map];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSceneChooser) name:[MPPEvents ShowSceneChooserLandscapeEvent] object:nil];
}

- (void)exitMenu {
    [UIView animateWithDuration:0.4 animations:^{
        self.map.alpha = 0;
    } completion:^(BOOL finished) {
        [self.map clearPaths];
        [[NSNotificationCenter defaultCenter] postNotificationName:[MPPEvents MenuExitEvent] object:nil];
    }];
}

- (void)showSceneChooser {
    [self.map clearPaths];
    [self.navigationBar.exploreButton removeFromSuperview];
    [self.navigationBar.backButton setImage:[UIImage imageNamed:@"navBackButton.png"] forState:UIControlStateNormal];
    [self.navigationBar.backButton removeTarget:self action:@selector(exitMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar.backButton addTarget:self action:@selector(hideSceneChooser) forControlEvents:UIControlEventTouchUpInside];

    [self.navigationBar.exploreButton performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];

    if(self.sceneChooser == nil) {
        self.sceneChooser = [[SceneChooserLandscape alloc] init];
        self.sceneChooser.delegate = self;
        self.sceneChooser.mapDelegate = self.map;
    }
    [self.view addSubview:self.sceneChooser.view];
    [self.view bringSubviewToFront:self.navigationBar];

    [self.sceneChooser.view moveTo:CGPointMake(0, -20)];
    self.sceneChooser.view.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        self.navigationBar.titleLabel.layer.borderWidth = 2;
        [self.sceneChooser.view moveTo:CGPointMake(0, 0)];
        self.sceneChooser.view.alpha = 1;
        [self.bottomInfos moveTo:CGPointMake(0, self.bottomInfos.frame.origin.y + 20)];
        self.bottomInfos.alpha = 0;
    } completion:^(BOOL finished) {
        [self.bottomInfos performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
    }];
}

- (void)hideSceneChooser {
    [self.map clearAnimatedPath];
    
    [self.view addSubview:self.bottomInfos];
    [self.view addSubview:self.map];

    [self.map showDetails];

    [UIView animateWithDuration:0.4 animations:^{
        self.navigationBar.titleLabel.layer.borderWidth = 0;
        
        [self.bottomInfos moveTo:CGPointMake(0, self.bottomInfos.frame.origin.y - 20)];
        self.bottomInfos.alpha = 1;
        [self.sceneChooser.view moveTo:CGPointMake(0, self.sceneChooser.view.frame.origin.y - 20)];
        self.sceneChooser.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.sceneChooser.view performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        self.navigationBar.titleLabel.text = [@"Explorer" uppercaseString]; //[self.sceneModel.title uppercaseString];
        self.sceneChooser.delegate = nil;
        self.sceneChooser.mapDelegate = nil;
        self.sceneChooser = nil;
    }];

    [self.navigationBar.backButton setImage:[UIImage imageNamed:@"menuHamburger.png"] forState:UIControlStateNormal];
    [self.navigationBar addSubview:self.navigationBar.exploreButton];
    [self.navigationBar.exploreButton addTarget:self action:@selector(exitMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar.backButton removeTarget:self action:@selector(hideSceneChooser) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar.backButton addTarget:self action:@selector(dispatchBackToHome) forControlEvents:UIControlEventTouchUpInside];

    [self.view bringSubviewToFront:self.navigationBar];
    [self.view bringSubviewToFront:self.bottomInfos];
}

// Protocol

- (void)navigateToSceneWithNumber:(NSInteger)number {
    [UIView animateWithDuration:0.8 animations:^{
        self.view.alpha = 0;
        [self.view moveTo:CGPointMake(- self.view.frame.size.width, self.view.frame.origin.y)];
    } completion:^(BOOL finished) {
        [[DataManager sharedInstance] getGameModel].currentScene = number;
        [self.delegate showSceneWithNumber:number];
    }];
}

- (void)updateNavigationTitleWithString:(NSString *)title {
    self.navigationBar.titleLabel.text = [title uppercaseString];
}

@end
