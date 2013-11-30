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
	self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backIcon.size.width, backIcon.size.height)];
    [self.backButton setImage:backIcon forState:UIControlStateNormal];

    [self addSubview:self.backButton];
    [self.backButton moveTo:CGPointMake(self.backButton.frame.size.width, self.frame.size.height / 2 - self.backButton.frame.size.height / 2)];
}

- (void)initTitle {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.15, self.frame.size.height * 0.1, self.frame.size.width * 0.7, self.frame.size.height * 0.8)];
    self.titleLabel.text = [self.title uppercaseString];
    self.titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Medium" size:20];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.titleLabel];
}

- (void)initExploreButton {
    UIImage *exploreIcon = [UIImage imageNamed:@"navExploreButton.png"];
	self.exploreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, exploreIcon.size.width, exploreIcon.size.height)];
    [self.exploreButton setImage:exploreIcon forState:UIControlStateNormal];

    [self addSubview:self.exploreButton];
    [self.exploreButton moveTo:CGPointMake(self.frame.size.width - 2 * self.exploreButton.frame.size.width, self.frame.size.height / 2 - self.exploreButton.frame.size.height / 2)];
}

@end
