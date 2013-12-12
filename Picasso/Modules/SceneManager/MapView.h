//
//  MapView.h
//  Picasso
//
//  Created by Florian Morel on 01/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapTranslationDelegate.h"

@interface MapView : UIView <UIScrollViewDelegate, MapTranslationDelegate>

@property (strong, nonatomic) NSArray *scenes;

- (void)showDetails;
- (void)clearPaths;
- (void)clearAnimatedPath;
- (void)scrollToIndex:(NSInteger)index andAnimated:(BOOL)animated;

@end
