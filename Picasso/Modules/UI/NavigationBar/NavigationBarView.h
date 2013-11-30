//
//  NavigationBar.h
//  Picasso
//
//  Created by Florian Morel on 30/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationBarView : UIView

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andShowExploreButton:(BOOL)showExploreButton;

@property (assign, nonatomic) BOOL hasExploreButton;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *exploreButton;

@end
