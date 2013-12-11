//
//  GalleryViewController.m
//  Picasso
//
//  Created by RENARD Julian on 12/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "GalleryViewController.h"
#import "WorkViewController.h"
#import "WorksCollectionView.h"
#import "WorkModel.h"
#import "SceneModel.h"
#import "DataManager.h"
#import "UIViewPicasso.h"
#import "UIViewControllerPicasso.h"
#import "OrientationUtils.h"
#import "NavigationBarView.h"
#import "UIView+EasingFunctions.h"
#import "easing.h"

@interface GalleryViewController ()

@property (strong, nonatomic) NSMutableArray *sceneWorks;
@property (strong, nonatomic) NavigationBarView *navigationBar;
@property (strong, nonatomic) NSArray *collectionViews;
@property (assign, nonatomic) NSInteger currentSceneNumber;
@property (strong, nonatomic) UIScrollView *scrollViewScenes;

@end

@implementation GalleryViewController


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTexts];
    [self initNavigationBar];
    [self initGallery];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGFloat duration = 0.4;
    CGFloat delay = 0;
    
    for(UIView *view in @[self.scrollViewScenes, self.sceneDate, self.leftArrow, self.rightArrow, self.dateSeparator, self.navigationBar]) {
        [view setEasingFunction:QuadraticEaseInOut forKeyPath:@"frame"];
        view.alpha = 0;
        [view moveTo:CGPointMake(view.frame.origin.x, view.frame.origin.y - 20)];
    }
    
    for(UIView *view in @[self.scrollViewScenes, self.sceneDate, self.navigationBar]) {
        [UIView animateWithDuration:duration delay:delay options:0 animations:^{
            [view moveTo:CGPointMake(view.frame.origin.x, view.frame.origin.y + 20)];
            view.alpha = 1;
        } completion:nil];
        delay += 0.15;
    }
    
    for(UIView *view in @[self.leftArrow, self.rightArrow, self.dateSeparator]) {
        [UIView animateWithDuration:duration delay:0.15 options:0 animations:^{
            [view moveTo:CGPointMake(view.frame.origin.x, view.frame.origin.y + 20)];
            view.alpha = 1;
        } completion:nil];
    }
}

- (void)initTexts {
    self.sceneDate.font = [UIFont fontWithName:@"BrandonGrotesque-Medium" size:15];
    self.sceneDate.layer.borderColor = [UIColor blackColor].CGColor;
    self.sceneDate.layer.borderWidth = 2;
}

- (void)initNavigationBar {
    self.navigationBar = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeDeviceSize].size.width, 50) andTitle:@"Galerie" andShowExploreButton:NO];
    [self.view addSubview:self.navigationBar];
    
    [self.navigationBar.backButton addTarget:self action:@selector(transitionOutToHome) forControlEvents:UIControlEventTouchUpInside];
}


- (void)initGallery {
    self.currentSceneNumber = 0;
    [self updateTitleAndDateWithIndex:self.currentSceneNumber];
    
    self.scrollViewScenes.delegate = self;
    
    NSInteger scenesNumber = [[DataManager sharedInstance] getScenesNumber];
    
    NSMutableArray *collections = [NSMutableArray arrayWithCapacity:scenesNumber];
    
    for (int i = 0; i < scenesNumber; i++) {
        WorksCollectionView *worksCollectionView = [[WorksCollectionView alloc] initWithFrame:CGRectMake(self.scrollViewScenes.frame.size.width * i, 0, self.scrollViewScenes.frame.size.width, self.scrollViewScenes.frame.size.height) andWithScene:i];
        worksCollectionView.delegate = self;
        worksCollectionView.collectionView.userInteractionEnabled = YES;
        [collections addObject:worksCollectionView];
        [self.scrollViewScenes addSubview:worksCollectionView];
    }
    
    self.collectionViews = [NSArray arrayWithArray:collections];
    
    self.scrollViewScenes.contentSize = CGSizeMake(self.scrollViewScenes.frame.size.width * scenesNumber, self.scrollViewScenes.frame.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self updateTitleAndDateWithIndex: currentPage];
}

- (void)updateTitleAndDateWithIndex:(NSInteger)index {
    SceneModel *currentScene = [[DataManager sharedInstance] getSceneWithNumber:index];
    self.sceneDate.text = [currentScene.date stringByReplacingOccurrencesOfString:@"-" withString:@"   "];
}

- (void)workTouchedWithIndex:(NSInteger)index {
    WorkModel *currentWork = [[DataManager sharedInstance] getWorkWithNumber:index];
    if(!currentWork.unlocked) return;
    
    WorkViewController *workViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkViewController"];
    workViewController.workId = index;
    [self.navigationController pushViewController:workViewController animated:YES];
}

- (void)transitionOutToHome {
    CGFloat duration = 0.4;
    CGFloat delay = 0;
    NSInteger numberOfView = 3;
    NSInteger transitionDone = 0;
    
    for(UIView *view in @[self.navigationBar, self.sceneDate, self.scrollViewScenes]) {
        [UIView animateWithDuration:duration delay:delay options:0 animations:^{
            [view moveTo:CGPointMake(view.frame.origin.x, view.frame.origin.y - 20)];
            view.alpha = 0;
        } completion:^(BOOL finished) {
            if(transitionDone == numberOfView - 1) {
                [self toHome];
            }
        }];
        transitionDone++;
        delay += 0.15;
    }
    
    for(UIView *view in @[self.leftArrow, self.rightArrow, self.dateSeparator]) {
        [UIView animateWithDuration:duration delay:0.3 options:0 animations:^{
            [view moveTo:CGPointMake(view.frame.origin.x, view.frame.origin.y - 20)];
            view.alpha = 0;
        } completion:nil];
    }
}

@end