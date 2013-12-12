//
//  HoursPanel.m
//  Picasso
//
//  Created by MOREL Florian on 27/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "HoursPanel.h"
#import "UIViewPicasso.h"
#import "TextUtils.h"

@implementation HoursPanel

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTexts];
}

- (void)initTexts {
    self.morningLabel.attributedText = [TextUtils getKernedString:self.morningLabel.text];
    self.morningLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.morningLabel.layer.borderWidth = 1;

    self.afternoonLabel.attributedText = [TextUtils getKernedString:self.afternoonLabel.text];
    self.afternoonLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.afternoonLabel.layer.borderWidth = 1;
}

@end