//
//  NavigationBar.m
//  Picasso
//
//  Created by Florian Morel on 30/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "NavigationBarView.h"
#import "UIViewPicasso.h"

@interface NavigationBarView ()

@property (strong, nonatomic) NSString *title;

@end

@implementation NavigationBarView

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andShowExploreButton:(BOOL)showExploreButton {
    if(self = [super initWithFrame:frame]) {
        self.title = title;
        self.hasExploreButton = showExploreButton;
        [self initBackButton];
        [self initTitle];
        if(self.hasExploreButton) [self initExploreButton];
    }
    return self;
}

- (void)initBackButton {
    UIImage *backIcon = [UIImage imageNamed:@"navBackButton.png"];
	self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backIcon.size.width * 1.5, backIcon.size.height * 1.5)];
    [self.backButton setImage:backIcon forState:UIControlStateNormal];

    [self addSubview:self.backButton];
    [self.backButton moveTo:CGPointMake(25, self.frame.size.height / 2 - self.backButton.frame.size.height / 2)];
    [self.backButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.backButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)initTitle {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.15, self.frame.size.height * 0.1, self.frame.size.width * 0.7, self.frame.size.height * 0.8)];
    self.titleLabel.text = [self.title uppercaseString];
    self.titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Medium" size:18];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.titleLabel];
}

- (void)initExploreButton {
    UIImage *exploreIcon = [UIImage imageNamed:@"navExploreButton.png"];
	self.exploreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, exploreIcon.size.width * 1.5, exploreIcon.size.height * 3)];
    [self.exploreButton setImage:exploreIcon forState:UIControlStateNormal];

    [self addSubview:self.exploreButton];
    [self.exploreButton moveTo:CGPointMake(self.frame.size.width - self.exploreButton.frame.size.width - 25, self.frame.size.height / 2 - self.exploreButton.frame.size.height / 2)];
    [self.exploreButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.exploreButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.exploreButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
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
