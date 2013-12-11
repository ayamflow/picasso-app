//
//  WorkFullViewController.h
//  Picasso
//
//  Created by RENARD Julian on 13/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkFullViewController : UIViewController <UIScrollViewDelegate, UITextViewDelegate> {

}

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
@property (weak, nonatomic) IBOutlet UIView *descriptionWorkView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionWorkTextView;
@property (weak, nonatomic) IBOutlet UIView *questionView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIView *choice1View;
@property (weak, nonatomic) IBOutlet UIView *choice2View;
@property (weak, nonatomic) IBOutlet UILabel *choice1Label;
@property (weak, nonatomic) IBOutlet UILabel *choice2label;
@property (weak, nonatomic) IBOutlet UITextView *answerView;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@end