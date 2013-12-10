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
#import "OrientationUtils.h"

@interface GalleryViewController ()

@property (nonatomic, strong) DataManager *dataManager;
@property (assign, nonatomic) NSInteger lastSceneNumber;
@property (strong, nonatomic) UIPanGestureRecognizer *worksCollectionViewPan;

@property (strong, nonatomic) WorksCollectionView *currentWorksCollectionView;
@property (strong, nonatomic) WorksCollectionView *nextWorksCollectionView;

@end

@implementation GalleryViewController

NSMutableArray *sceneWorks;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = [DataManager sharedInstance];
    self.navigationController.navigationBarHidden = YES;
    
    if(!_sceneNumber) {
        _sceneNumber = 0;
    }
    
    _navBar.layer.borderColor = [UIColor blackColor].CGColor;
    _navBar.layer.borderWidth = 2.0f;
    
    _nextWorksCollectionView = [[WorksCollectionView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 95, self.view.frame.size.width, 473) andWithScene:_sceneNumber];
    _currentWorksCollectionView = [[WorksCollectionView alloc] initWithFrame:CGRectMake(0, 95, self.view.frame.size.width, 473) andWithScene:_sceneNumber];
    [self.view addSubview:_nextWorksCollectionView];
    [self.view addSubview:_currentWorksCollectionView];
    
    _worksCollectionViewPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(switchScenes:)];
    [_currentWorksCollectionView addGestureRecognizer:self.worksCollectionViewPan];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    SceneModel *currentScene = [self.dataManager getSceneWithNumber:_sceneNumber];
    self.sceneDate.text = [currentScene.date stringByReplacingOccurrencesOfString:@"-" withString:@"   "];
}

-(IBAction)switchScenes:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        _lastSceneNumber = _sceneNumber;
        if(recognizer.view.center.x < self.view.center.x) {
            _sceneNumber++;
            [self.nextWorksCollectionView updateWithNewScene:_sceneNumber];
            //_nextWorksCollectionView.frame = CGRectMake(self.view.frame.size.width, 95, [OrientationUtils nativeDeviceSize].size.width, 473);
        } else if(recognizer.view.center.x > self.view.center.x) {
            _sceneNumber--;
            [self.nextWorksCollectionView updateWithNewScene:_sceneNumber];
            //_nextWorksCollectionView.frame = CGRectMake(-self.view.frame.size.width, 95, [OrientationUtils nativeDeviceSize].size.width, 473);
        }
        _nextWorksCollectionView.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.2];
        _currentWorksCollectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.2];
    }
    
    if(recognizer.state == UIGestureRecognizerStateChanged) {
        _nextWorksCollectionView.center = CGPointMake(_nextWorksCollectionView.center.x + translation.x, _nextWorksCollectionView.center.y);
        if(recognizer.view.center.x < self.view.center.x - self.view.frame.size.width/2) {
            [self.currentWorksCollectionView removeGestureRecognizer:self.worksCollectionViewPan];
            [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
                [self.currentWorksCollectionView moveTo:CGPointMake(-self.view.frame.size.width, 95)];
                [self.nextWorksCollectionView moveTo:CGPointMake(0, 95)];
            }completion:^(BOOL finished){
                
                WorksCollectionView *prevWorksCollectionView = self.currentWorksCollectionView;
                self.currentWorksCollectionView = self.nextWorksCollectionView;
                self.nextWorksCollectionView = prevWorksCollectionView;
                
                [self.nextWorksCollectionView removeGestureRecognizer:self.worksCollectionViewPan];
                [self.currentWorksCollectionView addGestureRecognizer:self.worksCollectionViewPan];
            }];
        } else if(recognizer.view.center.x > self.view.center.x + self.view.frame.size.width/2) {
            [self.currentWorksCollectionView removeGestureRecognizer:self.worksCollectionViewPan];
            [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
                [self.currentWorksCollectionView moveTo:CGPointMake(self.view.frame.size.width, 95)];
                [self.nextWorksCollectionView moveTo:CGPointMake(0, 95)];
            }completion:^(BOOL finished){
                
                WorksCollectionView *prevWorksCollectionView = self.currentWorksCollectionView;
                self.currentWorksCollectionView = self.nextWorksCollectionView;
                self.nextWorksCollectionView = prevWorksCollectionView;
                
                [self.nextWorksCollectionView removeGestureRecognizer:self.worksCollectionViewPan];
                [self.currentWorksCollectionView addGestureRecognizer:self.worksCollectionViewPan];
            }];
        }
    }
    
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.currentWorksCollectionView moveTo:CGPointMake(0, 95)];
            if(_sceneNumber > _lastSceneNumber) {
                [self.nextWorksCollectionView moveTo:CGPointMake(self.view.frame.size.width, 95)];
            } else {
                [self.nextWorksCollectionView moveTo:CGPointMake(-self.view.frame.size.width, 95)];
            }
            _sceneNumber = _lastSceneNumber;
        }];
    }
    
}

@end