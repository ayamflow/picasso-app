//
//  WorkViewController.h
//  Picasso
//
//  Created by Julian on 29/10/2013.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkViewController : UIViewController  <UIGestureRecognizerDelegate, UIScrollViewDelegate> {
    CGRect prevFrame;
}

@property (weak, nonatomic) IBOutlet UIView *workNavigation;
@property (weak, nonatomic) IBOutlet UIImageView *comeBackGallery;
@property (weak, nonatomic) IBOutlet UIImageView *workImage;
@property (weak, nonatomic) IBOutlet UILabel *titleWorkLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberWorkLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *contentWorkView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionWorkView;
@property (weak, nonatomic) IBOutlet UIView *textWorkView;
@property (weak, nonatomic) IBOutlet UIView *creditWorkView;
@property (weak, nonatomic) IBOutlet UILabel *titleMiniWorkLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateMiniWorkLabel;
@property (weak, nonatomic) IBOutlet UIView *navBarMiniWorkView;
@property (weak, nonatomic) IBOutlet UIView *headerWorkView;

@property (nonatomic, readwrite, assign) int workId;

@property (assign, nonatomic) BOOL showExploreButton;

@end