//
//  SceneMenu.h
//  Picasso
//
//  Created by Florian Morel on 30/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneModel.h"
#import "NavigationBarView.h"

@interface SceneMenu : UIViewController

- (id)initWithModel:(SceneModel *)model;

@property (strong, nonatomic) NavigationBarView *navigationBar;

@end
