//
//  SceneChooserViewController.m
//  Picasso
//
//  Created by MOREL Florian on 31/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "SceneChooser.h"
#import "DataManager.h"
#import "SceneManager.h"
#import "UIViewControllerPicasso.h"
#import "UIViewPicasso.h"
#import "Colors.h"
#import "OrientationUtils.h"
#import "ScenePreviewView.h"
#import "SceneModel.h"
#import "iCarousel.h"
#import "Home.h"
#import "NavigationBarView.h"
#import "DashedPathView.h"
#import "StatsFooterView.h"
#import "Events.h"

#define kDirectionNone 0
#define kDirectionLeft 1
#define kDirectionRight 2

@interface SceneChooser ()

@property (strong, nonatomic) NSArray *previews;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *dateLabel;

@property (strong, nonatomic) NavigationBarView *navigationBar;

@property (strong, nonatomic) UIImageView *leftArrow;
@property (strong, nonatomic) UIImageView *rightArrow;

@property (strong, nonatomic) StatsFooterView *bottomInfos;

@end

@implementation SceneChooser

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.view.backgroundColor = [UIColor clearColor];

    [self initNavBar];

    [self initBottomInfos];

    [self initPreviews];
    [self initCarousel];

    [self initArrows];
    
    [self initTitle];
    [self initDate];

    [[MotionVideoPlayer sharedInstance] rotatePlayerToPortrait];
    [self.view bringSubviewToFront:self.navigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if([[[MotionVideoPlayer sharedInstance] view] alpha] < 1) {
        [[[MotionVideoPlayer sharedInstance] player] seekToTime:CMTimeMakeWithSeconds(25, 1.0)];
        [self playVideo];
        [[MotionVideoPlayer sharedInstance] fadeIn];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseVideo) name:[MPPEvents PlayerObservedTimeEvent] object:nil];
    [[MotionVideoPlayer sharedInstance] startToListenForUpdatesWithTime:27];
    [self transitionIn];
}

- (void)initNavBar {
    self.navigationBar = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeDeviceSize].size.width, 50) andTitle:@"Explorer" andShowExploreButton:NO];
    [self.view addSubview:self.navigationBar];

    [self.navigationBar.backButton addTarget:self action:@selector(transitionOutToHome) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initArrows {
    self.leftArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftArrow.png"]];
    [self.carousel addSubview:self.leftArrow];
    [self.leftArrow moveTo:CGPointMake(0.1 * [OrientationUtils nativeDeviceSize].size.width - self.leftArrow.frame.size.width / 2, [OrientationUtils nativeDeviceSize].size.height / 2 - self.leftArrow.frame.size.height / 2)];

    self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftArrow.png"]];
    [self.carousel addSubview:self.rightArrow];
    [self.rightArrow moveTo:CGPointMake(0.9 * [OrientationUtils nativeDeviceSize].size.width - self.rightArrow.frame.size.width / 2, [OrientationUtils nativeDeviceSize].size.height / 2 - self.rightArrow.frame.size.height / 2)];
    self.rightArrow.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.rightArrow.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
}

- (void)initPreviews {
    DataManager *dataManager = [DataManager sharedInstance];
    NSMutableArray *tempPreviews = [NSMutableArray arrayWithCapacity:[dataManager getScenesNumber]];
    
    for(int i = 0; i < [dataManager getScenesNumber]; i++) {
        ScenePreviewView *preview = [[ScenePreviewView alloc] initWithFrame:[OrientationUtils nativeDeviceSize] andModel:[dataManager getSceneWithNumber:i]];
        [tempPreviews addObject:preview];
    }
    
    self.previews = [NSArray arrayWithArray:tempPreviews];
}

- (void)initBottomInfos {
    self.bottomInfos = [[StatsFooterView alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeDeviceSize].size.width, 20)];
    [self.view addSubview:self.bottomInfos];
    [self.bottomInfos moveTo:CGPointMake(0, [OrientationUtils nativeDeviceSize].size.height - self.bottomInfos.frame.size.height)];
}

