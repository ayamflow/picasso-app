//
//  OpacityTransition.m
//  Picasso
//
//  Created by Florian Morel on 09/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "OpacityTransition.h"

@implementation OpacityTransition

+ (CATransition *)getOpacityTransition {
    CATransition* transition = [CATransition animation];
    transition.duration = .5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;

    return transition;
}

- (void)perform {
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];

    CATransition* transition = [OpacityTransition getOpacityTransition];

    [sourceViewController.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [sourceViewController.navigationController pushViewController:destinationController animated:NO];
}


@end
