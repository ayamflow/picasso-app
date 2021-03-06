//
//  NavigationBar.m
//  Picasso
//
//  Created by Florian Morel on 30/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "NavigationBarView.h"
#import "UIViewPicasso.h"
#import "UIView+EasingFunctions.h"
#import "easing.h"
#import "TextUtils.h"

#define kMenuMargin 20

@interface NavigationBarView ()

@property (strong, nonatomic) NSString *title;

@end

@implementation NavigationBarView

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andShowExploreButton:(BOOL)showExploreButton {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.title = title;
        self.hasExploreButton = showExploreButton;
        [self initBackButton];
        [self initTitle];
        if(self.hasExploreButton) [self initExploreButton];
        
        [self sendSubviewToBack:self.titleLabel];
    }
    return self;
}

- (void)initBackButton {
    UIImage *backIcon = [UIImage imageNamed:@"menuHamburger.png"];
	self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backIcon.size.width * 3, backIcon.size.height * 3)];
    [self.backButton setImage:backIcon forState:UIControlStateNormal];

    [self addSubview:self.backButton];
    [self.backButton moveTo:CGPointMake(0, self.frame.size.height / 2 - self.backButton.frame.size.height / 2)];
    [self.backButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.backButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];

    [self.backButton setEasingFunction:QuadraticEaseInOut forKeyPath:@"frame"];
    [self.backButton setEasingFunction:QuadraticEaseInOut forKeyPath:@"alpha"];
}

- (void)initTitle {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMenuMargin, self.frame.size.height * 0.1, self.frame.size.width - 2 * kMenuMargin, self.frame.size.height * 0.8)];
    self.titleLabel.attributedText = [TextUtils getKernedString:[self.title uppercaseString]];
    self.titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Medium" size:18];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.titleLabel];
}

- (void)initExploreButton {
    UIImage *exploreIcon = [UIImage imageNamed:@"navExploreButton.png"];
	self.exploreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, exploreIcon.size.width * 2, exploreIcon.size.height * 4)];
    [self.exploreButton setImage:exploreIcon forState:UIControlStateNormal];

    [self addSubview:self.exploreButton];
    [self.exploreButton moveTo:CGPointMake(self.frame.size.width - self.exploreButton.frame.size.width, self.frame.size.height / 2 - self.exploreButton.frame.size.height / 2)];
    [self.exploreButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.exploreButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.exploreButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];

    [self.exploreButton setEasingFunction:QuadraticEaseInOut forKeyPath:@"frame"];
    [self.exploreButton setEasingFunction:QuadraticEaseInOut forKeyPath:@"alpha"];
}

- (void)buttonTouchDown:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.alpha = 0.7;
}

- (void)buttonTouchUp:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.alpha = 1;
}

@end
