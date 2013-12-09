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

@interface GalleryViewController ()

@property (nonatomic, strong) DataManager *dataManager;
@property (assign) float lastPosition;

@end

@implementation GalleryViewController

NSMutableArray *sceneWorks;
WorksCollectionView *currentWorksCollectionView;
WorksCollectionView *nextWorksCollectionView;
UIPanGestureRecognizer *worksCollectionViewPan;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = [DataManager sharedInstance];
    self.navigationController.navigationBarHidden = YES;
    
    if(!_sceneNumber) {
        _sceneNumber = 0;
    }
    
    sceneWorks = [self.dataManager getWorksWithScene:_sceneNumber];
    
    _navBar.layer.borderColor = [UIColor blackColor].CGColor;
    _navBar.layer.borderWidth = 2.0f;
    
    currentWorksCollectionView = [[WorksCollectionView alloc] initWithFrame:CGRectMake(0, 95, self.view.frame.size.width, 473)];
    currentWorksCollectionView.sceneNumber = _sceneNumber;
    [self.view addSubview:currentWorksCollectionView];
    
    worksCollectionViewPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(switchScenes:)];
    [currentWorksCollectionView addGestureRecognizer:worksCollectionViewPan];
    
    [self.view addSubview:currentWorksCollectionView];
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
    //NSLog(@"translation %f", recognizer.view.center.x);
    
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        if(recognizer.view.center.x < self.view.center.x) {
            NSLog(@"in left");
            if(!nextWorksCollectionView) {
                nextWorksCollectionView = [[WorksCollectionView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 95, self.view.frame.size.width, 473)];
                nextWorksCollectionView.sceneNumber = _sceneNumber + 1;
                nextWorksCollectionView.backgroundColor = [UIColor redColor];
                [self.view addSubview:nextWorksCollectionView];
            }
        } else if(recognizer.view.center.x > self.view.center.x) {
            NSLog(@"in right");
            if(!nextWorksCollectionView) {
                nextWorksCollectionView = [[WorksCollectionView alloc] initWithFrame:CGRectMake(0, 95, self.view.frame.size.width, 473)];
                nextWorksCollectionView.sceneNumber = _sceneNumber - 1;
                [self.view addSubview:nextWorksCollectionView];
            }
        }
    }
    
    if(recognizer.state == UIGestureRecognizerStateChanged) {
        nextWorksCollectionView.center = CGPointMake(nextWorksCollectionView.center.x + translation.x, nextWorksCollectionView.center.y);
        if(recognizer.view.center.x < self.view.center.x - 200) {
            [currentWorksCollectionView removeGestureRecognizer:worksCollectionViewPan];
            [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
                [currentWorksCollectionView setFrame:CGRectMake(-self.view.frame.size.width, 95, self.view.frame.size.width, 473)];
                [nextWorksCollectionView setFrame:CGRectMake(0, 95, self.view.frame.size.width, 473)];
            }completion:^(BOOL finished){
                [currentWorksCollectionView removeFromSuperview];
                currentWorksCollectionView = nextWorksCollectionView;
            }];
        }
    }
    
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        
    }
    
}

@end