//
//  WorkViewController.h
//  Picasso
//
//  Created by Julian on 29/10/2013.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkViewController : UIViewController  <UIGestureRecognizerDelegate, UIScrollViewDelegate> {
    UISwipeGestureRecognizer *swipeDown;
    UISwipeGestureRecognizer *swipeUp;
    UITapGestureRecognizer *touch;
    BOOL isFullScreen;
    CGRect prevFrame;
}

@property (weak, nonatomic) IBOutlet UIView *navigationBar;
@property (weak, nonatomic) IBOutlet UIImageView *comebackGallery;
@property (weak, nonatomic) IBOutlet UIImageView *comebackScene;
@property (weak, nonatomic) IBOutlet UIImageView *workImage;
@property (weak, nonatomic) IBOutlet UIWebView *workContent;

@property (nonatomic, readwrite, assign) int workId;

@end