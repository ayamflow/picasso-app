//
//  ExploreToSceneTransition.m
//  Picasso
//
//  Created by Hellopath on 20/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "ExploreToSceneTransition.h"
#import "SceneChooser.h"
#import "SceneManager.h"
#import "Scene.h"
#import "OrientationUtils.h"
#import "UIViewControllerPicasso.h"

@interface ExploreToSceneTransition ()

@property (assign, nonatomic) NSInteger animablesDone;
@property (assign, nonatomic) NSInteger animablesNumber;

@property (assign, nonatomic) NSInteger inAnimablesDone;
@property (assign, nonatomic) NSInteger inAnimablesNumber;

@end

@implementation ExploreToSceneTransition

- (void)perform {
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    SceneChooser *chooserView = ((SceneChooser *)sourceViewController);
    
    self.animablesDone = 0;
    self.animablesNumber = [chooserView.sceneButtons count] + 2;
    
    NSTimeInterval inDuration = 1;

    for(int i = 0; i < [chooserView.sceneButtons count]; i++) {
        [self translateElementOut:[chooserView.sceneButtons objectAtIndex:i] at:i * 0.02 withDuration:inDuration];
    }
    
    [self translateElementOut:chooserView.titleImage at:0.2 withDuration:inDuration];
    [self translateElementOut:chooserView.titleLabel at:0.25 withDuration:inDuration];
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
        [self transitionIn];
    }
}

- (void)transitionIn {
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
//    Scene *sceneView = ((Scene *)((SceneManager *)destinationController).currentScene);

    [sourceViewController.view addSubview:destinationController.view];
    
//    [self translateElementIn:sceneView.dateImageView at:0 withDuration:1];
//    [self translateElementIn:sceneView.dateTitle at:0 withDuration:1];
//    [self translateElementIn:sceneView.sceneTitle at:0.2 withDuration:1];

//    UILabel *sceneTitle;
//    UILabel *dateTitle;
//    UIImageView *dateImageView;
}

- (void)translateElementIn:(UIView *)view at:(NSTimeInterval)startTime withDuration:(NSTimeInterval)duration {
    CGRect screenSize = [OrientationUtils nativeLandscapeDeviceSize];
    view.layer.position = CGPointMake(view.layer.position.x + screenSize.size.width, view.layer.position.y);
    [UIView animateWithDuration:duration delay:startTime options:UIViewAnimationOptionTransitionNone animations:^{
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
