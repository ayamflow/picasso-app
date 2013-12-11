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
#import "LineDrawView.h"
#import "SceneMenu.h"
#import "SceneManagerDelegate.h"
#import "NavigationBarView.h"

#define kPlaybackFadePercent 0.90

#define kSliderHeight 80
#define kSliderVisibleHeight 10

#define kTrackerGap 45

@interface Scene ()

@property (weak, nonatomic) MotionVideoPlayer *playerView;
@property (weak, nonatomic) AVPlayer *player;
@property (assign, nonatomic) float completion;
@property (strong, nonatomic) id playerUpdatesObserver;
@property (assign, nonatomic) BOOL hasEnded;

@property (strong, nonatomic) UILabel *sceneTitle;
@property (strong, nonatomic) UILabel *dateTitle;
@property (strong, nonatomic) UIImageView *dateImageView;

@property (strong, nonatomic) NavigationBarView *navigationBar;
@property (strong, nonatomic) SceneTimeline *timeline;
@property (strong, nonatomic) UIPanGestureRecognizer *panRecognizer;
@property (assign, nonatomic) BOOL menuIsOpen;

@property (strong, nonatomic) SceneMenu *menu;

@property (assign, nonatomic) NSInteger transitionsDone;
@property (assign, nonatomic) NSInteger transitionsNumber;

@property (strong, nonatomic) NSArray *trackerStarts;
@property (strong, nonatomic) NSArray *trackerEnds;

@property (strong, nonatomic) LineDrawView *drawView;
@property (assign, nonatomic) CGFloat trackerInertiaX;
@property (assign, nonatomic) CGFloat trackerInertiaY;

@end

@implementation Scene

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor clearColor];

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

    [self initNavigationBar];
    [self initTimeline];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self transitionIn];

//    NSLog(@"[Scene #%li] Started", (long)self.model.number);
    [self resume]; // seekToTime + enableMotion
}

- (id)initWithModel:(SceneModel *)sceneModel {
    if(self = [super init]) {
        self.model = sceneModel;
    }
    return self;
}

- (void)initNavigationBar {
    self.navigationBar = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeLandscapeDeviceSize].size.width, 50) andTitle:self.model.title andShowExploreButton:YES];
    self.navigationBar.titleLabel.hidden = YES;
    [self.navigationBar.exploreButton setImage:[UIImage imageNamed:@"menuPause.png"] forState:UIControlStateNormal];
    self.navigationBar.backButton.hidden = YES;
    self.navigationBar.backButton.enabled = NO;
    [self.view addSubview:self.navigationBar];

    [self.navigationBar.exploreButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMenu) name:[MPPEvents MenuExitEvent] object:nil];
}

- (void)initTimeline {
    self.timeline = [[SceneTimeline alloc] initWithModel:self.model];
    [self.view addSubview:self.timeline.view];
    [self.timeline.view moveTo:CGPointMake(0, [OrientationUtils nativeLandscapeDeviceSize].size.height - self.timeline.view.frame.size.height)];
}

