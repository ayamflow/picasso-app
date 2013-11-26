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
#import "ScenePreview.h"
#import "SceneModel.h"
#import "iCarousel.h"

#define kDirectionNone 0
#define kDirectionLeft 1
#define kDirectionRight 2

@interface SceneChooser ()

@property (strong, nonatomic) NSArray *previews;
@property (assign, nonatomic) CGFloat previewWidth;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *dateLabel;

@end

@implementation SceneChooser

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.view.backgroundColor = [UIColor clearColor];
    self.previewWidth = [OrientationUtils nativeLandscapeDeviceSize].size.width * 0.6;
    [self rotateToLandscapeOrientation];
    
    [self initPreviews];
    [self initCarousel];
    
    [self initTitle];
    [self initDate];
    
//    [self initBackground];
}

- (void)initPreviews {
    DataManager *dataManager = [DataManager sharedInstance];
    NSMutableArray *tempPreviews = [NSMutableArray arrayWithCapacity:[dataManager getScenesNumber]];
    
    for(int i = 0; i < [dataManager getScenesNumber]; i++) {
        ScenePreview *preview = [[ScenePreview alloc] initWithModel:[dataManager getSceneWithNumber:i]];
        [tempPreviews addObject:preview];
    }
    
    self.previews = [NSArray arrayWithArray:tempPreviews];
}

- (void)initCarousel {
    self.carousel = [[iCarousel alloc] initWithFrame:[OrientationUtils nativeLandscapeDeviceSize]];
//    self.carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.carousel.type = iCarouselTypeInvertedCylinder;
    [self.view addSubview:self.carousel];
}

- (void)initBackground {
    UIView *overlay = [[UIView alloc] initWithFrame:[OrientationUtils nativeLandscapeDeviceSize]];
    overlay.backgroundColor = [UIColor whiteColor];
    overlay.alpha = 0.8;
    [self.view addSubview:overlay];
    
//	UIImageView *background = [[UIImageView alloc] initWithImage:[[MotionVideoPlayer sharedInstance] getBlurredScreenshot]];
//    [self.view addSubview:background];
}

- (void)initTitle {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.previewWidth * 0.6, 35)];
    self.titleLabel.text = [[[DataManager sharedInstance] getSceneWithNumber:0].title uppercaseString];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.titleLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Bold" size:13];
    self.titleLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.titleLabel.layer.borderWidth = 2;
    [self.view addSubview:self.titleLabel];
    [self.titleLabel moveTo:CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - self.titleLabel.frame.size.width / 2, 40)];
}

- (void)initDate {
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.previewWidth * 0.8, 130)];
    self.dateLabel.text = [[DataManager sharedInstance] getSceneWithNumber:0].date;
    self.dateLabel.textColor = [UIColor blackColor];
    [self.dateLabel setTextAlignment:NSTextAlignmentCenter];
    self.dateLabel.font = [UIFont fontWithName:@"AvenirLTStd-Roman" size:13];
    [self.view addSubview:self.dateLabel];
    [self.dateLabel moveTo:CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - self.dateLabel.frame.size.width / 2, 25)];
}


- (void)transitionOutWithView:(UIView *)view andIndex:(NSInteger)index {
    [UIView animateWithDuration:0.8 delay:0.15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.titleLabel moveTo:CGPointMake(- self.titleLabel.frame.size.width, self.titleLabel.frame.origin.y)];
        self.titleLabel.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.8 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.dateLabel moveTo:CGPointMake(- self.dateLabel.frame.size.width, self.dateLabel.frame.origin.y)];
        self.dateLabel.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [view moveTo:CGPointMake(- view.frame.size.width, view.frame.origin.y)];
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [[DataManager sharedInstance] getGameModel].currentScene = index;
        
        SceneManager *sceneManager = [self.storyboard instantiateViewControllerWithIdentifier:@"SceneManager"];
        [self.navigationController pushViewController:sceneManager animated:NO];
    }];
}

// iCarousel protocols

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    
    SceneModel *sceneModel = [[DataManager sharedInstance] getSceneWithNumber:index];
    view = [[ScenePreview alloc] initWithModel:sceneModel].view;
    return view;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    SceneModel *sceneModel = [[DataManager sharedInstance] getSceneWithNumber: self.carousel.currentItemIndex];
    self.titleLabel.text = [sceneModel.title uppercaseString];
    self.dateLabel.text = sceneModel.date;
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [self.previews count];
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    if(![[DataManager sharedInstance] getSceneWithNumber:index].unlocked) return;
    
    UIView *view = [[ScenePreview alloc] initWithModel:[[DataManager sharedInstance] getSceneWithNumber:index]].view;
    view.center = carousel.currentItemView.center;
    [self.view addSubview:view];
    
    [view moveTo:CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - view.frame.size.width / 2, 0)];
    [UIView animateWithDuration:0.4 animations:^{
        self.carousel.alpha = 0;
    } completion:^(BOOL finished) {
        [self transitionOutWithView:view andIndex:index];
    }];
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if(option == iCarouselOptionWrap) {
        return 0;
    }
    return value;
}

@end
