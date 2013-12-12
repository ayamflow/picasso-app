//
//  Credits.m
//  Picasso
//
//  Created by MOREL Florian on 11/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Credits.h"
#import "NavigationBarView.h"
#import "OrientationUtils.h"
#import "UIViewPicasso.h"
#import "UIViewControllerPicasso.h"
#import "UIView+EasingFunctions.h"
#import "MotionVideoPlayer.h"
#import "easing.h"
#import "TextUtils.h"
#import "MotionVideoPlayer.h"

#define kNameViewTag 10

@interface Credits ()

@property (strong, nonatomic) NavigationBarView *navigationBar;
@property (assign, nonatomic) BOOL leavingToExplore;

@end

@implementation Credits

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    [self initNavigationBar];
    [self initTexts];
    [self initNames];
    [self initBackground];
    [self updateLetterSpacing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[[MotionVideoPlayer sharedInstance] player] pause];
    [self transitionIn];
}

- (void)transitionIn {
    CGFloat duration = 0.2;
    CGFloat delay = 0;
    
    UIView *names = [self.scrollView viewWithTag:kNameViewTag];
    
    for(UIView *view in @[self.gobelinsLabel, self.navigationBar, self.scrollView]) {
        view.alpha = 0;
        [view moveTo:CGPointMake(view.frame.origin.x, view.frame.origin.y - 20)];
        [view setEasingFunction:QuadraticEaseInOut forKeyPath:@"frame"];
        
        [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
            view.alpha = 1;
            [view moveTo:CGPointMake(view.frame.origin.x, view.frame.origin.y + 20)];
        } completion:nil];
        
        delay += 0.15;
    }
    
    for(UIView *view in names.subviews) {
        view.alpha = 0;
        [view moveTo:CGPointMake(view.frame.origin.x, view.frame.origin.y - 20)];
        [view setEasingFunction:QuadraticEaseInOut forKeyPath:@"frame"];
        
        [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
            view.alpha = 1;
            [view moveTo:CGPointMake(view.frame.origin.x, view.frame.origin.y + 20)];
        } completion:nil];
        
        delay += 0.05;
    }
}

- (void)initBackground {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"simpleBackground" ofType:@".png"];
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
    [self.scrollView addSubview:background];
    [background moveTo:CGPointMake(0, [OrientationUtils nativeDeviceSize].size.height / 2 - background.bounds.size.height / 4)];
    [self.scrollView sendSubviewToBack:background];
    
    NSString *bottomPath = [[NSBundle mainBundle] pathForResource:@"bottomBackground" ofType:@".png"];
    UIImageView *bottomBackground = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:bottomPath]];
    [self.scrollView addSubview:bottomBackground];
    [bottomBackground moveTo:CGPointMake(0, self.scrollView.contentSize.height - bottomBackground.bounds.size.height)];
    [self.scrollView sendSubviewToBack:bottomBackground];
}

- (void)initNavigationBar {
    self.navigationBar = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeDeviceSize].size.width, 50) andTitle:@"Crédits" andShowExploreButton:YES];
    [self.view addSubview:self.navigationBar];
    
    [self.navigationBar.backButton addTarget:self action:@selector(transitionOut) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar.exploreButton addTarget:self action:@selector(outToExplore) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initTexts {
    self.gobelinsLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Medium" size:15];
    self.gobelinsLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.gobelinsLabel.layer.borderWidth = 2;
    self.gobelinsLabel.attributedText = [TextUtils getKernedString:[@"Les Gobelins" uppercaseString]];
}

- (void)initNames {
    UIView *names = [[[NSBundle mainBundle] loadNibNamed:@"Names" owner:self options:nil] objectAtIndex:0];
    names.backgroundColor = [UIColor clearColor];
    names.tag = kNameViewTag;
    [self.scrollView addSubview:names];
    [names moveTo:CGPointMake(0, self.scrollView.frame.origin.y + self.logoGobelins.frame.origin.y + self.logoGobelins.bounds.size.height - 30)];
    
    UILabel *graphicDesigners = (UILabel *)[names viewWithTag:5];
    UILabel *developers = (UILabel *)[names viewWithTag:6];
    UILabel *thanks = (UILabel *)[names viewWithTag:7];
    
    for(UILabel *title in @[graphicDesigners, developers, thanks]) {
        title.font = [UIFont fontWithName:@"BrandonGrotesque-Medium" size:15];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.scrollView.frame.origin.y + self.logoGobelins.bounds.size.height + names.bounds.size.height + self.navigationBar.bounds.size.height * 2);
}

- (void)outToExplore {
    self.leavingToExplore = YES;
    [self transitionOut];
}

- (void)transitionOut {
    CGFloat duration = 0.2;
    CGFloat delay = 0;
    NSInteger transitionDone = 0;
    
    UIView *names = [self.scrollView viewWithTag:kNameViewTag];
    
    for(UIView *view in names.subviews) {
        [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
            view.alpha = 0;
            [view moveTo:CGPointMake(view.frame.origin.x, view.frame.origin.y - 20)];
        } completion:nil];
        
        delay += 0.05;
    }
    
    for(UIView *view in @[self.scrollView, self.navigationBar, self.gobelinsLabel]) {
        [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
            view.alpha = 0;
            [view moveTo:CGPointMake(view.frame.origin.x, view.frame.origin.y - 20)];
        } completion:^(BOOL finished) {
            if(transitionDone == 2) [self transitionOutComplete];
        }];
        
        delay += 0.1;
        transitionDone++;
    }
}

- (void)updateLetterSpacing {
    UIView *names = [self.scrollView viewWithTag:kNameViewTag];
    
    for(UIView *view in names.subviews) {
        if([view isKindOfClass:[UILabel class]]) {
            ((UILabel *)view).attributedText = [TextUtils getKernedString:((UILabel *)view).text];
        }
    }
}

- (void)transitionOutComplete {
    if(self.leavingToExplore) {
        [self toSceneChooser];
    }
    else {
        [self toHome];
    }

}

@end
