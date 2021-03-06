//
//  SceneChooserLandscape.h
//  Picasso
//
//  Created by Florian Morel on 30/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "NavigationBarView.h"
#import "SceneChooserLandscapeDelegate.h"
#import "MapTranslationDelegate.h"

@interface SceneChooserLandscape : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (strong, nonatomic) iCarousel *carousel;
@property (weak, nonatomic) id<SceneChooserLandscapeDelegate> delegate;
@property (weak, nonatomic) id<MapTranslationDelegate> mapDelegate;

@end