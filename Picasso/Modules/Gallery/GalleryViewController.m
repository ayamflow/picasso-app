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

@end

@implementation GalleryViewController

- (void)workTouchedWithIndex:(NSInteger)index {
    WorkViewController *workViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkViewController"];
    workViewController.workId = index;
    [self.navigationController pushViewController:workViewController animated:YES];
}

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
    
    NSInteger scenesNumber = [self.dataManager getScenesNumber];
    
    for (int i = 0; i < 3; i++) {
        WorksCollectionView *worksCollectionView = [[WorksCollectionView alloc] initWithFrame:CGRectMake(self.scrollViewScenes.frame.size.width * i, 0, self.scrollViewScenes.frame.size.width, self.scrollViewScenes.frame.size.height) andWithScene:i];
        worksCollectionView.delegate = self;
        worksCollectionView.collectionView.userInteractionEnabled = TRUE;
        [self.scrollViewScenes addSubview:worksCollectionView];
    }
    
    self.scrollViewScenes.contentSize = CGSizeMake(self.scrollViewScenes.frame.size.width * 3, self.scrollViewScenes.frame.size.height);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    SceneModel *currentScene = [self.dataManager getSceneWithNumber:_sceneNumber];
    self.sceneDate.text = [currentScene.date stringByReplacingOccurrencesOfString:@"-" withString:@"   "];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
}

@end