- (void)showMenu {
    if(self.menuIsOpen) return;
    self.menuIsOpen = YES;
    
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
    [UIView animateWithDuration:0.4 animations:^{
        [self.menu.view moveTo:CGPointMake(0, - self.menu.view.frame.size.height)];
        [self.timeline.view moveTo:CGPointMake(0, [OrientationUtils nativeLandscapeDeviceSize].size.height - self.timeline.view.frame.size.height)];
    } completion:^(BOOL finished) {
        [self.menu removeFromParentViewController];
        [self.menu.view removeFromSuperview];
        self.menu = nil;
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
    UIImage *image = [UIImage imageNamed:@"tracker.png"];
    
    self.drawView = [[LineDrawView alloc] initWithFrame:[OrientationUtils nativeLandscapeDeviceSize]];
    self.drawView.endPoint = CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width, 80);
    [self.view addSubview:self.drawView];
    self.drawView.backgroundColor = [UIColor clearColor];
    [self.view sendSubviewToBack:self.drawView];
    self.drawView.hidden = YES;
    
    NSUInteger trackerNumber = [self.model.trackers count];
    NSMutableArray *trackersArray = [NSMutableArray arrayWithCapacity:trackerNumber];
    NSMutableArray *trackerStarts = [NSMutableArray arrayWithCapacity:trackerNumber];
    NSMutableArray *trackerEnds = [NSMutableArray arrayWithCapacity:trackerNumber];
    
    for(int i = 0; i < trackerNumber; i++) {
        NSArray *positions = [[self.model.trackers objectAtIndex:i] positions];
        NSInteger startTime = [[[positions objectAtIndex: 0] objectAtIndex:0] integerValue];
        NSInteger endTime = [[[positions objectAtIndex: [positions count] - 1] objectAtIndex:0] integerValue];
        [trackerStarts addObject:[NSNumber numberWithInteger:startTime]];
        [trackerEnds addObject:[NSNumber numberWithInteger:endTime]];

        UIButton *tracker = [self createTrackerWithImage:image];
        TrackerModel *trackerModel = [self.model.trackers objectAtIndex:i];
        tracker.tag = trackerModel.workId;
        [trackersArray addObject:tracker];
        [tracker addTarget:self action:@selector(trackerTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tracker];
    }
    
    self.trackerStarts = [NSArray arrayWithArray:trackerStarts];
    self.trackerEnds = [NSArray arrayWithArray:trackerEnds];
    self.trackersImage = [NSArray arrayWithArray:trackersArray];
}

- (UIButton *)createTrackerWithImage:(UIImage *)image {
    UIButton *tracker = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [tracker setBackgroundImage:image forState:UIControlStateNormal];
    // Hidden by default
    [tracker setHidden:YES];
    [tracker setEnabled:NO];
    // DEBUG
    tracker.frame = CGRectMake(250, 250, 35, 35);
    return tracker;
}

- (void)trackerTouched:(id)sender {
//    NSLog(@"[Scene #%li] Touched tracker with workId %li", self.model.number, [sender tag]);
    /*    [self stop];
     WorkViewController *workView = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"WorkViewController"];
     workView.workId = [sender tag];
     [self.parentViewController.navigationController presentViewController:workView animated:NO completion:nil];*/
}

- (void)motionDidChange {
    [self listenForVideoEnded]; // Watch video status
    [self toggleTrackers]; // Show/hide/move trackers
}

- (void)listenForVideoEnded {
    self.completion = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.asset.duration);
    if(!self.hasEnded) {
        [self.timeline updateWithCompletion:self.completion];
	    if(self.completion > kPlaybackFadePercent) {
    	    // fade to white proportionaly
    	    self.view.alpha = 1.0 - (self.completion - kPlaybackFadePercent) * 10; // -10% opacity * factor
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
    
    for(int i = 0; i < [self.model.trackers count]; i++) {
        UIButton *currentTracker = [self.trackersImage objectAtIndex:i];
        
        if(currentFrame > [[self.trackerStarts objectAtIndex:i] integerValue]
           && currentFrame < [[self.trackerEnds objectAtIndex:i] integerValue] &&
           !currentTracker.enabled) {
            currentTracker.enabled = YES;
            currentTracker.hidden = NO;
            [[DataManager sharedInstance] unlockWorkWithNumber:[[self.model.trackers objectAtIndex:i] workId]];
            self.drawView.hidden = NO;
            self.trackerInertiaX = 0;
            self.trackerInertiaY = 0;
        }
        else if(currentTracker.enabled && (currentFrame < [[self.trackerStarts objectAtIndex:i] integerValue] || currentFrame > [[self.trackerEnds objectAtIndex:i] integerValue])) {
            currentTracker.enabled = NO;
            currentTracker.hidden = YES;
            self.drawView.hidden = YES;
        }

        if(currentTracker.enabled) {
            self.trackerInertiaX += 0.03;
            self.trackerInertiaY += 0.07;
            NSArray *currentTrackerPositions = [[self.model.trackers objectAtIndex:i] positions];
            NSArray *currentPosition = [currentTrackerPositions objectAtIndex:currentFrame - [[self.trackerStarts objectAtIndex: i] integerValue]];
            
            CGFloat x = [[currentPosition objectAtIndex:1] floatValue];
            CGFloat y = [[currentPosition objectAtIndex:2] floatValue];
            
            self.drawView.startPoint = CGPointMake(x, y);

            CGFloat trackerX = self.drawView.startPoint.x + (kTrackerGap * self.playerView.pitch);

//            self.drawView.endPoint = CGPointMake(trackerX * 0.97 + currentTracker.bounds.size.width * cosf(self.trackerInertiaX) * 0.01, self.drawView.endPoint.y + currentTracker.bounds.size.height * sinf(self.trackerInertiaY) * 0.01);
            self.drawView.endPoint = CGPointMake(trackerX + (trackerX - self.drawView.endPoint.x) * 0.1, self.drawView.endPoint.y + currentTracker.bounds.size.height * sinf(self.trackerInertiaY) * 0.01);

            currentTracker.center = self.drawView.endPoint;
            [self.drawView setNeedsDisplay];
        }
    }
}

- (void)playerItemDidReachEnd{
//    NSLog(@"[Scene #%li] Ended", (long)self.model.number);
    [self stop];
    [self.delegate showInterstitial];
}

- (void)stop {
//    NSLog(@"[Scene #%li] Stopped.", self.model.number);
    GameModel *gameModel = [[DataManager sharedInstance] getGameModel];
    gameModel.sceneCurrentTime = CMTimeGetSeconds(self.player.currentTime);
    self.player.rate = 0.0;
    [self.playerView disableMotion];
    self.playerView.delegate = nil;
    self.player = nil;
}

- (void)resume {
//    NSLog(@"[Scene #%li] Resume.", self.model.number);
    self.playerView.delegate = self;
    [self.playerView enableMotion];
    self.player = self.playerView.player;
    [self.player seekToTime:CMTimeMakeWithSeconds([[[DataManager sharedInstance] getGameModel] sceneCurrentTime], self.player.currentItem.asset.duration.timescale)];
}

@end