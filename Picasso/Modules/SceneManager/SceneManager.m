//
//  SceneManager.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "SceneManager.h"
#import "Scene.h"
#import "SceneModel.h"
#import "DataManager.h"
#import "SceneInterstitial.h"
#import "OrientationUtils.h"
#import "Menu.h"

@interface SceneManager ()

@property (strong, nonatomic) Scene *oldScene;
@property (strong, nonatomic) Scene *currentScene;
@property (strong, nonatomic) SceneInterstitial *interstitial;
@property (assign, nonatomic) NSInteger scenesNumber;
@property (strong, nonatomic) UIButton *menuSlider;
@property (assign, nonatomic) BOOL menuShown;
@property (assign, nonatomic) BOOL shouldShowMenu;
@property (strong, nonatomic) Menu *menu;

@end

@implementation SceneManager

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    DataManager *dataManager = [DataManager sharedInstance];
    self.scenesNumber = [dataManager getScenesNumber];
    
    // Auto launch
    [self showSceneWithNumber:[[dataManager getGameModel] currentScene]];
	[self initMenu];
}

- (void)initMenu {
    self.menuSlider = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.menuSlider setImage:[UIImage imageNamed:@"menuSlider.png"] forState:UIControlStateNormal];
//    self.menuSlider.layer.position = CGPointMake([OrientationUtils deviceSize].size.width / 2 - self.menuSlider.frame.size.width / 2, self.menuSlider.frame.size.height * 2);
//    self.menuSlider.layer.position = CGPointMake(40, 40);
	[self.view addSubview:self.menuSlider];
//    self.menuSlider.backgroundColor = [UIColor redColor];
//    [self.view bringSubviewToFront:self.menuSlider];
//    [self.menuSlider addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];

}

- (void)showMenu {
    self.menu = [[Menu alloc] init];
    [self.view addSubview:self.menu.view];
    self.menu.view.layer.position = CGPointMake(0.0, -[OrientationUtils nativeLandscapeDeviceSize].size.height);
    [UIView animateWithDuration:0.3 animations:^{
		self.menu.view.layer.position = CGPointMake(0.0, 0.0);
    }];
}

/*- (void)initMenu {
    self.menuSlider = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.menuSlider setImage:[UIImage imageNamed:@"menuSlider.png"] forState:UIControlStateNormal];
    self.menuSlider.layer.position = CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - self.menuSlider.frame.size.width / 2, self.menuSlider.frame.size.height * 2);
	[self.view addSubview:self.menuSlider];
    [self.view bringSubviewToFront:self.menuSlider];
    //    self.menuSlider addTarget:self action:@selector(menuSliderTouched) forControlEvents:UIControlEvent

    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panRecognizer.minimumNumberOfTouches = 1;
    panRecognizer.maximumNumberOfTouches = 1;
    panRecognizer.delegate = self;
    [self.view addGestureRecognizer:panRecognizer];
}*/

/*- (void)handlePanGesture:(id)sender {
	UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer *) sender;
    [panRecognizer.view.layer removeAllAnimations];

    CGPoint translation = [panRecognizer translationInView:self.view];
    CGPoint velocity = [panRecognizer velocityInView:self.view];

    if(panRecognizer.state == UIGestureRecognizerStateBegan) {
		if(velocity.y > 0 && !self.menuShown) {
            UIView *menuView = [self getMenuView];

            [self.view bringSubviewToFront:menuView];
        }
    }

    if(panRecognizer.state == UIGestureRecognizerStateChanged) {
        float halfScreensize = [OrientationUtils nativeLandscapeDeviceSize].size.width / 2;
		self.shouldShowMenu = abs(panRecognizer.view.center.x - halfScreensize > halfScreensize);

        panRecognizer.view.center = CGPointMake(panRecognizer.view.center.x, panRecognizer.view.center.y + translation.y);
        [panRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    }

    if(panRecognizer.state == UIGestureRecognizerStateEnded) {
		if(!self.shouldShowMenu) {
			[self resetMenu];
        }
        else if(self.menuShown) {
            [self showMenu];
        }
    }
}*/

/*- (UIView *)getMenuView {
    if(self.menu == nil) {
        self.menu = [[Menu alloc] init];
//        self.menu.delegate = self;

        [self.view addSubview:self.menu.view];
        [self addChildViewController:self.menu];
        [self.menu didMoveToParentViewController:self];
        self.menu.view.frame = [OrientationUtils nativeLandscapeDeviceSize];
    }

    self.menuShown = YES;
    return self.menu.view;
}*/

