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
    UIViewController* forcePortrait = [[UIViewController alloc] init];
    [self presentViewController:forcePortrait animated:NO completion:^{
        [forcePortrait dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)showMenuWithExploreMode:(BOOL)isExploreMode andSceneMode:(BOOL)isSceneMode{
    //    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    Menu *menu = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    menu.wasInExploreMode = isExploreMode;
    menu.wasInSceneMode = isSceneMode;
    [self.navigationController pushViewController:menu animated:YES];
    //    [self.navigationController presentViewController:menu animated:YES completion:nil];
}

@end