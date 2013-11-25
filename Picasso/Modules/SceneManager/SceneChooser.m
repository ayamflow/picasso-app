//
//  SceneChooserViewController.m
//  Picasso
//
//  Created by MOREL Florian on 31/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "SceneChooser.h"
#import "DataManager.h"
#import "SceneManager.h"
#import "UIViewControllerPicasso.h"
#import "UIViewPicasso.h"
#import "Colors.h"
#import "OrientationUtils.h"
#import "OpacityTransition.h"
#import "ScenePreview.h"
#import "SceneModel.h"

@interface SceneChooser ()

@end

@implementation SceneChooser

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor clearColor];
    [self rotateToLandscapeOrientation];
}

- (void)addSceneWithNumber:(NSInteger)sceneNumber {
    SceneModel *sceneModel = [[DataManager sharedInstance] getSceneWithNumber:sceneNumber];
    
    ScenePreview *scene = [[ScenePreview alloc] initWithModel:sceneModel];
    [self.view addSubview:scene.view];
    [scene.view moveTo:CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - scene.view.frame.size.width / 2, 0)];
}

- (void)sceneDragged:(id)sender {
    // first scene to left / last scene to right > drag a bit then lock
    // scene dragged 80% left/right > animate scene out & next scene in
}

- (void)sceneTouched:(id)sender {
    // Touch feedback
    // Set global scene model
    [[DataManager sharedInstance] getGameModel].currentScene = ((ScenePreview *)sender).sceneNumber;
    // Out animation
    // go to SceneManager
}

@end
