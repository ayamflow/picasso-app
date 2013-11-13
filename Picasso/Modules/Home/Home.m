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
#import "TransitionUtil.h"

@interface Home ()

@property (assign, nonatomic) BOOL orientationWasLandscape;

@end

@implementation Home

- (void)viewDidLoad {
    [super viewDidLoad];

    [self hideNavigationBar];
    [self initButtons];
    [self startIntroTransition];
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
    NSLog(@"start intro");
    // 1) logo alpha
    self.logo.alpha = 0;
    // Place logo in center
    
    // 2) bg alpha
    // 3) logo y + buttons y & alpha
    self.exploreButton.alpha = 0;
    self.galleryButton.alpha = 0;
    self.museumButton.alpha = 0;
    
//    [self transitionLogoOpacity];
}

- (void)transitionLogoOpacity {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.5];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    CABasicAnimation *logoTransition = [CABasicAnimation animationWithKeyPath:@"opacity"];
    logoTransition.fromValue = [NSNumber numberWithFloat:0.0];
    logoTransition.toValue = [NSNumber numberWithFloat:1.0];
    logoTransition.delegate = self;
    logoTransition.beginTime = CACurrentMediaTime() + 1;
    [logoTransition setValue:@"logoAlpha" forKey:@"id"];
    
    [self.logo.layer addAnimation:logoTransition forKey:@"logoAlpha"];
    [CATransaction commit];
}

- (void)transitionLogoPosition {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.7];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    CGPoint logoPosition = self.logo.layer.position;
    CABasicAnimation *logoPositionTransition = [CABasicAnimation animationWithKeyPath:@"position"];
    logoPositionTransition.fromValue = [NSValue valueWithCGPoint:CGPointMake(logoPosition.x, logoPosition.y + 20)];
    logoPositionTransition.toValue = [NSValue valueWithCGPoint: logoPosition];
    logoPositionTransition.delegate = self;
    [logoPositionTransition setValue:@"logoPosition" forKey:@"id"];
    
    // Kick it !
    [self.logo.layer addAnimation:logoPositionTransition forKey:@"logoPosition"];
    [CATransaction commit];
}

- (void)transitionButtons {
    NSLog(@"buttonsTransition");
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.7];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    NSArray *layersArray = [NSArray arrayWithObjects:self.exploreButton.layer, self.galleryButton.layer, self.museumButton.layer, nil];
    float timeOffset = 0;
    for(CALayer *layer in layersArray) {
        // Opacity transition
        CABasicAnimation *opacityTransition = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityTransition setValue:[NSString stringWithFormat:@"buttonOpacity%i", (int)(1 + timeOffset / 0.2)] forKey:@"id"];
        opacityTransition.delegate = self;
        opacityTransition.fromValue = [NSNumber numberWithFloat:0.0];
        opacityTransition.toValue = [NSNumber numberWithFloat:1.0];
        opacityTransition.beginTime = CACurrentMediaTime() + timeOffset;
        [layer addAnimation:opacityTransition forKey:nil];

        // Position transition
        CABasicAnimation *positionTransition = [CABasicAnimation animationWithKeyPath:@"position"];
        CGPoint position = layer.position;
        [positionTransition setValue:[NSString stringWithFormat:@"buttonPosition%i", (int)(1 + timeOffset / 0.2)] forKey:@"id"];
        positionTransition.delegate = self;
        positionTransition.fromValue = [NSValue valueWithCGPoint:CGPointMake(position.x, position.y + 20)];
        opacityTransition.toValue = [NSValue valueWithCGPoint:position];
        positionTransition.beginTime = CACurrentMediaTime() + timeOffset;
        [layer addAnimation:positionTransition forKey:nil];
        
        timeOffset += 0.2;
    }
    [CATransaction commit];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    NSLog(@"animationDidStop: %@", [anim valueForKey:@"id"]);
    NSString *transitionId = [anim valueForKey:@"id"];
    if([transitionId isEqualToString:@"logoAlpha"]) {
        self.logo.alpha = 1;
        [self transitionLogoPosition];
        [self transitionButtons];
    }
    else if([transitionId isEqualToString:@"logoPosition"]) {

    }
    else if([transitionId isEqualToString:@"buttonOpacity1"]) {
        self.exploreButton.alpha = 1;
    }
    else if([transitionId isEqualToString:@"buttonOpacity2"]) {
        self.galleryButton.alpha = 1;
    }
    else if([transitionId isEqualToString:@"buttonOpacity3"]) {
        self.museumButton.alpha = 1;
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
