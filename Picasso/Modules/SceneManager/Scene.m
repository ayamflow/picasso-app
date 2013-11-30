//
//  SceneViewController.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Scene.h"
#import "SceneChooser.h"
#import "SceneChooserLandscape.h"
#import "SceneModel.h"
#import "DataManager.h"
#import "TrackerModel.h"
#import "OrientationUtils.h"
#import "WorkViewController.h"
#import "SceneManager.h"
#import "Colors.h"
#import "Events.h"
#import "UIViewPicasso.h"
#import "SceneTimeline.h"
#import "SceneMenu.h"
#import "SceneManagerDelegate.h"

#define kPlaybackFadePercent 0.90

#define kSliderHeight 80
#define kSliderVisibleHeight 10

@interface Scene ()

@property (weak, nonatomic) MotionVideoPlayer *playerView;
@property (weak, nonatomic) AVPlayer *player;
@property (assign, nonatomic) float completion;
@property (strong, nonatomic) id playerUpdatesObserver;
@property (assign, nonatomic) BOOL hasEnded;

@property (strong, nonatomic) UILabel *sceneTitle;
@property (strong, nonatomic) UILabel *dateTitle;
@property (strong, nonatomic) UIImageView *dateImageView;

@property (strong, nonatomic) UIView *slider;
@property (strong, nonatomic) SceneTimeline *timeline;
@property (strong, nonatomic) UIPanGestureRecognizer *panRecognizer;
@property (assign, nonatomic) BOOL menuIsOpen;

@property (strong, nonatomic) SceneMenu *menu;

@property (assign, nonatomic) NSInteger transitionsDone;
@property (assign, nonatomic) NSInteger transitionsNumber;

@end

@implementation Scene

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor clearColor];
}

- (id)initWithModel:(SceneModel *)sceneModel {
    if(self = [super init]) {
        self.model = sceneModel;
        self.hasEnded = NO;

        self.playerView = [MotionVideoPlayer sharedInstance];
        self.player = self.playerView.player;

        // Play the scene's video
        NSString *filePath = [[NSBundle mainBundle] pathForResource:self.model.sceneId ofType:self.model.videoType];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        [self.playerView loadURL:url];
        
        [self initTitle:self.model.title];
        [self initDate:self.model.date];
        
        [self initTrackers];
        self.playerUpdatesObserver = [self listenForPlayerUpdates];

        [self initSlider];
        [self initTimeline];
        
        [self transitionIn];

        NSLog(@"[Scene #%li] Started", (long)self.model.number);
        self.player.rate = 2.0; // Maybe stars at 1.0 and tween to 0.0 ?
        [self resume]; // seekToTime + enableMotion
    }
    return self;
}

- (id)initWithModel:(SceneModel *)sceneModel andPosition:(CGPoint)position {
    if(self = [self initWithModel:sceneModel]) {
        CGRect frame = self.view.frame;
        frame.origin = position;
        self.view.frame = frame;
    }
    
    return self;
}

- (void)initSlider {
    self.slider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, kSliderHeight)];
    self.slider.backgroundColor = [UIColor clearColor];
    self.slider.layer.borderColor = [UIColor blackColor].CGColor;
    self.slider.layer.borderWidth = 2;
    [self.view addSubview:self.slider];
    [self resetSliderWithDuration:0];

    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderDragged:)];
    self.panRecognizer.maximumNumberOfTouches = 1;
    self.panRecognizer.minimumNumberOfTouches = 1;
    self.panRecognizer.delegate = self;
    [self.slider addGestureRecognizer:self.panRecognizer];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMenu) name:[MPPEvents MenuExitEvent] object:nil];
}

- (void)initTimeline {
    self.timeline = [[SceneTimeline alloc] initWithModel:self.model];
    [self.view addSubview:self.timeline.view];
    [self.timeline.view moveTo:CGPointMake(0, [OrientationUtils nativeLandscapeDeviceSize].size.height - self.timeline.view.frame.size.height)];
}

