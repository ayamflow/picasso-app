//
//  Intro.m
//  Picasso
//
//  Created by Florian Morel on 30/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Intro.h"
#import "Logo.h"
#import "UIViewPicasso.h"
#import "UIViewControllerPicasso.h"
#import "OrientationUtils.h"

@interface Intro ()

@property (strong, nonatomic) Logo *logo;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation Intro

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];

    [self hideNavigationBar];
    [self initLogo];
    [self initTitle];
    [self transitionIn];
}

- (void)initLogo {
    self.logo = [[Logo alloc] init];
    [self.logo.view moveTo:CGPointMake([OrientationUtils nativeDeviceSize].size.width / 2 - self.logo.view.frame.size.width / 2, [OrientationUtils nativeDeviceSize].size.height / 2 - self.logo.view.frame.size.height)];
    [self.view addSubview:self.logo.view];
}

- (void)initTitle {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.logo.view.frame.origin.y + self.logo.view.frame.size.height + 20, [OrientationUtils nativeDeviceSize].size.width, self.logo.view.frame.size.height / 2)];
    self.titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Regular" size:12];
    self.titleLabel.text = [@"Sur les traces\n du maître picasso" uppercaseString];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 2;
    [self.view addSubview:self.titleLabel];
}

- (void)transitionIn {
    self.logo.view.alpha = 0;
    self.titleLabel.alpha = 0;

    CGFloat duration = 0.8;

    [UIView animateWithDuration:duration animations:^{
        self.logo.view.alpha = 1;
    }];

    [self.logo transitionOpenWithDuration:duration andDelay:duration - 0.1];

    [UIView animateWithDuration:duration delay:2 * duration options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.logo.view.alpha = 1;
        self.titleLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(transitionOut) withObject:self afterDelay:duration];
    }];
}

- (void)transitionOut {
    CGFloat duration = 0.8;

    [UIView animateWithDuration:duration animations:^{
        [self.logo.view moveTo:CGPointMake(- self.logo.view.frame.size.width, self.logo.view.frame.origin.y)];
    }];

    [UIView animateWithDuration:duration delay:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.titleLabel moveTo:CGPointMake(- self.titleLabel.frame.size.width, self.titleLabel.frame.origin.y)];
    } completion:^(BOOL finished) {
        [self toHome];
    }];
}


@end
