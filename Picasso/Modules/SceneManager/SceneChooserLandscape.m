//
//  SceneChooserViewController.m
//  Picasso
//
//  Created by MOREL Florian on 31/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "SceneChooserLandscape.h"
#import "DataManager.h"
#import "SceneManager.h"
#import "UIViewControllerPicasso.h"
#import "UIViewPicasso.h"
#import "Colors.h"
#import "OrientationUtils.h"
#import "ScenePreviewView.h"
#import "SceneModel.h"
#import "iCarousel.h"

#define kDirectionNone 0
#define kDirectionLeft 1
#define kDirectionRight 2

@interface SceneChooserLandscape ()

@property (strong, nonatomic) NSArray *previews;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *dateLabel;

@property (strong, nonatomic) UIImageView *leftArrow;
@property (strong, nonatomic) UIImageView *rightArrow;

@end

@implementation SceneChooserLandscape

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (id)init {
    if(self = [super init]) {
        self.view.frame = [OrientationUtils nativeLandscapeDeviceSize];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.view.backgroundColor = [UIColor clearColor];

    [self initPreviews];
    [self initCarousel];

    [self initArrows];

    [self initDate];
}

- (void)initArrows {
    self.leftArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftArrow.png"]];
    [self.view addSubview:self.leftArrow];
    [self.leftArrow moveTo:CGPointMake(0.05 * [OrientationUtils nativeLandscapeDeviceSize].size.width - self.leftArrow.frame.size.width / 2, [OrientationUtils nativeLandscapeDeviceSize].size.height / 2 - self.leftArrow.frame.size.height / 2 + self.carousel.contentOffset.height)];

    self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftArrow.png"]];
    [self.view addSubview:self.rightArrow];
    [self.rightArrow moveTo:CGPointMake(0.95 * [OrientationUtils nativeLandscapeDeviceSize].size.width - self.rightArrow.frame.size.width / 2, [OrientationUtils nativeLandscapeDeviceSize].size.height / 2 - self.rightArrow.frame.size.height / 2 + self.carousel.contentOffset.height)];
    self.rightArrow.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.rightArrow.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
}

- (void)initPreviews {
    DataManager *dataManager = [DataManager sharedInstance];
    NSMutableArray *tempPreviews = [NSMutableArray arrayWithCapacity:[dataManager getScenesNumber]];

    for(int i = 0; i < [dataManager getScenesNumber]; i++) {
        ScenePreviewView *preview = [[ScenePreviewView alloc] initWithFrame:[OrientationUtils nativeLandscapeDeviceSize] andModel:[dataManager getSceneWithNumber:i]];
        [tempPreviews addObject:preview];
    }

    self.previews = [NSArray arrayWithArray:tempPreviews];
}

- (void)initCarousel {
    self.carousel = [[iCarousel alloc] initWithFrame:[OrientationUtils nativeLandscapeDeviceSize]];
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.carousel.type = iCarouselTypeCustom;
    self.carousel.pagingEnabled = YES;
    self.carousel.contentOffset = CGSizeMake(0, 45);
    self.carousel.bounceDistance = 0.2;
    [self.view addSubview:self.carousel];
}

- (void)initDate {
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeLandscapeDeviceSize].size.width, 30)];
    self.dateLabel.text = [[[DataManager sharedInstance] getSceneWithNumber:0].date stringByReplacingOccurrencesOfString:@"-" withString:@"   "];
    self.dateLabel.textColor = [UIColor blackColor];
    [self.dateLabel setTextAlignment:NSTextAlignmentCenter];
    self.dateLabel.font = [UIFont fontWithName:@"AvenirLTStd-Roman" size:13];
    [self.carousel addSubview:self.dateLabel];
    [self.dateLabel moveTo:CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - self.dateLabel.frame.size.width / 2, 70)];

	UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dateSeparator.png"]];
    [self.carousel addSubview:separator];
    separator.center = self.dateLabel.center;
}

- (void)transitionIn {
    [self.carousel moveTo:CGPointMake(self.carousel.frame.size.width, 0)];
    self.carousel.alpha = 0;

    CGFloat duration = 0.8;

    [UIView animateWithDuration:duration delay:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.carousel moveTo:CGPointMake(0, 0)];
        self.carousel.alpha = 1;
    } completion:nil];
}

- (void)transitionOutWithView:(UIView *)view andIndex:(NSInteger)index {
    [UIView animateWithDuration:0.8 delay:0.15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.titleLabel moveTo:CGPointMake(- self.titleLabel.frame.size.width, self.titleLabel.frame.origin.y)];
        self.titleLabel.alpha = 0;
        [self.rightArrow moveTo:CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width + 2 * self.rightArrow.frame.size.width, self.rightArrow.frame.origin.y)];
    } completion:^(BOOL finished) {
        [self.rightArrow removeFromSuperview];
        [self.titleLabel removeFromSuperview];
    }];
    [UIView animateWithDuration:0.8 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.dateLabel moveTo:CGPointMake(- self.dateLabel.frame.size.width, self.dateLabel.frame.origin.y)];
        self.dateLabel.alpha = 0;
        [self.leftArrow moveTo:CGPointMake(2 * - self.leftArrow.frame.size.width, self.leftArrow.frame.origin.y)];
    } completion:^(BOOL finished) {
        [self.leftArrow removeFromSuperview];
        [self.dateLabel removeFromSuperview];

    }];
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [view moveTo:CGPointMake(- view.frame.size.width, view.frame.origin.y)];
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        [self.delegate navigateToSceneWithNumber:index];
    }];
}

// iCarousel protocols

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    SceneModel *sceneModel = [[DataManager sharedInstance] getSceneWithNumber:index];
    return [[ScenePreviewView alloc] initWithFrame:[OrientationUtils nativeLandscapeDeviceSize] andModel:sceneModel];
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    SceneModel *sceneModel = [[DataManager sharedInstance] getSceneWithNumber: self.carousel.currentItemIndex];
    self.dateLabel.text = [sceneModel.date stringByReplacingOccurrencesOfString:@"-" withString:@"   "];
    [self.delegate updateNavigationTitleWithString:[sceneModel.title uppercaseString]];
    [self.mapDelegate translateMapToIndex:carousel.currentItemIndex];
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [self.previews count];
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    if(![[DataManager sharedInstance] getSceneWithNumber:index].unlocked) return;
    if(index != carousel.currentItemIndex) return;

    UIView *view = [[ScenePreviewView alloc] initWithFrame:[OrientationUtils nativeLandscapeDeviceSize] andModel:[[DataManager sharedInstance] getSceneWithNumber:index]];
    view.center = carousel.currentItemView.center;
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.85, 0.85);
    [self.view addSubview:view];
    [view moveTo:CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - view.frame.size.width / 2, [OrientationUtils nativeLandscapeDeviceSize].size.height / 2 - view.frame.size.height / 2 + 1 + carousel.contentOffset.height)];

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
    CGFloat scale = 0.9 + (1 - (0.9 + abs / 10)) - 0.15;

    transform = CATransform3DScale(transform, scale, scale, 1);
    transform = CATransform3DTranslate(transform, self.carousel.currentItemView.frame.size.width * offset, 1, 1);
    return transform;
}

- (void)carouselScrollHasChanged:(iCarousel *)caroussel withOffset:(CGFloat)offset {}

@end