- (void)sliderDragged:(UIPanGestureRecognizer *)panRecognizer {
    CGPoint translation = [panRecognizer translationInView:self.view];
    panRecognizer.view.center = CGPointMake(panRecognizer.view.center.x, panRecognizer.view.center.y + translation.y);
    [panRecognizer setTranslation: CGPointMake(0, 0) inView:self.view];

    if(panRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat sliderBottom = self.slider.frame.origin.y + self.slider.frame.size.height;
        [self.menu.view moveTo:CGPointMake(0, - self.menu.view.frame.size.height + sliderBottom - kSliderVisibleHeight)];

        [self.timeline.view moveTo:CGPointMake(self.timeline.view.frame.origin.x, self.timeline.view.frame.origin.y + sliderBottom * 0.05)];

        if(sliderBottom >= kSliderHeight - kSliderVisibleHeight) {
            [self.slider removeGestureRecognizer:self.panRecognizer];
            [UIView animateWithDuration:0.4 animations:^{
                [self.slider moveTo:CGPointMake(self.slider.frame.origin.x, -kSliderHeight)];
            } completion:^(BOOL finished) {
                [self showMenu];
            }];
        }
    }
    if(panRecognizer.state == UIGestureRecognizerStateEnded) {
        if(!self.menuIsOpen) [self resetSliderWithDuration:0.4];
    }
}

- (void)resetSliderWithDuration: (NSTimeInterval)duration {
    if(duration == 0) {
        [self.slider moveTo:CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - self.slider.frame.size.width / 2, -(self.slider.frame.size.height - kSliderVisibleHeight))];
        [self.timeline.view moveTo:CGPointMake(0, [OrientationUtils nativeLandscapeDeviceSize].size.height - self.timeline.view.frame.size.height)];
    }
    else {
        [UIView animateWithDuration:duration animations:^{
            [self.slider moveTo:CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - self.slider.frame.size.width / 2, -(self.slider.frame.size.height - kSliderVisibleHeight))];
            [self.timeline.view moveTo:CGPointMake(0, [OrientationUtils nativeLandscapeDeviceSize].size.height - self.timeline.view.frame.size.height)];
        }];
    }
}

- (void)showMenu {
    if(self.menuIsOpen) return;
    self.menuIsOpen = YES;

    [self.slider removeGestureRecognizer:self.panRecognizer];

    if(self.menu == nil) {
        self.menu = [[SceneMenu alloc] initWithModel:self.model];
        self.menu.delegate = (UIViewController <SceneManagerDelegate> *)self.parentViewController;
    }
    self.menu.view.frame = [OrientationUtils nativeLandscapeDeviceSize];
    [self.view addSubview:self.menu.view];
    [self.menu.view moveTo:CGPointMake(0, -self.menu.view.frame.size.height)];
    [self addChildViewController:self.menu];
 
    [UIView animateWithDuration:0.4 animations:^{
        [self.menu.view moveTo:CGPointMake(0, 0)];
        [self.timeline.view moveTo:CGPointMake(0, [OrientationUtils nativeLandscapeDeviceSize].size.height)];
    } completion:^(BOOL finished) {
        [self stop];
    }];
}

- (void)hideMenu {
    if(!self.menuIsOpen) return;
    self.menuIsOpen = NO;
    [self.slider removeGestureRecognizer:self.panRecognizer];
    [self resetSliderWithDuration:0.4];
    [UIView animateWithDuration:0.4 animations:^{
        [self.menu.view moveTo:CGPointMake(0, - self.menu.view.frame.size.height)];
        [self.timeline.view moveTo:CGPointMake(0, [OrientationUtils nativeLandscapeDeviceSize].size.height - self.timeline.view.frame.size.height)];
    } completion:^(BOOL finished) {
        [self.menu removeFromParentViewController];
        [self.menu.view removeFromSuperview];
        [self.slider addGestureRecognizer:self.panRecognizer];
        [self resume];
    }];
}