- (void)initCarousel {
    self.carousel = [[iCarousel alloc] initWithFrame:[OrientationUtils nativeDeviceSize]];
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.carousel.type = iCarouselTypeCustom;
    self.carousel.pagingEnabled = YES;
    self.carousel.bounceDistance = 0.2;
    [self.view addSubview:self.carousel];
}

- (void)initTitle {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeDeviceSize].size.width * 0.9, 40)];
    self.titleLabel.text = [[[DataManager sharedInstance] getSceneWithNumber:0].title uppercaseString];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Medium" size:15];
    self.titleLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.titleLabel.layer.borderWidth = 2;
    [self.carousel addSubview:self.titleLabel];
    [self.titleLabel moveTo:CGPointMake([OrientationUtils nativeDeviceSize].size.width * 0.05, self.navigationBar.frame.size.height + 10)];
}

- (void)initDate {
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeDeviceSize].size.width, 30)];
    self.dateLabel.text = [[[DataManager sharedInstance] getSceneWithNumber:0].date stringByReplacingOccurrencesOfString:@"-" withString:@"   "];
    self.dateLabel.textColor = [UIColor blackColor];
    [self.dateLabel setTextAlignment:NSTextAlignmentCenter];
    self.dateLabel.font = [UIFont fontWithName:@"AvenirLTStd-Roman" size:13];
    [self.carousel addSubview:self.dateLabel];
    [self.dateLabel moveTo:CGPointMake([OrientationUtils nativeDeviceSize].size.width / 2 - self.dateLabel.frame.size.width / 2, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height)];

	UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dateSeparator.png"]];
    [self.carousel addSubview:separator];
    separator.center = self.dateLabel.center;
}

- (void)transitionIn {
    self.navigationBar.alpha = 0;
    [self.navigationBar moveTo:CGPointMake(0, - 20)];

    [self.carousel moveTo:CGPointMake(0, - 20)];
    self.carousel.alpha = 0;

    self.bottomInfos.alpha = 0;
    [self.bottomInfos moveTo:CGPointMake(0, [OrientationUtils nativeDeviceSize].size.height)];

    CGFloat duration = 0.6;
    [UIView animateWithDuration:duration delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.navigationBar moveTo:CGPointMake(0, 0)];
        self.navigationBar.alpha = 1;
    } completion:nil];

    [UIView animateWithDuration:duration delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.carousel moveTo:CGPointMake(0, 0)];
        self.carousel.alpha = 1;
    } completion:nil];

    [UIView animateWithDuration:duration delay:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bottomInfos.alpha = 1;
        [self.bottomInfos moveTo:CGPointMake(0, [OrientationUtils nativeDeviceSize].size.height - self.bottomInfos.frame.size.height)];
    } completion:nil];
}

- (void)transitionOutToHome {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[MotionVideoPlayer sharedInstance] stopListeningForUpdates];
    [[MotionVideoPlayer sharedInstance] fadeOut];

    CGFloat duration = 0.6;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.navigationBar moveTo:CGPointMake(0, - 20)];
        self.navigationBar.alpha = 0;
    } completion:nil];

    [UIView animateWithDuration:duration delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.carousel moveTo:CGPointMake(0, - 20)];
        self.carousel.alpha = 0;
    } completion:nil];

    [UIView animateWithDuration:duration delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bottomInfos.alpha = 0;
    [self.bottomInfos moveTo:CGPointMake(0, [OrientationUtils nativeDeviceSize].size.height)];
    } completion:^(BOOL finished) {
        [self toHome];
    }];
}

