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
#import "ScenePreview.h"
#import "SceneModel.h"

#define kDirectionNone 0
#define kDirectionLeft 1
#define kDirectionRight 2

@interface SceneChooser ()

@property (strong, nonatomic) ScenePreview *currentPreview;
@property (strong, nonatomic) ScenePreview *oldPreview;

@property (strong, nonatomic) UIPanGestureRecognizer *panRecognizer;

@property (assign, nonatomic) NSInteger currentSceneNumber;

@property (assign, nonatomic) float panDistance;
@property (assign, nonatomic) NSInteger panDirection;

@end

@implementation SceneChooser

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    
	self.view.backgroundColor = [UIColor clearColor];
    [self rotateToLandscapeOrientation];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homeBackground.png"]];
    [self.view addSubview:background];
    
    self.currentSceneNumber = 0;
    
    [self initGesture];
    [self addSceneWithNumber:self.currentSceneNumber];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"transitionIn");
    [self.currentPreview.view moveTo:CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width, 0)];
    self.currentPreview.view.alpha = 0;

    [UIView animateWithDuration:0.4 animations:^{
        [self.currentPreview.view moveTo:CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - self.currentPreview.previewWidth / 2, 0)];
        self.currentPreview.view.alpha = 1;
    } completion:^(BOOL finished) {
        [super viewWillAppear:NO];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"transitionOut");
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.currentPreview.view moveTo:CGPointMake(- self.currentPreview.previewWidth, 0)];
        self.currentPreview.view.alpha = 0;
    } completion:^(BOOL finished) {
        [super viewWillDisappear:NO];
    }];
}

- (void)initGesture {
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sceneDragged:)];
    self.panRecognizer.delegate = self;
    self.panRecognizer.minimumNumberOfTouches = 1;
    self.panRecognizer.maximumNumberOfTouches = 1;
}

- (void)addSceneWithNumber:(NSInteger)sceneNumber {
    SceneModel *sceneModel = [[DataManager sharedInstance] getSceneWithNumber:sceneNumber];
    
    self.currentPreview = [[ScenePreview alloc] initWithModel:sceneModel];
    [self.view addSubview:self.currentPreview.view];
    [self addChildViewController:self.currentPreview];
    
    [self.currentPreview.view addGestureRecognizer:self.panRecognizer];
}

- (void)removeOldScene {
    [self.oldPreview removeFromParentViewController];
    [self.oldPreview.view removeFromSuperview];
    self.oldPreview = nil;
}

- (void)addNextSceneAt:(float)nextSceneDestination {
    // Create & add the next preview
    [self.currentPreview.view removeGestureRecognizer:self.panRecognizer];
    self.oldPreview = self.currentPreview;
    self.currentPreview = nil;
    [self addSceneWithNumber:self.currentSceneNumber];
    [self.currentPreview.view moveTo:CGPointMake(nextSceneDestination, 0)];
    self.currentPreview.view.alpha = 0;
}

- (void)sceneDragged:(UIPanGestureRecognizer *)panRecognizer {
    CGPoint translation = [panRecognizer translationInView:self.view];
    panRecognizer.view.center = CGPointMake(panRecognizer.view.center.x + translation.x, panRecognizer.view.center.y);
    [panRecognizer setTranslation: CGPointMake(0, 0) inView:self.view];
    
    if(panRecognizer.state == UIGestureRecognizerStateBegan) {
//        panRecognizer.view.alpha = 0.9;
    }
    if(panRecognizer.state == UIGestureRecognizerStateChanged) {
        [self dragPreview];
        
    }
    if(panRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.currentPreview resetButtonColor];
        [self switchScene];
    }
}

- (void)dragPreview {
    float middle = [OrientationUtils nativeLandscapeDeviceSize].size.width / 2;
    float previewMiddle = self.panRecognizer.view.frame.origin.x + self.currentPreview.previewWidth / 2;
    self.panDistance = sqrt((middle - previewMiddle) * (middle - previewMiddle));
    self.panRecognizer.view.alpha = 0.9 - (self.panDistance / [OrientationUtils nativeLandscapeDeviceSize].size.width / 2);
    
    if(previewMiddle > middle) self.panDirection = kDirectionRight;
    else if (previewMiddle < middle) self.panDirection = kDirectionLeft;
    else self.panDirection = kDirectionNone;
}

- (void)switchScene {
    float destination = 0;
    float alpha = 0;
    BOOL addScene = YES;
    
    // If the scene has been dragged enough
    if(self.panDistance > 30) {
        if(self.panDirection == kDirectionLeft) {
            destination = - self.currentPreview.previewWidth;
            if(self.currentSceneNumber >= [[DataManager sharedInstance] getScenesNumber] - 1) {
                self.currentSceneNumber = 0;
            }
            else {
                self.currentSceneNumber = self.currentSceneNumber + 1;
            }
            [self addNextSceneAt:[OrientationUtils nativeLandscapeDeviceSize].size.width];
        }
        else if(self.panDirection == kDirectionRight) {
            destination = [OrientationUtils nativeLandscapeDeviceSize].size.width;
            if(self.currentSceneNumber < 1) {
                self.currentSceneNumber = [[DataManager sharedInstance] getScenesNumber] - 1;
            }
            else {
                self.currentSceneNumber = self.currentSceneNumber - 1;
            }
            [self addNextSceneAt:- self.currentPreview.previewWidth];
        }
    }
    else {
        self.oldPreview = self.currentPreview;
        destination = [OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - self.currentPreview.previewWidth / 2;
        alpha = 1;
        addScene = NO;
    }
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.oldPreview.view moveTo:CGPointMake(destination, 0)];
        self.oldPreview.view.alpha = alpha;
        if(addScene) {
            [self.currentPreview.view moveTo:CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - self.currentPreview.view.frame.size.width / 2, 0)];
            self.currentPreview.view.alpha = 1;
        }
    } completion:^(BOOL finished) {
        if(addScene) {
            [self removeOldScene];
        }
    }];
}

@end
