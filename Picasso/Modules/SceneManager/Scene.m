//
//  SceneViewController.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Scene.h"
#import "SceneChooser.h"
#import "SceneModel.h"
#import "DataManager.h"
#import "TrackerModel.h"
#import "OrientationUtils.h"
#import "WorkViewController.h"
#import "SceneManager.h"
#import "Colors.h"
#import "UIViewPicasso.h"
#import "SceneTimeline.h"

#define kPlaybackFadePercent 0.90
#define kDirectionNone 0
#define kDirectionLeft 1
#define kDirectionRight 2

@interface Scene ()

@property (weak, nonatomic) MotionVideoPlayer *playerView;
@property (weak, nonatomic) AVPlayer *player;
@property (assign, nonatomic) float completion;
@property (strong, nonatomic) id playerUpdatesObserver;
@property (assign, nonatomic) BOOL hasEnded;

@property (strong, nonatomic) UILabel *sceneTitle;
@property (strong, nonatomic) UILabel *dateTitle;
@property (strong, nonatomic) UIImageView *dateImageView;

@property (strong, nonatomic) SceneTimeline *timeline;
@property (strong, nonatomic) UIPanGestureRecognizer *panRecognizer;
@property (assign, nonatomic) NSInteger panDistance;
@property (assign, nonatomic) NSInteger panDirection;

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

- (void)initTimeline {
    self.timeline = [[SceneTimeline alloc] initWithModel:self.model];
    [self.view addSubview:self.timeline.view];
    [self.timeline.view moveTo:CGPointMake(0, [OrientationUtils nativeLandscapeDeviceSize].size.height - self.timeline.view.frame.size.height)];

    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(timelineDragged:)];
    self.panRecognizer.maximumNumberOfTouches = 1;
    self.panRecognizer.minimumNumberOfTouches = 1;
    self.panRecognizer.delegate = self;
    [self.timeline.view addGestureRecognizer:self.panRecognizer];
}

- (void)timelineDragged:(UIPanGestureRecognizer *)panRecognizer {
    CGPoint translation = [panRecognizer translationInView:self.view];
    panRecognizer.view.center = CGPointMake(panRecognizer.view.center.x, panRecognizer.view.center.y + translation.y);
    [panRecognizer setTranslation: CGPointMake(0, 0) inView:self.view];

    if(panRecognizer.state == UIGestureRecognizerStateBegan) {

    }
    if(panRecognizer.state == UIGestureRecognizerStateChanged) {
        float bottom = [OrientationUtils nativeLandscapeDeviceSize].size.height;
        float timelineBottom = self.panRecognizer.view.frame.origin.y + self.timeline.view.frame.size.height;
        self.panDistance = sqrt((bottom - timelineBottom) * (bottom - timelineBottom));

        if(timelineBottom > bottom) self.panDirection = kDirectionRight;
        else if (timelineBottom < bottom) self.panDirection = kDirectionLeft;
        else self.panDirection = kDirectionNone;

   		if(self.panDistance > self.timeline.view.frame.size.height) {
            [self showMap];
        }
    }
    if(panRecognizer.state == UIGestureRecognizerStateEnded) {
		if(self.panDistance <= self.timeline.view.frame.size.height * 2) {
			[UIView animateWithDuration:0.4 animations:^{
			    [self.timeline.view moveTo:CGPointMake(0, [OrientationUtils nativeLandscapeDeviceSize].size.height - self.timeline.view.frame.size.height)];
            } completion:nil];
        }
    }
}

- (void)showMap {
    [self.timeline.view removeGestureRecognizer:self.panRecognizer];
    
    UIImageView *playerScreenshot = [[UIImageView alloc] initWithImage:[[MotionVideoPlayer sharedInstance] getBlurredScreenshot]];
    playerScreenshot.alpha = 0;
    [self.view addSubview:playerScreenshot];

    UIImageView *map = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map.png"]];
    [self.view addSubview:map];
	[map moveTo:CGPointMake(0, [OrientationUtils nativeLandscapeDeviceSize].size.height)];

	[UIView animateWithDuration:0.8 animations:^{
        [self.timeline.view moveTo:CGPointMake(0, [OrientationUtils nativeLandscapeDeviceSize].size.height / 2)];
      	[map moveTo:CGPointMake(0, [OrientationUtils nativeLandscapeDeviceSize].size.height - map.frame.size.height)];
        self.timeline.view.alpha = 0;
        playerScreenshot.alpha = 1;
    } completion:^(BOOL finished) {
        [self stop];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showSceneChooser" object:nil];
    }];
}

- (void)initTitle:(NSString *)title {
    float topPosition = [OrientationUtils nativeLandscapeDeviceSize].size.height / 2 - self.sceneTitle.frame.size.height / 2 - 50;
    self.sceneTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200.0, 40.0)];
    self.sceneTitle.text = [title uppercaseString];
    [self.sceneTitle setTextAlignment:NSTextAlignmentCenter];
    self.sceneTitle.textColor = [UIColor textColor];
    self.sceneTitle.font = [UIFont fontWithName:@"BrandonGrotesque-Bold" size:15.0];
    
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
    float currentTime = CMTimeGetSeconds(self.player.currentTime);
    int currentFrame = self.playerView.frameRate * currentTime;
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
