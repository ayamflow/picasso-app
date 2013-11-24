//
//  MenuButton.m
//  Picasso
//
//  Created by MOREL Florian on 13/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "MenuButton.h"
#import "UIViewControllerPicasso.h"
#import "UIViewPicasso.h"
#import "Events.h"
#import "MenuLandscape.h"
#import "OrientationUtils.h"

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
    UIImage *sliderImage = [UIImage imageNamed:@"menuSliderDown.png"];
    [self.menuButton setImage:sliderImage forState:UIControlStateNormal];
    self.menuButton.frame = CGRectMake(0, 0, sliderImage.size.width * 2, sliderImage.size.height * 2); // Twice as big to be easier to touch
    [self.menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    self.view = self.menuButton;
}

- (void)showMenu {
    NSLog(@"[MenuButton] showMenu");
/*    [UIView animateWithDuration:0.8 animations:^{
        CGRect screenSize = UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? [OrientationUtils nativeLandscapeDeviceSize] : [OrientationUtils nativeDeviceSize];
        [self.view moveTo:CGPointMake(self.view.frame.origin.x, screenSize.size.height - self.view.frame.size.height)];
    }];

    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[MPPEvents MenuShownEvent] object:self];
        [self.parentViewController showMenuWithOrientation:self.parentViewController.interfaceOrientation andLayer:screenLayer andExploreMode:self.wasExploreMode andSceneMode:self.wasSceneMode];
    }];*/

//    CALayer *screenLayer = [[CALayer alloc] initWithLayer:self.parentViewController.view.layer];
    [[NSNotificationCenter defaultCenter] postNotificationName:[MPPEvents MenuShownEvent] object:self];
    [self.parentViewController showMenuWithOrientation:self.parentViewController.interfaceOrientation andExploreMode:self.wasExploreMode andSceneMode:self.wasSceneMode];

//    [self.parentViewController showMenuWithOrientation:self.parentViewController.interfaceOrientation andLayer:screenLayer andExploreMode:self.wasExploreMode andSceneMode:self.wasSceneMode];

//    [self.parentViewController showMenuWithExploreMode:self.wasExploreMode andSceneMode:self.wasSceneMode];
}

@end
