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
#import "DataManager.h"
#import "UIViewControllerPicasso.h"
#import "UIViewPicasso.h"
#import "SceneChooser.h"
#import "UIView+EasingFunctions.h"
#import "easing.h"
#import "Events.h"
#import "TextUtils.h"

#define kLogoPositionVariant -40
#define kButtonsPositionVariant 20
#define kLogoOpacityDuration 2
#define kLogoPositionDuration 0.6

@interface Home ()

@property (strong, nonatomic) NSString *nextViewName;
@property (assign, nonatomic) BOOL fadeVideo;

@end

@implementation Home

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    
    [self updateRotation];

    [self initButtons];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[[MotionVideoPlayer sharedInstance] view] setAlpha:0];
    [[MotionVideoPlayer sharedInstance] rotatePlayerToPortrait];

    for(UIButton *button in @[self.exploreButton, self.galleryButton, self.museumButton, self.creditsButton]) {
        [button moveTo:CGPointMake([OrientationUtils nativeDeviceSize].size.width / 2 + button.frame.size.width, button.frame.origin.y)];
        button.alpha = 0;
    }

    [[MotionVideoPlayer sharedInstance] fadeIn];
    if([[[DataManager sharedInstance] getGameModel] introCompleted]) {
        [[MotionVideoPlayer sharedInstance] showMenuVideo];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loopVideoMenu) name:[MPPEvents PlayerObservedTimeEvent] object:nil];
        [[MotionVideoPlayer sharedInstance] startToListenForUpdatesWithTime:22.4];
        [self transitionIn];
    }
    else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(introCompleted) name:[MPPEvents PlayerObservedTimeEvent] object:nil];
        [[MotionVideoPlayer sharedInstance] startToListenForUpdatesWithTime:19];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipIntro:)];
        tapRecognizer.delegate = self;
        [self.view addGestureRecognizer:tapRecognizer];
    }
}

- (void)skipIntro:(UITapGestureRecognizer *)recognizer {
    [self.view removeGestureRecognizer:recognizer];
    
    [UIView animateWithDuration:0.3 animations:^{
        [[[MotionVideoPlayer sharedInstance] view] setAlpha:0];
        [self loopVideoMenu];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            [[[MotionVideoPlayer sharedInstance] view] setAlpha:1];
        } completion:^(BOOL finished) {
            [self introCompleted];
        }];
    }];
}

- (void)loopVideoMenu {
    [[[MotionVideoPlayer sharedInstance] player] seekToTime:CMTimeMakeWithSeconds(20, 1.0)];
}

- (void)introCompleted {
    [[MotionVideoPlayer sharedInstance] stopListeningForUpdates];
    [[[DataManager sharedInstance] getGameModel] setIntroCompleted:YES];
    [self transitionIn];
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
        [button setEasingFunction:QuadraticEaseInOut forKeyPath:@"frame"];
        [button setAttributedTitle:[TextUtils getKernedString:button.titleLabel.text] forState:UIControlStateNormal];
    }

    // This one is the reference
    [self.galleryButton moveTo:CGPointMake(self.galleryButton.frame.origin.x, [OrientationUtils nativeDeviceSize].size.height / 2 - self.galleryButton.frame.size.height / 2 - 40)];
    [self.exploreButton moveTo:CGPointMake(self.exploreButton.frame.origin.x, self.galleryButton.frame.origin.y - 40 - self.exploreButton.frame.size.height)];
    [self.museumButton moveTo:CGPointMake(self.museumButton.frame.origin.x, [OrientationUtils nativeDeviceSize].size.height / 2 - self.galleryButton.frame.size.height / 2 + 40)];
    [self.creditsButton moveTo:CGPointMake(self.creditsButton.frame.origin.x, self.museumButton.frame.origin.y + self.museumButton.frame.size.height + 40)];
}


- (void)transitionIn {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loopVideoMenu) name:[MPPEvents PlayerObservedTimeEvent] object:nil];
    [[MotionVideoPlayer sharedInstance] startToListenForUpdatesWithTime:22.4];
    CGFloat delay = 0;
    CGFloat duration = 0.8;
    for(UIButton *button in @[self.exploreButton, self.galleryButton, self.museumButton, self.creditsButton]) {
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [button moveTo:CGPointMake([OrientationUtils nativeDeviceSize].size.width / 2 - button.frame.size.width / 2, button.frame.origin.y)];
            button.alpha = 1;
        } completion:nil];
        delay += 0.05;
    }
}

- (void)prepareTransitionOut:(id)sender {
    [[MotionVideoPlayer sharedInstance] stopListeningForUpdates];
    NSArray *buttonsOrder;
    self.fadeVideo = YES;
    switch([sender tag]) {
        case 0:
            self.nextViewName = @"SceneChooser";
            buttonsOrder = @[self.exploreButton, self.galleryButton, self.museumButton, self.creditsButton];
            self.fadeVideo = NO;
            break;
        case 1:
            self.nextViewName = @"GalleryViewController";
            buttonsOrder = @[self.galleryButton, self.exploreButton, self.museumButton, self.creditsButton];
            break;
        case 2:
            self.nextViewName = @"Museum";
            buttonsOrder = @[self.museumButton, self.creditsButton, self.galleryButton, self.exploreButton];
            break;
        case 3:
            self.nextViewName = @"Credits";
            buttonsOrder = @[self.creditsButton, self.museumButton, self.galleryButton, self.exploreButton];
            break;
    }
    [self transitionOutWithOrder:buttonsOrder];
}

- (void)transitionOutWithOrder:(NSArray *)order {
    CGFloat delay = 0;
    CGFloat duration = 0.8;
    int i = 0;
    for(UIButton *button in order) {
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [button moveTo:CGPointMake(-button.frame.size.width * 1.2, button.frame.origin.y)];
            button.alpha = 0;
        } completion:^(BOOL finished) {
            if(i == 3) {
                [self videoTransitionOut];
            }
        }];
        i++;
        delay += 0.08;
    }
}

- (void)videoTransitionOut {
    if(self.fadeVideo) {
        [UIView animateWithDuration:0.6 animations:^{
            [[[MotionVideoPlayer sharedInstance] view] setAlpha:0];
        } completion:^(BOOL finished) {
            [self transitionOutComplete];
        }];
    }
    else {
        [[[MotionVideoPlayer sharedInstance] player] seekToTime:CMTimeMakeWithSeconds(23.8, 1.0)];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transitionOutComplete) name:[MPPEvents PlayerObservedTimeEvent] object:nil];
        [[MotionVideoPlayer sharedInstance] startToListenForUpdatesWithTime:24];
    }
}

- (void)transitionOutComplete {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[MotionVideoPlayer sharedInstance] stopListeningForUpdates];
    UIViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:self.nextViewName];
    [self.navigationController pushViewController:nextViewController animated:NO];
}

@end