- (void)initTitle:(NSString *)title {
    float topPosition = [OrientationUtils nativeLandscapeDeviceSize].size.height / 2 - self.sceneTitle.frame.size.height / 2 - 50;
    self.sceneTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200.0, 40.0)];
    self.sceneTitle.text = [title uppercaseString];
    [self.sceneTitle setTextAlignment:NSTextAlignmentCenter];
    self.sceneTitle.textColor = [UIColor textColor];
    self.sceneTitle.font = [UIFont fontWithName:@"BrandonGrotesque-Medium" size:15.0];
    
    self.sceneTitle.layer.borderColor = [UIColor textColor].CGColor;
    self.sceneTitle.layer.borderWidth = 2.0;
    
    [self.sceneTitle moveTo:CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - self.sceneTitle.frame.size.width / 2, topPosition)];
    [self.view addSubview:self.sceneTitle];
}

- (void)initDate:(NSString *)date {
    float topPosition = [OrientationUtils nativeLandscapeDeviceSize].size.height / 2 - self.sceneTitle.frame.size.height / 2;
    self.dateTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.0, 45.0)];
    self.dateTitle.text = date;
    self.dateTitle.textColor = [UIColor textColor];
    [self.dateTitle setTextAlignment:NSTextAlignmentCenter];
    self.dateTitle.font = [UIFont fontWithName:@"Avenir" size:12.0];
    
    self.dateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dateTitleSign.png"]];

    [self.dateImageView moveTo:CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - self.dateImageView.frame.size.width / 2, topPosition + self.dateTitle.frame.size.height - 22)];
    [self.dateTitle moveTo:CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - self.dateTitle.frame.size.width / 2, topPosition + 20)];

    [self.view addSubview:self.dateTitle];
    [self.view addSubview:self.dateImageView];
}

- (void)transitionIn {
    [self translateElementIn:self.dateImageView at:0 withDuration:1];
    [self translateElementIn:self.dateTitle at:0 withDuration:1];
    [self translateElementIn:self.sceneTitle at:0.05 withDuration:1];

    self.transitionsNumber++;
    [self.timeline.view moveTo:CGPointMake(0, [OrientationUtils nativeLandscapeDeviceSize].size.height + self.timeline.view.frame.size.height)];
    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
	    [self.timeline.view moveTo:CGPointMake(0, [OrientationUtils nativeLandscapeDeviceSize].size.height - self.timeline.view.frame.size.height)];
    } completion:^(BOOL finished) {
        [self transitionInComplete];
    }];

}

- (void)translateElementIn:(UIView *)view at:(NSTimeInterval)startTime withDuration:(NSTimeInterval)duration {
    CGRect screenSize = [OrientationUtils nativeLandscapeDeviceSize];
    self.transitionsNumber++;
    view.layer.position = CGPointMake(view.layer.position.x + screenSize.size.width, view.layer.position.y);
    [UIView animateWithDuration:duration delay:startTime options:UIViewAnimationOptionCurveEaseOut animations:^{
        view.layer.position = CGPointMake(view.layer.position.x - screenSize.size.width, view.layer.position.y);
    } completion:^(BOOL finished) {
        [self transitionInComplete];
    }];
}

- (void)transitionInComplete {
    if(++self.transitionsDone == self.transitionsNumber) {
        [UIView animateWithDuration:4 animations:^{
         	self.sceneTitle.alpha = 0;
	         self.dateImageView.alpha = 0;
    	     self.dateTitle.alpha = 0;
         } completion:^(BOOL finished) {
        	 [self.sceneTitle removeFromSuperview];
	         [self.dateImageView removeFromSuperview];
    	     [self.dateTitle removeFromSuperview];
         }];
    }
}

- (void)initTrackers {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"tracker-button" ofType: @"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    
    NSUInteger trackerNumber = [self.model.trackers count];
    NSMutableArray *trackersArray = [[NSMutableArray alloc]initWithCapacity:trackerNumber];
    
    for(int i = 0; i < trackerNumber; i++) {
        UIButton *tracker = [self createTrackerWithImage:image];
        TrackerModel *trackerModel = [self.model.trackers objectAtIndex:i];
        tracker.tag = trackerModel.workId;
        [trackersArray addObject:tracker];
        [tracker addTarget:self action:@selector(trackerTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tracker];
    }
    
    self.trackersImage = [NSArray arrayWithArray:trackersArray];
}

- (UIButton *)createTrackerWithImage:(UIImage *)image {
    UIButton *tracker = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [tracker setBackgroundImage:image forState:UIControlStateNormal];
    [tracker setBackgroundColor:[UIColor blueColor]];
    // Hidden by default
    [tracker setHidden:YES];
    [tracker setEnabled:NO];
    // DEBUG
    tracker.frame = CGRectMake(250, 250, 35, 35);
    return tracker;
}

- (void)trackerTouched:(id)sender {
    NSLog(@"[Scene #%li] Touched tracker with workId %li", self.model.number, [sender tag]);
    [self stop];
    WorkViewController *workView = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"WorkViewController"];
    NSLog(@"workView: %@", workView);
    NSLog(@"parentVC: %@", self.parentViewController);
    workView.workId = [sender tag];
    [self.parentViewController.navigationController presentViewController:workView animated:NO completion:nil];
}

