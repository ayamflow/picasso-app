//
//  MenuButton.h
//  Picasso
//
//  Created by MOREL Florian on 13/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuButton : UIViewController

@property (assign, nonatomic) BOOL wasExploreMode;
@property (assign, nonatomic) BOOL wasSceneMode;

- (id)initWithExploreMode:(BOOL)isExploreMode;

@end
