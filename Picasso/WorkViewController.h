//
//  WorkViewController.h
//  Picasso
//
//  Created by Julian on 29/10/2013.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkViewController : UIViewController  <UIGestureRecognizerDelegate> {
    UISwipeGestureRecognizer *swipeDown;
    UISwipeGestureRecognizer *swipeUp;
    UITapGestureRecognizer *touch;
    BOOL isFullScreen;
    CGRect prevFrame;
}

@property (weak, nonatomic) IBOutlet UIImageView *workImage;

@property (weak, nonatomic) IBOutlet UIScrollView *workContent;

@property (nonatomic, readwrite, assign) int workId;

@end