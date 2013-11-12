//
//  Home.m
//  Picasso
//
//  Created by Florian Morel on 04/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Home.h"
#import "MotionVideoPlayer.h"
#import "OrientationUtils.h"
#import "Constants.h"

@interface Home ()

@property (assign, nonatomic) BOOL orientationWasLandscape;

@end

@implementation Home

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.hidden = YES;

    self.exploreButton.titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-bold" size:15.0];
    [self.exploreButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 40.0, 0.0, 0.0)];

    self.galleryButton.titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-bold" size:15.0];
    [self.galleryButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 40.0, 0.0, 0.0)];

    self.museumButton.titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-bold" size:15.0];
    [self.museumButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 40.0, 0.0, 0.0)];

    [self.galleryButton addTarget:self action:@selector(stopVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.museumButton addTarget:self action:@selector(stopVideo:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        if(self.orientationWasLandscape) return;
		[self updatePositionToLandscape];
        self.orientationWasLandscape = YES;
    }
	else if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        [self updatePositionToPortrait];
        self.orientationWasLandscape = NO;
    }
}

- (void)updatePositionToPortrait {
    float topPosition = 150.0;
    float leftPosition = [OrientationUtils nativeDeviceSize].size.width / 2;
    float topIncrement = self.exploreButton.frame.size.height + 10.0;

    self.exploreButton.layer.position = CGPointMake(leftPosition, topPosition);
    self.galleryButton.layer.position = CGPointMake(leftPosition, topPosition + topIncrement / 2);
    self.museumButton.layer.position = CGPointMake(leftPosition, topPosition + topIncrement);

    self.logo.layer.position = CGPointMake([OrientationUtils nativeDeviceSize].size.width / 2, 140.0);
}

- (void)updatePositionToLandscape {
    float topPosition = 390.0;
    float leftPosition = ([OrientationUtils nativeDeviceSize].size.height / 2) - self.exploreButton.frame.size.width - 10.0;
    self.exploreButton.layer.position = CGPointMake(leftPosition, topPosition);
    self.galleryButton.layer.position = CGPointMake(self.exploreButton.layer.position.x + self.exploreButton.frame.size.width + 10.0, topPosition);
    self.museumButton.layer.position = CGPointMake(self.galleryButton.layer.position.x + self.galleryButton.frame.size.width + 10.0, topPosition);

    self.logo.layer.position = CGPointMake([OrientationUtils nativeDeviceSize].size.height / 2, 100.0);

}

- (void)stopVideo:(id)sender {
	[[[MotionVideoPlayer sharedInstance] player] setRate:0.0];
}

@end
