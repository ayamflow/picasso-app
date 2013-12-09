//
//  ScenePreview.m
//  Picasso
//
//  Created by MOREL Florian on 25/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "ScenePreviewView.h"
#import "SceneModel.h"
#import "OrientationUtils.h"
#import "Colors.h"
#import "UIViewPicasso.h"
#import "DataManager.h"
#import "SceneManager.h"

@interface ScenePreviewView ()

@property (strong, nonatomic) SceneModel *model;
@property (strong, nonatomic) UIButton *exploreButton;
@property (strong, nonatomic) UIImageView *background;

@end

@implementation ScenePreviewView

- (id)initWithFrame:(CGRect)frame andModel:(SceneModel *)model {
    if(self = [super initWithFrame:frame]) {
        self.model = model;
        [self initView];
    }
    return self;
}

- (void)initView
{
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
    self.background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circleButton.png"]];
    [self addSubview:self.background];

    self.background.center = self.center;
}

- (void)showScenePreview {
    UIImage *maskedPreview = [UIImage imageNamed:[NSString stringWithFormat:@"scene-%li.png", self.model.number + 1]];
    UIImageView *scenePreview = [[UIImageView alloc] initWithImage:maskedPreview];
    [scenePreview moveTo:CGPointMake(self.background.frame.origin.x - 6, self.background.frame.origin.y - 37)];

    [self addSubview:scenePreview];
}

- (void)initNavArrows {
    UIImageView *leftArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navArrowLeft.png"]];
    [self addSubview:leftArrow];
    [leftArrow moveTo:CGPointMake(30, 30)];

    UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navArrowRight.png"]];
    [self addSubview:rightArrow];
    [rightArrow moveTo:CGPointMake(self.frame.size.width - 30 - rightArrow.frame.size.width, 30)];
}

- (void)initLockedButton {
    UIImageView *locked = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockedButton.png"]];
    [self addSubview:locked];
    locked.center = self.background.center;
}

- (void)initChapterLabel {
    NSString *labelText = [[NSString stringWithFormat:@"chapitre %li", self.model.number + 1] uppercaseString];
    UILabel *exploreLabel = [[UILabel alloc] initWithFrame:self.background.frame];
    exploreLabel.text = labelText;
    exploreLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Medium" size:12];
    exploreLabel.textColor = [UIColor whiteColor];
    [exploreLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:exploreLabel];
    exploreLabel.frame = CGRectOffset(exploreLabel.frame, 0, self.background.frame.size.height / 3);
}

@end