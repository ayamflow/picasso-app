//
//  WorksCollectionView.m
//  Picasso
//
//  Created by RENARD Julian on 09/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "WorksCollectionView.h"
#import "WorkModel.h"
#import "DataManager.h"

@implementation WorksCollectionView

NSMutableArray *sceneWorks;
DataManager *dataManager;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        dataManager = [DataManager sharedInstance];
        
        if(!_sceneNumber) {
            _sceneNumber = 0;
        }
        
        sceneWorks = [dataManager getWorksWithScene:_sceneNumber];

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        [self.collectionView setDataSource:self];
        [self.collectionView setDelegate:self];
        
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"workCell"];
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.collectionView];
        
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [sceneWorks count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"workCell" forIndexPath:indexPath];
    
    if([cell.contentView.subviews count] == 0) {
        [cell.contentView addSubview:[[UIImageView alloc] initWithFrame:cell.contentView.bounds]];
    }
    
    WorkModel *currentWork = [sceneWorks objectAtIndex:indexPath.row];
    
    UIImageView *cellImageView = cell.contentView.subviews[0];
    
    NSString *imageName = [NSString stringWithFormat: @"min-%@.jpg", currentWork.workId];
    cellImageView.image = [UIImage imageNamed:imageName];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    WorkViewController *workViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkViewController"];
    workViewController.workId = indexPath.row;
    [self.navigationController pushViewController:workViewController animated:YES];
    */
}

#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    WorkModel *currentWork = [sceneWorks objectAtIndex:indexPath.row];
    NSString *imageName = [NSString stringWithFormat: @"min-%@.jpg", currentWork.workId];
    UIImage *image = [UIImage imageNamed:imageName];
    // Solution provisoire pour afficher les images, à remplacer avec un template
    return CGSizeMake(image.size.width/2, image.size.height/2);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

@end
