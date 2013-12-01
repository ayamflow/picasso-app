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
#import "UIViewControllerPicasso.h"
#import "UIViewPicasso.h"
#import "SceneChooser.h"

#define kLogoPositionVariant -40
#define kButtonsPositionVariant 20
#define kLogoOpacityDuration 2
#define kLogoPositionDuration 0.6

@interface Home ()

@property (strong, nonatomic) NSString *nextViewName;

@end

@implementation Home

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)stopVideo {
	[[[MotionVideoPlayer sharedInstance] player] setRate:0.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    
    [self updateRotation];
    
    [self initLabels];
    [self initButtons];

    [self transitionIn];
}

- (void)initLabels {
    self.titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Regular" size:12.0];
    self.titleLabel.text = [@"sur les traces\ndu maître picasso" uppercaseString];
    self.travelLabel.text = [self.travelLabel.text uppercaseString];
    self.museumLabel.text = [self.museumLabel.text uppercaseString];
}

- (void)initButtons {
    int i = 0;
    for(UIButton *button in @[self.exploreButton, self.galleryButton, self.museumButton, self.creditsButton]) {
        button.tag = i++;
        button.titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Medium" size:15];
        [button addTarget:self action:@selector(prepareTransitionOut:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
        [button addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    }

    // This one is the reference
    [self.galleryButton moveTo:CGPointMake(self.galleryButton.frame.origin.x, [OrientationUtils nativeDeviceSize].size.height / 2 - self.galleryButton.frame.size.height / 2 - 40)];
    [self.exploreButton moveTo:CGPointMake(self.exploreButton.frame.origin.x, self.galleryButton.frame.origin.y - 40 - self.exploreButton.frame.size.height)];
    [self.museumButton moveTo:CGPointMake(self.museumButton.frame.origin.x, [OrientationUtils nativeDeviceSize].size.height / 2 - self.galleryButton.frame.size.height / 2 + 40)];
    [self.creditsButton moveTo:CGPointMake(self.creditsButton.frame.origin.x, self.museumButton.frame.origin.y + self.museumButton.frame.size.height + 40)];
}


- (void)transitionIn {
    CGFloat delay = 0;
    CGFloat duration = 0.8;
    for(UIButton *button in @[self.exploreButton, self.galleryButton, self.museumButton, self.creditsButton]) {
        [button moveTo:CGPointMake([OrientationUtils nativeDeviceSize].size.width / 2 + button.frame.size.width, button.frame.origin.y)];
        button.alpha = 0;

        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [button moveTo:CGPointMake([OrientationUtils nativeDeviceSize].size.width / 2 - button.frame.size.width / 2, button.frame.origin.y)];
            button.alpha = 1;
        } completion:nil];
        delay += 0.05;
    }
}

- (void)prepareTransitionOut:(id)sender {
    [self stopVideo];
    switch([sender tag]) {
        case 0:
            self.nextViewName = @"SceneChooser";
            break;
        case 1:
            self.nextViewName = @"GalleryViewController";
            break;
        case 2:
            self.nextViewName = @"Museum";
            break;
        case 3:
            self.nextViewName = @"Credits";
            break;
    }
    [self transitionOut];
}

- (void)transitionOut {
    CGFloat delay = 0;
    CGFloat duration = 0.8;
    for(UIButton *button in @[self.exploreButton, self.galleryButton, self.museumButton, self.creditsButton]) {
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [button moveTo:CGPointMake(-button.frame.size.width, button.frame.origin.y)];
            button.alpha = 0;
        } completion:^(BOOL finished) {

            if(delay > 0.10) {
                [self transitionOutComplete];
            }
        }];
        delay += 0.05;
    }
}

- (void)transitionOutComplete {
    UIViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:self.nextViewName];
    [self.navigationController pushViewController:nextViewController animated:NO];
}

@end
