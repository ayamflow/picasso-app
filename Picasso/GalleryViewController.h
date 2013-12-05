//
//  GalleryViewController.h
//  Picasso
//
//  Created by RENARD Julian on 12/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *navBar;
@property (weak, nonatomic) IBOutlet UICollectionView *worksCollectionView;

@end