- (id)listenForPlayerUpdates {
    __weak typeof(self) weakSelf = self;
    return [self.player addPeriodicTimeObserverForInterval:CMTimeMake(33, 1000) queue:NULL usingBlock:^(CMTime time) {
        [weakSelf listenForVideoEnded]; // Watch video status
        [weakSelf toggleTrackers]; // Show/hide/move trackers
    }];
}

- (void)listenForVideoEnded {
    self.completion = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.asset.duration);
    if(!self.hasEnded) {
        [self.timeline updateWithCompletion:self.completion];
	    if(self.completion > kPlaybackFadePercent) {
    	    // fade to black proportionaly
    	    self.view.alpha = 1.0 - (self.completion - kPlaybackFadePercent) * 5; // -10% opacity * factor
   	 }
   	 if(self.completion > 1.0) {
         self.hasEnded = YES;
   	     [self playerItemDidReachEnd];
   	 }
    }
}

- (void)toggleTrackers {
    CGFloat currentTime = CMTimeGetSeconds(self.player.currentTime);
    NSInteger currentFrame = self.playerView.frameRate * currentTime;

    // Loop on all trackers (which contains a workId an an array of positions)
    for(int i = 0; i < [self.model.trackers count]; i++) {
        
        // Cache current tracker button and current tracker data (workId, positions)
        NSArray *currentTrackerPositions = [[self.model.trackers objectAtIndex:i] positions];
        UIButton *currentTracker = [self.trackersImage objectAtIndex:i];

        // Loop on all positions of the current tracker
        for(int j = 0; j < [currentTrackerPositions count]; j++) {
            // If a tracker is supposed to show at the current time, show it
            if(currentFrame == [[[currentTrackerPositions objectAtIndex:j] objectAtIndex:0] integerValue]) {
                [currentTracker setHidden:NO];
                [currentTracker setEnabled:YES];
                NSInteger x = [[[currentTrackerPositions objectAtIndex:j] objectAtIndex:1] integerValue];
                NSInteger y = [[[currentTrackerPositions objectAtIndex:j] objectAtIndex:2] integerValue];
                CGRect trackerFrame = currentTracker.frame;
                trackerFrame.origin = CGPointMake(x, y);
                currentTracker.autoresizingMask = UIViewAutoresizingNone;
                currentTracker.frame = trackerFrame;
                return;
            }
            else {
                [currentTracker setHidden:YES];
                [currentTracker setEnabled:NO];
            }
        }
    }
}

- (void)playerItemDidReachEnd{
    NSLog(@"[Scene #%li] Ended", (long)self.model.number);
    [self stop];
    [self.delegate showInterstitial];
}

- (void)stop {
    NSLog(@"[Scene #%li] Stopped.", self.model.number);
    GameModel *gameModel = [[DataManager sharedInstance] getGameModel];
    gameModel.sceneCurrentTime = CMTimeGetSeconds(self.player.currentTime);
    gameModel.currentScene = self.model.number;
    self.player.rate = 0.0;
    [self.playerView disableMotion];
    self.player = nil;
}

- (void)resume {
    NSLog(@"[Scene #%li] Resume.", self.model.number);
    [self.playerView enableMotion];
    self.player = self.playerView.player;
    [self.player seekToTime:CMTimeMakeWithSeconds([[[DataManager sharedInstance] getGameModel] sceneCurrentTime], self.player.currentItem.asset.duration.timescale)];
    // DEBUG
    self.player.rate = 2.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
