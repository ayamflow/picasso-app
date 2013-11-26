//
//  ScenePreview.m
//  Picasso
//
//  Created by MOREL Florian on 25/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "ScenePreview.h"
#import "SceneModel.h"
#import "OrientationUtils.h"
#import "Colors.h"
#import "UIViewPicasso.h"
#import "DataManager.h"
#import "SceneManager.h"

#define kWidthRatio 0.5

@interface ScenePreview ()

@property (strong, nonatomic) SceneModel *model;
@property (strong, nonatomic) UIButton *exploreButton;
@property (strong, nonatomic) UIImageView *background;

@end

@implementation ScenePreview

- (id)initWithModel:(SceneModel *)model {
    if(self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeLandscapeDeviceSize].size.width * kWidthRatio, [OrientationUtils nativeLandscapeDeviceSize].size.height)];
    
    [self initBackground];
    
    if(self.model.unlocked) {
        [self initChapterLabel];
        [self showScenePreview];
    }
    else {
        [self initLockedButton];
    }
}

- (void)initBackground {
    CGSize screenSize = [OrientationUtils nativeLandscapeDeviceSize].size;
    
    self.background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circleButton.png"]];
    [self.view addSubview:self.background];
    
    [self.background moveTo:CGPointMake(self.view.frame.size.width / 2 - self.background.frame.size.width / 2, screenSize.height / 2 - self.background.frame.size.height / 4)];
}

- (void)showScenePreview {
    UIImage *maskedPreview = [UIImage imageNamed:[NSString stringWithFormat:@"scene-%li.png", self.model.number + 1]];
    UIImageView *scenePreview = [[UIImageView alloc] initWithImage:maskedPreview];
    [scenePreview moveTo:CGPointMake(self.background.frame.origin.x, self.background.frame.origin.y - 25)];
    
    UIImage *mask = [UIImage imageNamed:@"circleMask.png"];
    CGImageRef cgImageWithApha = [mask CGImage];
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contents = (__bridge id)cgImageWithApha;
    CALayer *maskedLayer = scenePreview.layer;
    maskedLayer.mask = maskLayer;
    maskLayer.frame = CGRectMake(self.background.bounds.origin.x + 3.5, self.background.bounds.origin.y + 10, self.background.bounds.size.width, self.background.bounds.size.height);
    
    [self.view addSubview:scenePreview];
}

- (void)initNavArrows {
    UIImageView *leftArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navArrowLeft.png"]];
    [self.view addSubview:leftArrow];
    [leftArrow moveTo:CGPointMake(30, 30)];
    
    UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navArrowRight.png"]];
    [self.view addSubview:rightArrow];
    [rightArrow moveTo:CGPointMake(self.view.frame.size.width - 30 - rightArrow.frame.size.width, 30)];
}

- (void)initLockedButton {
    UIImageView *locked = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockedButton.png"]];
    locked.alpha = 0.6;
    [self.view addSubview:locked];
    locked.center = self.background.center;
}

- (void)initChapterLabel {
    NSString *labelText = [[NSString stringWithFormat:@"chapitre %li", self.model.number + 1] uppercaseString];
    UILabel *exploreLabel = [[UILabel alloc] initWithFrame:self.background.frame];
    exploreLabel.text = labelText;
    exploreLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Medium" size:12];
    exploreLabel.textColor = [UIColor whiteColor];
    [exploreLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:exploreLabel];
    exploreLabel.frame = CGRectOffset(exploreLabel.frame, 0, self.background.frame.size.height / 3);
}

- (void)exploreButtonDown:(id)sender {
    ((UIButton *)sender).backgroundColor = [UIColor blackColor];
}

- (void)resetButtonColor {
    // Touch feedback
    self.exploreButton.backgroundColor = [UIColor darkerColor];
}

- (void)exploreButtonTouched:(id)sender {
    [self resetButtonColor];
    // Set global scene model
    [[DataManager sharedInstance] getGameModel].currentScene = [sender tag];
    // Out animation & go to SceneManager
    SceneManager *sceneManager = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:@"SceneManager"];
    [self.parentViewController.navigationController pushViewController:sceneManager animated:NO];
}

@end