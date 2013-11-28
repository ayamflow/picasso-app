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
#import "SceneChooser.h"

#define kLogoPositionVariant -40
#define kButtonsPositionVariant 20
#define kLogoOpacityDuration 2
#define kLogoPositionDuration 0.6

@interface Home ()

@property (assign, nonatomic) BOOL transitionCompleted;

// Transitions
@property (assign, nonatomic) NSInteger transitionOutNumber;
@property (assign, nonatomic) NSInteger transitionOutDone;

@end

@implementation Home

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)stopVideo:(id)sender {
	[[[MotionVideoPlayer sharedInstance] player] setRate:0.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateRotation];
    
    self.transitionCompleted = NO;
    
    [self hideNavigationBar];
    
    [self initLabels];
    [self initButtons];
//    [self initLogo];
//    [self startIntroTransition];
}

- (void)initLabels {
    self.titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Regular" size:12.0];
    self.titleLabel.text = [@"sur les traces\ndu maître picasso" uppercaseString];
    self.travelLabel.text = [self.travelLabel.text uppercaseString];
    self.museumLabel.text = [self.museumLabel.text uppercaseString];
}

- (void)initButtons {
    for(UIButton *button in @[self.exploreButton, self.galleryButton, self.museumButton, self.creditsButton]) {
        button.titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Medium" size:15];
    }
    // Going to gallery, musem or gallery mode stops the video
    [self.exploreButton addTarget:self action:@selector(transitionOutComplete) forControlEvents:UIControlEventTouchUpInside];
    [self.galleryButton addTarget:self action:@selector(stopVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.museumButton addTarget:self action:@selector(stopVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.creditsButton addTarget:self action:@selector(stopVideo:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initLogo {
    self.logo = [[Logo alloc] init];
    [self.view addSubview:self.logo.view];
    [self.logo.view moveTo:CGPointMake([OrientationUtils nativeDeviceSize].size.width / 2 - self.logo.view.frame.size.width / 2, [OrientationUtils nativeDeviceSize].size.height / 4 - self.logo.view.frame.size.height)];
//    [self.logo transitionOpenWithDuration:0.8 andDelay:0.2];
}

- (void)startIntroTransition {
//    self.logo.view.alpha = 0;

    MotionVideoPlayer *player = [MotionVideoPlayer sharedInstance];
    player.view.alpha = 0;
    
    self.exploreButton.alpha = 0;
    self.galleryButton.alpha = 0;
    self.museumButton.alpha = 0;
    self.creditsButton.alpha = 0;
    
//    [self startTransitionLogoOpacityAt:0];
//    [self.logo transitionOpenWithDuration:kLogoOpacityDuration andDelay:0.5];
//    [self startTransitionBackgroundOpacityAt:1.2];
//    [self startTransitionLogoPositionAt: 3.5];
    [self startTransitionButtonsAt: 0.2];
}

- (void)startTransitionLogoOpacityAt:(NSTimeInterval)startTime {
   [UIView animateWithDuration:kLogoOpacityDuration delay:startTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
       self.logo.view.alpha = 1;
   } completion:^(BOOL finished) {
       
   }];
}

- (void)startTransitionBackgroundOpacityAt:(NSTimeInterval)startTime {
    MotionVideoPlayer *player = [MotionVideoPlayer sharedInstance];
    [UIView animateWithDuration:kLogoOpacityDuration delay:startTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
        player.view.alpha = 1;
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
    NSArray *buttons = [NSArray arrayWithObjects:self.exploreButton, self.galleryButton, self.museumButton, self.creditsButton, nil];
    float timeInterval = 0.05;
    int i = 0;
    for(UIButton *button in buttons) {
        [button moveTo:CGPointMake(button.frame.origin.x, button.frame.origin.y + kButtonsPositionVariant)];
        
        [UIView animateWithDuration:kLogoPositionDuration delay:startTime + i * timeInterval options:UIViewAnimationOptionCurveEaseOut animations:^{
            button.alpha = 1;
            [button moveTo:CGPointMake(button.frame.origin.x, button.frame.origin.y - kButtonsPositionVariant)];
        } completion:^(BOOL finished) {
            self.transitionCompleted = YES;
        }];
        i++;
    }
}

- (void)transitionOutToExplore {
    NSTimeInterval outDuration = 1;
    self.transitionOutDone = 0;
    self.transitionOutNumber = 0;

    [self translateElementOut:self.exploreButton at:0 withDuration: outDuration];
    [self translateElementOut:self.logo.view at:0.1 withDuration:outDuration];
    [self translateElementOut:self.galleryButton at:0.05 withDuration:outDuration];
    [self translateElementOut:self.museumButton at:0.1 withDuration:outDuration];
    [self translateElementOut:self.creditsButton at:0.15 withDuration:outDuration];
}

- (void)translateElementOut:(UIView *)view at:(NSTimeInterval)startTime withDuration:(NSTimeInterval)duration {
	self.transitionOutNumber++;
    CGRect screenSize = [OrientationUtils nativeLandscapeDeviceSize];
    [UIView animateWithDuration:duration delay:startTime options:UIViewAnimationOptionTransitionNone animations:^{
        view.layer.position = CGPointMake(view.layer.position.x - screenSize.size.width, view.layer.position.y);
    } completion:^(BOOL finished) {
        if(++self.transitionOutDone == self.transitionOutNumber) {
            [self transitionOutComplete];
        }
    }];
}

- (void)transitionOutComplete {
    [self navigateToExploreMode];
}

@end
