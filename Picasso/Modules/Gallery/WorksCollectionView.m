//
//  WorksCollectionView.m
//  Picasso
//
//  Created by RENARD Julian on 09/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "WorksCollectionView.h"
#import "WorkModel.h"
#import "SceneModel.h"
#import "DataManager.h"

#define kImageMargin 20

@interface WorksCollectionView ()

@property (nonatomic, strong) NSMutableArray *sceneWorks;
@property (assign, nonatomic) NSInteger sceneNumber;

@end

@implementation WorksCollectionView

- (id)initWithFrame:(CGRect)frame andWithScene:(NSInteger)sceneNumber
{
    if(self = [super initWithFrame:frame]) {
        self.sceneNumber = sceneNumber;
        [self initCollectionView];
    }
    return self;
}

- (void)initCollectionView {
    self.sceneWorks = [[DataManager sharedInstance] getWorksWithScene:self.sceneNumber];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.sceneWorks count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    if([cell.contentView.subviews count] == 0) {
        [cell.contentView addSubview:[[UIImageView alloc] initWithFrame:cell.contentView.bounds]];
    }
    
    WorkModel *currentWork = [self.sceneWorks objectAtIndex:indexPath.row];
    
    UIImageView *cellImageView = cell.contentView.subviews[0];
    if(currentWork.unlocked) {
        NSString *imageName = [NSString stringWithFormat: @"min-%li.jpg", currentWork.workId];
        cellImageView.image = [UIImage imageNamed:imageName];
   }
    else {
        cellImageView.image = [UIImage imageNamed:@"lockedButton.png"];
        cellImageView.contentMode = UIViewContentModeCenter;
        cellImageView.backgroundColor = [UIColor blackColor];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate workTouchedWithIndex:indexPath.row];
}

#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    WorkModel *currentWork = [self.sceneWorks objectAtIndex:indexPath.row];
    NSString *imageName = [NSString stringWithFormat: @"min-%li.jpg", currentWork.workId];
    UIImage *image = [UIImage imageNamed:imageName];

    CGFloat width;
    CGFloat height;
    
//    if(image.size.width > self.bounds.size.width / 2 - kImageMargin) {
//        width = self.bounds.size.width / 2 - kImageMargin;
//        height = width / image.size.height * image.size.width;
//    }
//    else {
        width = image.size.width;
        height = image.size.height;
//    }
    return CGSizeMake(width , height);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kImageMargin, kImageMargin, kImageMargin, kImageMargin);
}

@end
