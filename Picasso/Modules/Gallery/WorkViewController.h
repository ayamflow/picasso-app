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

@property (weak, nonatomic) IBOutlet UIView *navigationBar;
@property (weak, nonatomic) IBOutlet UIWebView *workContent;
@property (weak, nonatomic) IBOutlet UIView *workNavigation;
@property (weak, nonatomic) IBOutlet UIImageView *comeBackGallery;

@property (nonatomic, readwrite, assign) int workId;

@end