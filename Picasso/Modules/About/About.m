//
//  About.m
//  Picasso
//
//  Created by Florian Morel on 04/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "About.h"
#import "MenuButton.h"
#import "OrientationUtils.h"

@interface About ()

@property (strong, nonatomic) MenuButton *menuButton;

@end

@implementation About

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMenu];
}

- (void)initMenu {
    self.menuButton = [[MenuButton alloc] initWithExploreMode:NO andPosition:CGPointMake([OrientationUtils nativeDeviceSize].size.width / 2 - self.menuButton.view.frame.size.width / 2, self.menuButton.view.frame.size.height)];
    [self addChildViewController:self.menuButton];
    [self.view addSubview:self.menuButton.view];
    [self.view bringSubviewToFront:self.menuButton.view];
}

@end
