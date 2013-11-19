//
//  HomeToExploreTransition.m
//  Picasso
//
//  Created by Hellopath on 19/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "HomeToExploreTransition.h"
#import "UIViewControllerPicasso.h"
#import "OrientationUtils.h"

@implementation HomeToExploreTransition

- (void)perform {
    NSLog(@"perform segue...");
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    
    CGRect screenSize = [OrientationUtils nativeLandscapeDeviceSize];
    
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        NSLog(@"transitionOut start");
        // Simple : translates view to left
        CGRect sourceFrame = sourceViewController.view.frame;
        sourceFrame.origin = CGPointMake(-screenSize.size.width, 0);
        sourceViewController.view.frame = sourceFrame;
        // Full : move each item (logo/buttons) with differents delays
    } completion:^(BOOL finished) {
        // call transitionIN
        NSLog(@"transitionOut complete");
        [self destinationTransitionIn];
    }];
}

- (void)destinationTransitionIn {
    NSLog(@"transitionIn start");
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];

    CGRect screenSize = [OrientationUtils nativeLandscapeDeviceSize];
    
    CGRect destFrame = destinationController.view.frame;
    destFrame.origin = CGPointMake(screenSize.size.width * 2, 0);
    destinationController.view.frame = destFrame;
    
    [sourceViewController.view addSubview:destinationController.view];
    
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect destFrame = destinationController.view.frame;
        destFrame.origin = CGPointMake(screenSize.size.width, 0);
        destinationController.view.frame = destFrame;
    } completion:^(BOOL finished) {
        NSLog(@"transitionIn Complete");
        [self transitionInComplete];
    }];
}

- (void)transitionInComplete {
    UINavigationController *navigationController = [(UIViewController*)[self sourceViewController] navigationController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    [navigationController pushViewController:destinationController animated:NO];
    [destinationController rotateToLandscapeOrientation];
}
    
@end
