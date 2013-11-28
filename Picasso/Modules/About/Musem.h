//
//  About.h
//  Picasso
//
//  Created by Florian Morel on 04/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Musem : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *navBar;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *exploreButton;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;

@property (strong, nonatomic) UILabel *hotelTitle;
@property (strong, nonatomic) UILabel *hotelSubtitle;
@property (strong, nonatomic) UITableView *tableView;

@end