- (void)transitionOutWithView:(UIView *)view andIndex:(NSInteger)index {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[MotionVideoPlayer sharedInstance] stopListeningForUpdates];
    [self playVideo];

    CGFloat duration = 0.6;

    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.navigationBar moveTo:CGPointMake(0, -self.navigationBar.frame.size.height)];
        self.navigationBar.alpha = 0;
    } completion:^(BOOL finished) {
        [self.navigationBar removeFromSuperview];
    }];

    [UIView animateWithDuration:duration delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bottomInfos.alpha = 0;
        [self.bottomInfos moveTo:CGPointMake(0, [OrientationUtils nativeDeviceSize].size.height)];
    } completion:^(BOOL finished) {
        [self.bottomInfos removeFromSuperview];
    }];

    [UIView animateWithDuration:duration delay:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [view moveTo:CGPointMake(- view.frame.size.width / 4, view.frame.origin.y)];
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];

    UIImageView *rotationIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rotationIcon.png"]];
    [self.view addSubview:rotationIcon];
    [rotationIcon moveTo:CGPointMake([OrientationUtils nativeDeviceSize].size.width / 2 - rotationIcon.frame.size.width / 2, [OrientationUtils nativeDeviceSize].size.height / 2 - rotationIcon.frame.size.height / 2)];
    rotationIcon.alpha = 0;
    [UIView animateWithDuration:duration delay:duration / 2 options:UIViewAnimationOptionCurveLinear animations:^{
        rotationIcon.alpha = 1;
    } completion:^(BOOL finished) {
        [self toSceneWithNumber:index];
    }];
}

- (void)toSceneWithNumber:(NSInteger)number {
    [[MotionVideoPlayer sharedInstance] fadeOut];
    self.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [UIView animateWithDuration:0.4 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI_2);
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [[DataManager sharedInstance] getGameModel].currentScene = number;
        SceneManager *sceneManager = [self.storyboard instantiateViewControllerWithIdentifier:@"SceneManager"];
        [self.navigationController pushViewController:sceneManager animated:NO];
    }];
}

// iCarousel protocols

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    SceneModel *sceneModel = [[DataManager sharedInstance] getSceneWithNumber:index];
    return [[ScenePreviewView alloc] initWithFrame:[OrientationUtils nativeDeviceSize] andModel:sceneModel];
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    SceneModel *sceneModel = [[DataManager sharedInstance] getSceneWithNumber: self.carousel.currentItemIndex];
    self.titleLabel.text = [sceneModel.title uppercaseString];
    self.dateLabel.text = [sceneModel.date stringByReplacingOccurrencesOfString:@"-" withString:@"   "];
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [self.previews count];
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    if(![[DataManager sharedInstance] getSceneWithNumber:index].unlocked) return;
    if(index != carousel.currentItemIndex) return;

    carousel.currentItemView.alpha = 0.7;
    [UIView animateWithDuration:0.2 animations:^{

    } completion:^(BOOL finished) {
        carousel.currentItemView.alpha = 1;
    }];

    UIView *view = [[ScenePreviewView alloc] initWithFrame:[OrientationUtils nativeDeviceSize] andModel:[[DataManager sharedInstance] getSceneWithNumber:index]];
    view.center = carousel.currentItemView.center;
    [self.view addSubview:view];
    [view moveTo:CGPointMake([OrientationUtils nativeDeviceSize].size.width / 2 - view.frame.size.width / 2, [OrientationUtils nativeDeviceSize].size.height / 2 - view.frame.size.height / 2 + 1)];

    [UIView animateWithDuration:0.4 animations:^{
        self.carousel.alpha = 0;
    } completion:^(BOOL finished) {
        [self transitionOutWithView:view andIndex:index];
    }];
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if(option == iCarouselOptionWrap) return 0;
        
    else if(option == iCarouselOptionFadeMin) return -0.5;

    else if(option == iCarouselOptionFadeMax) return 0.5;

    else return value;
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    CGFloat abs = fabsf(offset);
    CGFloat scale = 0.9 + (1 - (0.9 + abs / 10));

    transform = CATransform3DScale(transform, scale, scale, 1);
    transform = CATransform3DTranslate(transform, self.carousel.currentItemView.frame.size.width * offset, 1, 1);
    return transform;
}

- (void)carouselScrollHasChanged:(iCarousel *)caroussel withOffset:(CGFloat)offset {

}

@end
