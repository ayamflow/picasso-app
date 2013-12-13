//
//  WorkFullViewController.h
//  Picasso
//
//  Created by RENARD Julian on 13/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBarView.h"

@interface WorkFullViewController : UIViewController <UIScrollViewDelegate, UITextViewDelegate, NSLayoutManagerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, readwrite, assign) int workId;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleWorkLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbersWorkLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *textWorkView;
@property (weak, nonatomic) IBOutlet UILabel *textTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textHLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLLabel;
@property (weak, nonatomic) IBOutlet UILabel *textTechniqueLabel;
@property (weak, nonatomic) IBOutlet UIView *questionView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIView *choice1View;
@property (weak, nonatomic) IBOutlet UIView *choice2View;
@property (weak, nonatomic) IBOutlet UILabel *choice1Label;
@property (weak, nonatomic) IBOutlet UILabel *choice2label;
@property (weak, nonatomic) IBOutlet UITextView *answerView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionWorkView;
@property (weak, nonatomic) IBOutlet UIView *questionBgView;
@property (weak, nonatomic) IBOutlet UITextView *answerTextView;
@property (assign, nonatomic) BOOL showExploreButton;
@property (weak, nonatomic) IBOutlet UILabel *textPlaceLabel;
@property (assign, nonatomic) BOOL didRotate;
@property (weak, nonatomic) IBOutlet UIView *viewDescription;

@end