//
//  SceneChooserViewController.h
//  Picasso
//
//  Created by MOREL Florian on 31/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface SceneChooser : UIViewController <iCarouselDataSource, iCarouselDelegate>
@property (strong, nonatomic) iCarousel *carousel;

@end
