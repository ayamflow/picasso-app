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
#import "Logo.h"
#import "UIViewControllerPicasso.h"
#import "UIViewPicasso.h"

#define kLogoPositionVariant -40
#define kButtonsPositionVariant 40
#define kLogoOpacityDuration 2
#define kLogoPositionDuration 1.2

@interface Home ()

@property (assign, nonatomic) BOOL orientationWasLandscape;
@property (assign, nonatomic) BOOL transitionCompleted;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end

@implementation Home

- (void)viewDidLoad {
    [super viewDidLoad];

    self.transitionCompleted = NO;
    self.backgroundImage.image = [UIImage imageNamed:@"homeBackground.png"];
    [self.view sendSubviewToBack:self.backgroundImage];
    
    [self hideNavigationBar];
    [self initLogo];
    [self initButtons];
    [self startIntroTransition];
}

- (void)initLogo {
    self.logo = [[Logo alloc] init];
    [self.view addSubview:self.logo.view];
    CGRect logoFrame = self.logo.view.frame;
    logoFrame.origin.x = [OrientationUtils deviceSize].size.width / 2 - logoFrame.size.width / 2;
    logoFrame.origin.y = [OrientationUtils deviceSize].size.height / 2 - logoFrame.size.height;// / 2;
    self.logo.view.frame = logoFrame;
}

- (void)initButtons {
    self.exploreButton.titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-bold" size:15.0];
    [self.exploreButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 40.0, 0.0, 0.0)];
    
    self.galleryButton.titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-bold" size:15.0];
    [self.galleryButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 40.0, 0.0, 0.0)];
    
    self.museumButton.titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-bold" size:15.0];
    [self.museumButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 40.0, 0.0, 0.0)];
    
    [self.galleryButton addTarget:self action:@selector(stopVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.museumButton addTarget:self action:@selector(stopVideo:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startIntroTransition {
    self.logo.view.alpha = 0;
    self.backgroundImage.alpha = 0;
    self.exploreButton.alpha = 0;
    self.galleryButton.alpha = 0;
    self.museumButton.alpha = 0;
    
    [self startTransitionLogoOpacityAt:0.2];
    [self.logo transitionOpenWithDuration:kLogoOpacityDuration andDelay:0.5];
    [self startTransitionBackgroundOpacityAt:1.2];
    [self startTransitionLogoPositionAt: 3.5];
    [self startTransitionButtonsAt: 3.5];
}

- (void)startTransitionLogoOpacityAt:(NSTimeInterval)startTime {
   [UIView animateWithDuration:kLogoOpacityDuration delay:startTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
       self.logo.view.alpha = 1;
   } completion:^(BOOL finished) {
       
   }];
}

- (void)startTransitionBackgroundOpacityAt:(NSTimeInterval)startTime {
    [UIView animateWithDuration:kLogoOpacityDuration delay:startTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundImage.alpha = 1;
    } completion:^(BOOL finished) {

    }];
}

- (void)startTransitionLogoPositionAt:(NSTimeInterval)startTime {
    [UIView animateWithDuration:kLogoPositionDuration delay:startTime options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGPoint logoPosition = self.logo.view.layer.position;
        logoPosition.y += kLogoPositionVariant;
        self.logo.view.layer.position = logoPosition;
    } completion:^(BOOL finished) {

    }];
}

- (void)startTransitionButtonsAt:(NSTimeInterval)startTime {
    NSArray *buttons = [NSArray arrayWithObjects:self.exploreButton, self.galleryButton, self.museumButton, nil];
    float timeInterval = 0.25;
    int i = 0;
    for(UIButton *button in buttons) {
        CGPoint oldPosition = button.layer.position;
        CGPoint newPosition = button.layer.position;
        newPosition.y += kButtonsPositionVariant;
        button.layer.position = newPosition;
        
        [UIView animateWithDuration:kLogoPositionDuration delay:startTime + i * timeInterval options:UIViewAnimationOptionCurveEaseOut animations:^{
            button.alpha = 1;
            button.layer.position = oldPosition;
        } completion:^(BOOL finished) {
            self.transitionCompleted = YES;
        }];
        i++;
    }
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
    float topPosition = [OrientationUtils nativeLandscapeDeviceSize].size.height / 2;
    float leftPosition = [OrientationUtils nativeDeviceSize].size.width / 2;
    float topIncrement = self.exploreButton.frame.size.height + 10.0;
    
    [self.exploreButton moveTo:CGPointMake(leftPosition - self.exploreButton.frame.size.width / 2, topPosition)];
    [self.galleryButton moveTo:CGPointMake(leftPosition - self.exploreButton.frame.size.width / 2, topPosition + topIncrement / 2)];
    [self.museumButton moveTo:CGPointMake(leftPosition - self.exploreButton.frame.size.width / 2, topPosition + topIncrement)];

    self.backgroundImage.frame = [OrientationUtils nativeDeviceSize];

    if(self.transitionCompleted) {
        [self.logo.view moveTo:CGPointMake([OrientationUtils nativeDeviceSize].size.width / 2 - self.logo.view.frame.size.width / 2, [OrientationUtils nativeDeviceSize].size.height / 2 - self.logo.view.frame.size.height / 2 + kLogoPositionVariant * 2)];
    }
    else {
        [self.logo.view moveTo:CGPointMake([OrientationUtils nativeDeviceSize].size.width / 2 - self.logo.view.frame.size.width / 2, [OrientationUtils nativeDeviceSize].size.height / 2 - self.logo.view.frame.size.height / 2 + kLogoPositionVariant)];
    }
}

- (void)updatePositionToLandscape {
    float topPosition = [OrientationUtils nativeDeviceSize].size.height * 2 / 3;
    float leftPosition = ([OrientationUtils nativeLandscapeDeviceSize].size.width / 2) - self.exploreButton.frame.size.width * 1.5 - 10.0;
    
    [self.exploreButton moveTo:CGPointMake(leftPosition, topPosition)];
    [self.galleryButton moveTo:CGPointMake(leftPosition + self.exploreButton.frame.size.width + 10.0, topPosition)];
    [self.museumButton moveTo:CGPointMake(leftPosition + 2 * (self.exploreButton.frame.size.width + 10.0), topPosition)];

    self.backgroundImage.frame = [OrientationUtils nativeLandscapeDeviceSize];

    if(self.transitionCompleted) {
        [self.logo.view moveTo:CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - self.logo.view.frame.size.width / 2, [OrientationUtils nativeLandscapeDeviceSize].size.height / 2 - self.logo.view.frame.size.height / 2 + kLogoPositionVariant)];
    }
    else {
        [self.logo.view moveTo:CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - self.logo.view.frame.size.width / 2, [OrientationUtils nativeLandscapeDeviceSize].size.height / 2 - self.logo.view.frame.size.height / 2)];
    }
}

- (void)stopVideo:(id)sender {
	[[[MotionVideoPlayer sharedInstance] player] setRate:0.0];
}

@end
