//
//  MenuButton.m
//  Picasso
//
//  Created by MOREL Florian on 13/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "MenuButton.h"
#import "UIViewControllerPicasso.h"
#import "Events.h"
#import "Menu.h"

@interface MenuButton ()

@property (strong, nonatomic) UIButton *menuButton;

@end

@implementation MenuButton

- (id)initWithExploreMode:(BOOL)isExploreMode {
    if(self = [super init]) {
        self.wasExploreMode = isExploreMode;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initButton];
}

- (void)initButton {
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *sliderImage = [UIImage imageNamed:@"menuSlider.png"];
    [self.menuButton setImage:sliderImage forState:UIControlStateNormal];
    self.menuButton.frame = CGRectMake(0, 0, sliderImage.size.width * 2, sliderImage.size.height * 2); // Twice as big to be easier to touch
    [self.menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    self.view = self.menuButton;
}

- (void)showMenu {
    [[NSNotificationCenter defaultCenter] postNotificationName:[MPPEvents MenuShownEvent] object:self];
    [self.parentViewController showMenuWithExploreMode:self.wasExploreMode andSceneMode:self.wasSceneMode];
}

@end
