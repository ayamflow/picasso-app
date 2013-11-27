//
//  UIViewControllerPicasso.m
//  Picasso
//
//  Created by Hellopath on 19/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "UIViewControllerPicasso.h"
#import "MenuLandscape.h"

@implementation UIViewController (Picasso)

- (void)hideNavigationBar {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)showNavigationBar {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)updateRotation {
    UIViewController* forceRotation = [[UIViewController alloc] init];
    [self presentViewController:forceRotation animated:NO completion:^{
        [forceRotation dismissViewControllerAnimated:NO completion:nil];
    }];
}

/*- (void)showMenuWithExploreMode:(BOOL)isExploreMode andSceneMode:(BOOL)isSceneMode{
    Menu *menu = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    menu.wasInExploreMode = isExploreMode;
    menu.wasInSceneMode = isSceneMode;
    [self.navigationController pushViewController:menu animated:NO];
}*/

- (void)showMenuWithOrientation:(UIInterfaceOrientation)orientation andExploreMode:(BOOL)isExploreMode andSceneMode:(BOOL)isSceneMode {
    MenuLandscape *menu = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    menu.wasInExploreMode = isExploreMode;
    menu.wasInSceneMode = isSceneMode;
    menu.previousOrientation = orientation;
    [self.navigationController pushViewController:menu animated:NO];
}

- (void)showMenuWithOrientation:(UIInterfaceOrientation)orientation andLayer:(CALayer *)screen andExploreMode:(BOOL)isExploreMode andSceneMode:(BOOL)isSceneMode {
    MenuLandscape *menu = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    menu.wasInExploreMode = isExploreMode;
    menu.wasInSceneMode = isSceneMode;
    menu.previousOrientation = orientation;
    menu.screenLayer = screen;
    [self.navigationController pushViewController:menu animated:NO];
}


@end