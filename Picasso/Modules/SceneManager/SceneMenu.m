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
#import "DataManager.h"

@interface SceneMenu ()

@property (strong, nonatomic) SceneModel *sceneModel;

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
    [self initNavigationBar];
}

- (void)initBackground {
    UIView *background = [[UIView alloc] initWithFrame:[OrientationUtils nativeLandscapeDeviceSize]];
    background.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    [self.view addSubview:background];
}

- (void)initNavigationBar {
    self.navigationBar = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeLandscapeDeviceSize].size.width, 50) andTitle:self.sceneModel.title andShowExploreButton:YES];
    [self.navigationBar moveTo:CGPointMake(0, 25)];
    [self.view addSubview:self.navigationBar];

    CGRect titleFrame = self.navigationBar.titleLabel.frame;
    titleFrame.size.width = [OrientationUtils nativeLandscapeDeviceSize].size.width / 2;
    titleFrame.origin.x = [OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - titleFrame.size.width / 2;
    self.navigationBar.titleLabel.frame = titleFrame;
    self.navigationBar.titleLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.navigationBar.titleLabel.layer.borderWidth = 2;
}

@end
