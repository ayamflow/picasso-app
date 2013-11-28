//
//  UIViewControllerPicasso.m
//  Picasso
//
//  Created by Hellopath on 19/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "UIViewControllerPicasso.h"
#import "SceneChooser.h"
#import "Home.h"

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

- (void)navigateToExploreMode {
    self.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI_2);
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        SceneChooser *sceneChooser = [self.storyboard instantiateViewControllerWithIdentifier:@"SceneChooser"];
        [self.navigationController pushViewController:sceneChooser animated:NO];
    }];
}

- (void)navigateBackToHome {
    UIViewController *viewController;
    UIView *view;
    
    if(self.parentViewController == self.navigationController) {
        viewController = self;
        view = self.view;
    }
    else {
        viewController = self.parentViewController;
        view = self.parentViewController.view;
    }
    
    view.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [UIView animateWithDuration:0.2 animations:^{
        view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        Home *homeView = [viewController.storyboard instantiateViewControllerWithIdentifier:@"Home"];
        [viewController.navigationController pushViewController:homeView animated:NO];
    }];
}

@end