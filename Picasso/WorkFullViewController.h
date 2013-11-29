//
//  WorkFullViewController.h
//  Picasso
//
//  Created by RENARD Julian on 13/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkFullViewController : UIViewController <UIScrollViewDelegate> {
    UIImageView *backgroundView;
    UIImageView *backgroundWorkView;
    UIView *headerView;
    UIImageView *workImageView;
    UIView *workDescriptionView;
}

@property (nonatomic, readwrite, assign) int workId;

@end
