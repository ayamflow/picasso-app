//
//  GalleryViewController.h
//  Picasso
//
//  Created by RENARD Julian on 12/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkCollectionDelegate.h"

@interface GalleryViewController : UIViewController <UIGestureRecognizerDelegate, WorkCollectionDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *sceneDate;
@property (weak, nonatomic) IBOutlet UIImageView *leftArrow;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
@property (weak, nonatomic) IBOutlet UIImageView *dateSeparator;
@property (assign, nonatomic) BOOL shouldUpdateRotation;

@end