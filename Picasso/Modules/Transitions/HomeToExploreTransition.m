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
#import "Home.h"
#import "SceneChooser.h"
#import "UIView+EasingFunctions.h"
#import "easing.h"

@interface HomeToExploreTransition ()

@property (assign, nonatomic) NSInteger animablesNumber;
@property (assign, nonatomic) NSInteger animablesDone;

@property (assign, nonatomic) NSInteger inAnimablesNumber;
@property (assign, nonatomic) NSInteger inAnimablesDone;

@end

@implementation HomeToExploreTransition

- (void)perform {
    NSLog(@"perform segue...");
    
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    Home *homeView = ((Home *)sourceViewController);
    
    self.animablesDone = 0;
    self.animablesNumber = 4;
    
//    CGSize screenSize = [OrientationUtils nativeLandscapeDeviceSize].size;
    NSTimeInterval outDuration = 1;
    
    [self translateElementOut:homeView.exploreButton at:0 withDuration: outDuration];
    [self translateElementOut:homeView.logo.view at:0.1 withDuration:outDuration];
    [self translateElementOut:homeView.galleryButton at:0.05 withDuration:outDuration];
    [self translateElementOut:homeView.museumButton at:0.1 withDuration:outDuration];
}

- (void)translateElementOut:(UIView *)view at:(NSTimeInterval)startTime withDuration:(NSTimeInterval)duration {
    CGRect screenSize = [OrientationUtils nativeLandscapeDeviceSize];
    [UIView animateWithDuration:duration delay:startTime options:UIViewAnimationOptionTransitionNone animations:^{
//        [view setEasingFunction:ElasticEaseInOut forKeyPath:@"view"];
        view.layer.position = CGPointMake(view.layer.position.x - screenSize.size.width, view.layer.position.y);
    } completion:^(BOOL finished) {
//        [view removeEasingFunctionForKeyPath:@"view"];
        [self transitionOutComplete];
    }];
}

- (void)transitionOutComplete {
    if(++self.animablesDone == self.animablesNumber) {
        [self destinationTransitionIn];
    }
}

- (void)destinationTransitionIn {
    NSLog(@"transitionIn start");
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    SceneChooser *sceneView = ((SceneChooser *)destinationController);
    
    [sourceViewController.view addSubview:destinationController.view];
    
    self.inAnimablesDone = 0;
    self.inAnimablesNumber = [sceneView.sceneButtons count] + 2; // image + title

    NSTimeInterval inDuration = 1;
    
    for(int i = 0; i < [sceneView.sceneButtons count]; i++) {
        [self translateElementIn:[sceneView.sceneButtons objectAtIndex:i] at:i * 0.02 withDuration:inDuration];
    }
    
    [self translateElementIn:sceneView.titleImage at:0.2 withDuration:inDuration];
    [self translateElementIn:sceneView.titleLabel at:0.25 withDuration:inDuration];
}

- (void)translateElementIn:(UIView *)view at:(NSTimeInterval)startTime withDuration:(NSTimeInterval)duration {
    CGRect screenSize = [OrientationUtils nativeLandscapeDeviceSize];
    view.layer.position = CGPointMake(view.layer.position.x + screenSize.size.width, view.layer.position.y);
    [UIView animateWithDuration:duration delay:startTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        [view setEasingFunction:ElasticEaseInOut forKeyPath:@"view"];
        view.layer.position = CGPointMake(view.layer.position.x - screenSize.size.width, view.layer.position.y);
    } completion:^(BOOL finished) {
//        [view removeEasingFunctionForKeyPath:@"view"];
        [self transitionInComplete];
    }];
}

- (void)transitionInComplete {
    if(++self.inAnimablesDone == self.inAnimablesNumber) {
        [self addDestinationViewController];
    }
}

- (void)addDestinationViewController {
    UINavigationController *navigationController = [(UIViewController*)[self sourceViewController] navigationController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    [navigationController pushViewController:destinationController animated:NO];
    [destinationController rotateToLandscapeOrientation];
}
    
@end
