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

#define kWidthFactor 0.56

@interface ScenePreview ()

@property (strong, nonatomic) SceneModel *model;
@property (assign, nonatomic) float previewWidth;

@end

@implementation ScenePreview

- (id)initWithModel:(SceneModel *)model {
    if(self = [super init]) {
        self.model = model;
        self.sceneNumber = self.model.number;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initBackground];
    [self initChapterTitle];
    [self initNavArrows];
    [self initTitle];
    [self initDate];
    [self initButton];
}

- (void)initBackground {
    CGSize screenSize = [OrientationUtils nativeLandscapeDeviceSize].size;
    self.previewWidth = screenSize.width * kWidthFactor;
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.previewWidth, screenSize.height)];
    background.backgroundColor = [UIColor textColor];
    [self.view addSubview:background];
}

- (void)initChapterTitle {
    NSLog(@"initChapterTitle");
    UILabel *chapterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.previewWidth * 0.8, 50)];
    chapterLabel.text = [@"chapitre" uppercaseString];
    chapterLabel.textColor = [UIColor whiteColor];
    chapterLabel.font = [UIFont fontWithName:@"AvenirLTStd-Light" size:12];
    [chapterLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:chapterLabel];
    [chapterLabel moveTo:CGPointMake(self.previewWidth / 2 - chapterLabel.frame.size.width / 2, 5)];
    
    UILabel *chapterNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.previewWidth * 0.8, 50)];
    chapterNumberLabel.text = [NSString stringWithFormat:@"%li", self.model.number + 1];
    chapterNumberLabel.textColor = [UIColor whiteColor];
    chapterNumberLabel.font = [UIFont fontWithName:@"AvenirLTStd-Black" size:25];
    [chapterNumberLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:chapterNumberLabel];
    [chapterNumberLabel moveTo:CGPointMake(self.previewWidth / 2 - chapterNumberLabel.frame.size.width / 2, 30)];
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
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.previewWidth * 0.8, 50)];
    titleLabel.text = [self.model.title uppercaseString];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Bold" size:17];
    titleLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    titleLabel.layer.borderWidth = 3;
    [self.view addSubview:titleLabel];
    [titleLabel moveTo:CGPointMake(self.previewWidth / 2 - titleLabel.frame.size.width / 2, 110)];
}

- (void)initDate {
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.previewWidth * 0.8, 130)];
    dateLabel.text = self.model.date;
    dateLabel.textColor = [UIColor whiteColor];
    [dateLabel setTextAlignment:NSTextAlignmentCenter];
    dateLabel.font = [UIFont fontWithName:@"AvenirLTStd-Roman" size:20];
    [self.view addSubview:dateLabel];
    [dateLabel moveTo:CGPointMake(self.previewWidth / 2 - dateLabel.frame.size.width / 2, 120)];
    
}

- (void)initButton {
    if(self.model.unlocked) {
        [self initExploreButton];
    }
    else {
        [self initLockedButton];
    }
}

- (void)initLockedButton {
    UIImageView *locked = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockedButton.png"]];
    [self.view addSubview:locked];
    [locked moveTo:CGPointMake(self.previewWidth / 2 - locked.frame.size.width / 2, [OrientationUtils nativeLandscapeDeviceSize].size.height * 2/3)];
}

- (void)initExploreButton {
    UILabel *exploreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.previewWidth * 0.4, 40)];
    exploreLabel.text = [@"explorer" uppercaseString];
    exploreLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Medium" size:12];
    exploreLabel.textColor = [UIColor whiteColor];
    exploreLabel.backgroundColor = [UIColor darkerColor];
    [exploreLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:exploreLabel];
    [exploreLabel moveTo:CGPointMake(self.previewWidth / 2 - exploreLabel.frame.size.width / 2, [OrientationUtils nativeLandscapeDeviceSize].size.height * 2/3 + exploreLabel.frame.size.height / 2)];
}

@end
