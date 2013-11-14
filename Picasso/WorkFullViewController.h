//
//  WorkFullViewController.h
//  Picasso
//
//  Created by RENARD Julian on 13/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkFullViewController : UIViewController <UIScrollViewDelegate> {
    UIView *backgroundView;
    UIScrollView *firstView;
    UIScrollView *frontView;
    UIImageView *backgroundFirstView;
}

@property (nonatomic, readwrite, assign) int workId;

@end
