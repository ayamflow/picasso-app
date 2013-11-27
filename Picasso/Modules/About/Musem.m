//
//  About.m
//  Picasso
//
//  Created by Florian Morel on 04/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Musem.h"
#import "SceneChooser.h"
#import "UIViewPicasso.h"
#import "OrientationUtils.h"

@interface Musem ()

@end

@implementation Musem

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTexts];
    [self initButtons];
    
    // Testing
    self.scrollView.contentSize = CGSizeMake([OrientationUtils nativeDeviceSize].size.width, 5000);
    self.tableView.scrollEnabled = NO;
    
    // Sliding blocks :
        // horaires
        // infos
        // map
        // réserver
        // à propos
}

- (void)initTexts {
    self.navTitle.font = [UIFont fontWithName:@"BrandonGrotesque-Bold" size:22];
    self.hotelTitle.font = [UIFont fontWithName:@"AvenirLTStd-Black" size:20];
    self.hotelTitle.layer.borderColor = [UIColor whiteColor].CGColor;
    self.hotelTitle.layer.borderWidth = 2;
    self.hotelSubtitle.font = [UIFont fontWithName:@"AvenirLTStd-Roman" size:13];
}

- (void)initButtons {
    [self.backButton addTarget:self action:@selector(navigateBack) forControlEvents:UIControlEventTouchUpInside];
    [self.exploreButton addTarget:self action:@selector(navigateToExplore) forControlEvents:UIControlEventTouchUpInside];
}

- (void)navigateBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigateToExplore {
    SceneChooser *sceneChooser = [self.storyboard instantiateViewControllerWithIdentifier:@"SceneChooser"];
    [self.navigationController pushViewController:sceneChooser animated:NO];
    
}

@end