//
//  WorkFullViewController.h
//  Picasso
//
//  Created by RENARD Julian on 13/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkFullViewController : UIViewController <UIScrollViewDelegate> {

}

@property (nonatomic, readwrite, assign) int workId;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleWorkLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbersWorkLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *textWorkView;

@end