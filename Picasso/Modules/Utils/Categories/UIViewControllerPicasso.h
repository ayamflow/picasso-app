//
//  UIViewControllerPicasso.h
//  Picasso
//
//  Created by Hellopath on 19/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (Picasso)

- (void)hideNavigationBar;
- (void)showNavigationBar;
- (void)rotateToLandscapeOrientation;
//- (void)showMenuWithExploreMode:(BOOL)isExploreMode andSceneMode:(BOOL)isSceneMode;
- (void)showMenuWithOrientation:(UIInterfaceOrientation)orientation andExploreMode:(BOOL)isExploreMode andSceneMode:(BOOL)isSceneMode;
- (void)showMenuWithOrientation:(UIInterfaceOrientation)orientation andLayer:(CALayer *)screen andExploreMode:(BOOL)isExploreMode andSceneMode:(BOOL)isSceneMode;

@end