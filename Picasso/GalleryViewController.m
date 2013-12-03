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

#define CELL_WIDTH 110
#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"

@interface GalleryViewController ()

@property (nonatomic, strong) NSMutableArray *cellHeights;
@property (nonatomic, assign) int cellCount;
@property (nonatomic, strong) DataManager *dataManager;

@end

@implementation GalleryViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.dataManager = [DataManager sharedInstance];
        self.cellCount = [self.dataManager getWorksNumber];
        self.cellWidth = CELL_WIDTH;
    }
    return self;
}

#pragma mark - Accessors
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.delegate = self;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 95, self.view.bounds.size.width - 20, self.view.bounds.size.height  - 95) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (NSMutableArray *)cellHeights {
    if (!_cellHeights) {
        _cellHeights = [NSMutableArray arrayWithCapacity:self.cellCount];
        for (NSInteger i = 0; i < self.cellCount; i++) {
            _cellHeights[i] = @(arc4random() % 100 * 2 + 100);
        }
    }
    return _cellHeights;
}

#pragma mark - Life Cycle
- (void)dealloc {
    [_collectionView removeFromSuperview];
    _collectionView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    _navBar.layer.borderColor = [UIColor blackColor].CGColor;
    _navBar.layer.borderWidth = 2.0f;
    
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
    layout.columnCount = self.collectionView.bounds.size.width / self.cellWidth;
    layout.itemWidth = self.cellWidth;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellCount;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

/*
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHTCollectionViewWaterfallCell *cell =
    (CHTCollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                                forIndexPath:indexPath];
    
    cell.displayString = [NSString stringWithFormat:@"%d", indexPath.row];
    return cell;
}
*/
 
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

/*
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:FOOTER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    }
    
    return reusableView;
}
*/
 
#pragma mark - UICollectionViewWaterfallLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *imageUrl = [NSString stringWithFormat: @"min-%d.jpg", indexPath.row];
    UIImage *workImage = [UIImage imageNamed:imageUrl];
    
    return workImage.size.height;
    
}

/*
- (CGFloat)collectionView:(UICollectionView *)collectionView
  heightForHeaderInLayout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout {
    return 50;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
  heightForFooterInLayout:(CHTCollectionViewWaterfallLayout *)collectionViewLayout {
    return 30;
}
*/
 
@end
