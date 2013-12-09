//
//  WorksCollectionView.h
//  Picasso
//
//  Created by RENARD Julian on 09/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorksCollectionView : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>

@property (assign, nonatomic) NSInteger sceneNumber;
@property (nonatomic, retain) IBOutlet UICollectionView *collectionView;

@end
