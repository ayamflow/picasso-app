//
//  GalleryViewController.m
//  Picasso
//
//  Created by RENARD Julian on 12/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "GalleryViewController.h"
#import "WorkViewController.h"
#import "WorkModel.h"
#import "DataManager.h"


@interface GalleryViewController ()

@property (nonatomic, strong) DataManager *dataManager;
@property (assign) float lastPosition;

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = [DataManager sharedInstance];
    self.navigationController.navigationBarHidden = YES;
    
    _navBar.layer.borderColor = [UIColor blackColor].CGColor;
    _navBar.layer.borderWidth = 2.0f;
    
    _worksCollectionView.backgroundColor = [UIColor clearColor];
    _worksCollectionView.userInteractionEnabled = YES;
    //_worksCollectionView.userInteractionEnabled = NO;
    [self.worksCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"workCell"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.worksCollectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataManager getWorksNumber];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"workCell" forIndexPath:indexPath];
    
    if([cell.contentView.subviews count] == 0) {
        [cell.contentView addSubview:[[UIImageView alloc] initWithFrame:cell.contentView.bounds]];
    }
    
    UIImageView *cellImageView = cell.contentView.subviews[0];
    
    NSString *imageName = [NSString stringWithFormat: @"min-%ld.jpg", (long)indexPath.row];
    cellImageView.image = [UIImage imageNamed:imageName];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WorkViewController *workViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkViewController"];
    workViewController.workId = indexPath.row;
    [self.navigationController pushViewController:workViewController animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    float currentPosition = [touch locationInView:self.view].x;
    self.lastPosition = currentPosition;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    float currentPosition = [touch locationInView:self.view].x;
    float velocity = self.lastPosition - currentPosition;
    
    int cellCount = 1;
    
    if(currentPosition < self.lastPosition) {
        NSLog(@"gauche");
    } else if(currentPosition > self.lastPosition) {
        NSLog(@"droite");
    }
    
    for (UICollectionViewCell *cell in [self.worksCollectionView visibleCells]) {
        CGRect originBounds = cell.layer.bounds;
        originBounds.origin.x = originBounds.origin.x + 0.008 * (cellCount * velocity);
        cell.layer.bounds = originBounds;
        cellCount++;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    float currentPosition = [touch locationInView:self.view].x;
    self.lastPosition = currentPosition;
}
 
@end