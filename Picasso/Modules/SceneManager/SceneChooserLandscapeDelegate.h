//
//  SceneChooserLandscapeDelegate.h
//  Picasso
//
//  Created by Florian Morel on 01/12/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SceneChooserLandscapeDelegate <NSObject>

- (void)updateNavigationTitleWithString:(NSString *)title;
- (void)navigateToSceneWithNumber:(NSInteger)number;

@end