/*- (void)resetMenu {
	[self.view bringSubviewToFront:self.menu.view];
    [UIView animateWithDuration:0.5 delay: 0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
		self.menu.view.layer.position = CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2, -[OrientationUtils nativeLandscapeDeviceSize].size.height / 2);
    } completion:^(BOOL finished) {
		[self.menu.view removeFromSuperview];
        self.menu = nil;
        self.menuShown = NO;
    }];

}*/

/*- (void)showMenu {
	[self.view bringSubviewToFront:self.menu.view];
    [UIView animateWithDuration:0.5 delay: 0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
		self.menu.view.layer.position = CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2, [OrientationUtils nativeLandscapeDeviceSize].size.height / 2);
    } completion:^(BOOL finished) {}];
}*/

- (void)showSceneWithNumber:(NSInteger)number {
    // update oldScene
    if(self.currentScene) {
        [self.currentScene stop];
        [self.currentScene.view removeFromSuperview];
        self.oldScene = self.currentScene;
    }
    
    // create a new scene into *currentScene
    [self createSceneWithNumber:number andPosition:CGPointMake(0, 0)];
}

- (void)createSceneWithNumber:(NSInteger)number andPosition:(CGPoint)position {
    DataManager *dataManager = [DataManager sharedInstance];
    SceneModel *sceneModel = [dataManager getSceneWithNumber:number];

    self.oldScene = self.currentScene;
    self.currentScene = [[Scene alloc] initWithModel:sceneModel andPosition:position];
    self.currentScene.delegate = self;
    [self.view addSubview:self.currentScene.view];
}

- (void)removeLastSeenScene {
    NSLog(@"[SceneManager] RemoveLastSeenScene #%li", (long)self.oldScene.model.number);
    if(self.oldScene) {
        [self.oldScene stop];
        [self.oldScene.view removeFromSuperview];
        self.oldScene.delegate = nil;
        self.oldScene = nil;
    }
}

- (void)showInterstitial {
    if(self.interstitial != nil) [self removeInterstitial];
    self.interstitial = [[SceneInterstitial alloc] initWithModel:self.currentScene.model];
    self.interstitial.slidingButton.delegate = self;
    [self.view addSubview:self.interstitial.view];
//	[self.navigationController presentViewController:self.interstitial animated:NO completion:nil];
}

- (void)removeInterstitial {
    [self.interstitial.view removeFromSuperview];
    self.interstitial = nil;
}

- (void)skipInterstitial {
    [self createSceneWithNumber:[self getNextSceneNumber] andPosition:CGPointMake(0, self.currentScene.view.frame.size.height)];
    [UIView animateWithDuration:0.4f animations:^{
        // Move old scene & interstitial out of the screen
        CGPoint oldScenePosition = CGPointMake(0, -self.oldScene.view.frame.size.height);
        CGRect oldSceneFrame = self.oldScene.view.frame;
        oldSceneFrame.origin = oldScenePosition;
        self.oldScene.view.frame = oldSceneFrame;
        self.interstitial.view.frame = oldSceneFrame;
        // Move new scene into the screen
        CGPoint currentScenePosition = CGPointMake(0, 0);
        CGRect currentSceneFrame = self.currentScene.view.frame;
        currentSceneFrame.origin = currentScenePosition;
        self.currentScene.view.frame = currentSceneFrame;
    } completion:^(BOOL finished) {
        [self removeLastSeenScene];
        [self removeInterstitial];
    }];
}

// Implementation of the SceneManaging Protocol

- (void)fadeCurrentSceneToBlack {
    [UIView animateWithDuration:0.5f animations:^{
        [self.currentScene.view setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self showInterstitial];
    }];
}

- (void)showNextScene {
    [self showSceneWithNumber:[self getNextSceneNumber]];
}

- (void)showPreviousScene {
    [self showSceneWithNumber:[self getPreviousSceneNumber]];
}

- (NSInteger)getNextSceneNumber {
    return self.currentScene.model.number < self.scenesNumber - 1 ? self.currentScene.model.number + 1 : 0;
}

- (NSInteger)getPreviousSceneNumber {
    return self.currentScene.model.number > 0 ? self.currentScene.model.number - 1 : self.scenesNumber - 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end