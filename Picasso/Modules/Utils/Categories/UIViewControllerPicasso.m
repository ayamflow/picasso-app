//
//  UIViewControllerPicasso.m
//  Picasso
//
//  Created by Hellopath on 19/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "UIViewControllerPicasso.h"
#import "Menu.h"

@implementation UIViewController (Picasso)

- (void)hideNavigationBar {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)showNavigationBar {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)rotateToLandscapeOrientation {
//    [self willRotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft duration:0]; // Cleaner rotate
    UIViewController* forcePortrait = [[UIViewController alloc] init];
    [self presentViewController:forcePortrait animated:NO completion:^{
        [forcePortrait dismissViewControllerAnimated:NO completion:nil];
    }];
}

/*- (void)showMenuWithExploreMode:(BOOL)isExploreMode andSceneMode:(BOOL)isSceneMode{
    Menu *menu = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    menu.wasInExploreMode = isExploreMode;
    menu.wasInSceneMode = isSceneMode;
    [self.navigationController pushViewController:menu animated:YES];
}*/

- (void)showMenuWithOrientation:(UIInterfaceOrientation)orientation andExploreMode:(BOOL)isExploreMode andSceneMode:(BOOL)isSceneMode {
    Menu *menu = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    menu.wasInExploreMode = isExploreMode;
    menu.wasInSceneMode = isSceneMode;
    menu.previousOrientation = orientation;
    [self.navigationController pushViewController:menu animated:YES];
}

@end