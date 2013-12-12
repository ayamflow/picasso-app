//
//  Home.h
//  Picasso
//
//  Created by Florian Morel on 04/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Home : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *exploreButton;
@property (weak, nonatomic) IBOutlet UIButton *galleryButton;
@property (weak, nonatomic) IBOutlet UIButton *museumButton;
@property (weak, nonatomic) IBOutlet UIButton *creditsButton;

@end
