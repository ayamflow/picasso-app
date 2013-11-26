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

#define kWidthFactor 0.56

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
    
    [self initBackground];
    [self initChapterTitle];
//    [self initNavArrows];
    [self initTitle];
    [self initDate];
    [self initButton];
}

- (void)initBackground {
    CGSize screenSize = [OrientationUtils nativeLandscapeDeviceSize].size;
    
    self.previewWidth = screenSize.width * kWidthFactor;
    self.background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circleButton.png"]];
    [self.view addSubview:self.background];
    
    [self.background moveTo:CGPointMake(self.previewWidth / 2 - self.background.frame.size.width / 2, screenSize.height / 2 - self.background.frame.size.height / 4)];
    
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

- (void)initChapterTitle {
    UILabel *chapterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.previewWidth * 0.8, 50)];
    chapterLabel.text = [[NSString stringWithFormat:@"chapitre %li", self.model.number + 1] uppercaseString];
    chapterLabel.textColor = [UIColor blackColor];
    chapterLabel.font = [UIFont fontWithName:@"AvenirLTStd-Roman" size:12];
    [chapterLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:chapterLabel];
    [chapterLabel moveTo:CGPointMake(self.previewWidth / 2 - chapterLabel.frame.size.width / 2, 5)];
}

- (void)initNavArrows {
    UIImageView *leftArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navArrowLeft.png"]];
    [self.view addSubview:leftArrow];
    [leftArrow moveTo:CGPointMake(30, 30)];
    
    UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navArrowRight.png"]];
    [self.view addSubview:rightArrow];
    [rightArrow moveTo:CGPointMake(self.previewWidth - 30 - rightArrow.frame.size.width, 30)];
}

- (void)initTitle {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.previewWidth * 0.6, 35)];
    titleLabel.text = [self.model.title uppercaseString];
    titleLabel.textColor = [UIColor blackColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Bold" size:13];
    titleLabel.layer.borderColor = [UIColor blackColor].CGColor;
    titleLabel.layer.borderWidth = 2;
    [self.view addSubview:titleLabel];
    [titleLabel moveTo:CGPointMake(self.previewWidth / 2 - titleLabel.frame.size.width / 2, 40)];
}

- (void)initDate {
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.previewWidth * 0.8, 130)];
    dateLabel.text = self.model.date;
    dateLabel.textColor = [UIColor blackColor];
    [dateLabel setTextAlignment:NSTextAlignmentCenter];
    dateLabel.font = [UIFont fontWithName:@"AvenirLTStd-Roman" size:13];
    [self.view addSubview:dateLabel];
    [dateLabel moveTo:CGPointMake(self.previewWidth / 2 - dateLabel.frame.size.width / 2, 25)];
    
}

- (void)initButton {
    [self initExploreLabel];
    
    if(!self.model.unlocked) {
        [self initLockedButton];
    }
}

- (void)initLockedButton {
    UIImageView *locked = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockedButton.png"]];
    [self.view addSubview:locked];
    locked.center = self.background.center;
}

- (void)initExploreLabel {
    NSString *labelText = self.model.unlocked ? [@"explorer" uppercaseString] : [@"bloqué" uppercaseString];
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