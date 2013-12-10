//
//  GalleryViewController.h
//  Picasso
//
//  Created by RENARD Julian on 12/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkCollectionDelegate.h"

@interface GalleryViewController : UIViewController <UIGestureRecognizerDelegate, WorkCollectionDelegate>

@property (weak, nonatomic) IBOutlet UIView *navBar;

@property (assign, nonatomic) NSInteger sceneNumber;
@property (weak, nonatomic) IBOutlet UILabel *sceneDate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewScenes;

@end