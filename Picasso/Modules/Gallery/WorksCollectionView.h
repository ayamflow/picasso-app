//
//  WorksCollectionView.h
//  Picasso
//
//  Created by RENARD Julian on 09/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkCollectionDelegate.h"

@interface WorksCollectionView : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (weak, nonatomic) id<WorkCollectionDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andWithScene:(NSInteger)sceneNumber;

@end