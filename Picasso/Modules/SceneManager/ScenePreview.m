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
#define kBorderSize 106

@interface ScenePreview ()

@property (strong, nonatomic) SceneModel *model;

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
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kBorderSize * 3, kBorderSize * 1.5)];

    [self initBorder];
    [self initChapterLabel];
    if(self.model.unlocked) {
        [self showScenePreview];
    }
    else {
        [self initLockedButton];
    }
}

- (void)initBorder {
    UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kBorderSize, kBorderSize)];
    border.layer.borderColor = [UIColor blackColor].CGColor;
    border.layer.borderWidth = 2;
    [self.view addSubview:border];
    [border moveTo:CGPointMake(self.view.frame.size.width / 2 - border.frame.size.width / 2, self.view.frame.size.height / 2 - border.frame.size.height / 2)];
    border.layer.anchorPoint = CGPointMake(0.5, 0.5);
    border.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_4);
}

- (void)showScenePreview {
    UIImageView *scenePreview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"scene-%li.png", self.model.number + 1]]];
    [scenePreview moveTo:CGPointMake(self.view.frame.size.width / 2 - scenePreview.frame.size.width / 2, self.view.frame.size.height / 2 - scenePreview.frame.size.height)];
    [self.view addSubview:scenePreview];
}

- (void)initLockedButton {
    UIImageView *locked = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockedButton.png"]];
    [self.view addSubview:locked];
    [locked moveTo:CGPointMake(self.view.frame.size.width / 2 - locked.frame.size.width / 2, self.view.frame.size.height / 2 - locked.frame.size.height)];
}

- (void)initChapterLabel {
    NSString *labelText = [[NSString stringWithFormat:@"chapitre %li", self.model.number + 1] uppercaseString];
    UILabel *exploreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 5)];
    exploreLabel.text = labelText;
    exploreLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Regular" size:10];
    exploreLabel.textColor = [UIColor blackColor];
    [exploreLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:exploreLabel];
    [exploreLabel moveTo:CGPointMake(self.view.frame.size.width / 2 - exploreLabel.frame.size.width / 2, self.view.frame.size.height * 4 / 6 - exploreLabel.frame.size.height / 2)];
}


@end