//
//  MenuViewController.h
//  Picasso
//
//  Created by MOREL Florian on 30/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuLandscape : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *exploreButton;
@property (weak, nonatomic) IBOutlet UIButton *galleryButton;
@property (weak, nonatomic) IBOutlet UIButton *museumButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (assign, nonatomic) BOOL wasInExploreMode;
@property (assign, nonatomic) BOOL wasInSceneMode;
@property (strong, nonatomic) CALayer *screenLayer;
@property (assign, nonatomic) UIInterfaceOrientation previousOrientation;

@end
