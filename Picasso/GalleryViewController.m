//
//  GalleryViewController.m
//  Picasso
//
//  Created by RENARD Julian on 12/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

//
//  ViewController.m
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import "CHTCollectionViewWaterfallCell.h"
#import "GalleryViewController.h"
#import "WorkViewController.h"
#import "WorkModel.h"
#import "DataManager.h"

#define CELL_IDENTIFIER @"WaterfallCell"

@interface GalleryViewController ()

@property (nonatomic, assign) int cellCount;
@property (nonatomic, strong) DataManager *dataManager;

@end

@implementation GalleryViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.dataManager = [DataManager sharedInstance];
        self.cellCount = [self.dataManager getWorksNumber];
    }
    return self;
}

#pragma mark - Accessors
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemWidth = 160;
        layout.delegate = self;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

#pragma mark - Life Cycle
- (void)dealloc {
    [_collectionView removeFromSuperview];
    _collectionView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[CHTCollectionViewWaterfallCell class] forCellWithReuseIdentifier:@"WaterfallCell"];
    [self.view addSubview:self.collectionView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayout];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation
                                            duration:duration];
    [self updateLayout];
}

- (void)updateLayout {
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = self.collectionView.bounds.size.width / 160;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellCount;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHTCollectionViewWaterfallCell *cell =
    (CHTCollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                                forIndexPath:indexPath];
    
    if([cell.contentView.subviews count] == 0) {
        [cell.contentView addSubview:[[UIImageView alloc] initWithFrame:cell.contentView.bounds]];
    }
    
    UIImageView *cellImageView = cell.contentView.subviews[0];
    
    NSString *imageUrl = [NSString stringWithFormat: @"min-%d.jpg", indexPath.row];
    cellImageView.image = [UIImage imageNamed:imageUrl];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
    NSLog(@"select %ld", (long)indexPath.row);
    WorkViewController *workViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkViewController"];
    
    workViewController.workId = indexPath.row;
    [self.navigationController pushViewController:workViewController animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
    NSLog(@"deselect %ld", (long)indexPath.row);
}

#pragma mark - UICollectionViewWaterfallLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *imageUrl = [NSString stringWithFormat: @"min-%d.jpg", indexPath.row];
    UIImage *workImage = [UIImage imageNamed:imageUrl];
    
    return workImage.size.height;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout
 widthForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return 160;
    
}

@end
