//
//  SceneViewController.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Scene.h"
#import "SceneModel.h"
#import "TrackerModel.h"
#import "OrientationUtils.h"

#define PLAYBACK_PERCENT_BEFORE_FADE 0.90

@interface Scene ()

@property (strong, nonatomic) id playerUpdatesObserver;
@property (assign, nonatomic) float frameRate;
@property (assign, nonatomic) float completion;

@end

@implementation Scene

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (id)initWithModel:(SceneModel *)sceneModel {
    if(self = [super init]) {
        self.model = sceneModel;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:self.model.sceneId ofType:self.model.videoType];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        [self initPlayerWithURL:url];
        
        NSLog(@"[Scene #%i] Started", self.model.number);
    }
    return self;
}

- (id)initWithModel:(SceneModel *)sceneModel andPosition:(CGPoint)position {
//    NSLog(@"Init scene with position %f:%f", position.x, position.y);
    if(self = [self initWithModel:sceneModel]) {
        CGRect frame = self.view.frame;
        frame.origin = position;
        self.view.frame = frame;
    }
    
    return self;
}

- (void)initPlayerWithURL:(NSURL *)URL {
    self.player = [MotionVideoPlayer playerWithURL:URL];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    // Make sure the player takes the whole screen
    CGRect screenSize = [OrientationUtils deviceSize];
    layer.frame = CGRectMake(0, 0, screenSize.size.width, screenSize.size.height);
    [self.view.layer addSublayer:layer];
    
    self.frameRate = [self getPlayerFrameRate];
    self.completion = 0.0f;
    [self initTrackers];
    self.playerUpdatesObserver = [self listenForPlayerUpdates];
    
    NSLog(@"[Scene #%i] frameRate = %f", self.model.number, self.frameRate);
    
    // DEBUG
    self.player.rate = 2.0;
    self.player.volume = 0.0f;
    [self.player seekToTime:CMTimeMake(28, 1)];
}

- (void)initTrackers {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"tracker-button" ofType: @"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    
    int number = [self.model.trackers count];
    NSMutableArray *trackersArray = [[NSMutableArray alloc]initWithCapacity:number];
    
    for(int i = 0; i < number; i++) {
        [trackersArray addObject:[self createTrackerWithImage:image]];
        [self.view addSubview:[trackersArray objectAtIndex:i]];
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
//    CGRect trackerFrame = tracker.frame;
//    trackerFrame.origin = CGPointMake(250, 250);
//    tracker.autoresizingMask = UIViewAutoresizingNone;
//    tracker.frame = trackerFrame;
    return tracker;
}

// Frame-based methods

- (id)listenForPlayerUpdates {
    __weak typeof(self) weakSelf = self;
    return [self.player addPeriodicTimeObserverForInterval:CMTimeMake(33, 1000) queue:NULL usingBlock:^(CMTime time) {
        [weakSelf listenForVideoEnded]; // Watch video status
        [weakSelf toggleTrackers]; // Show/hide/move trackers
    }];
}

- (void)listenForVideoEnded {
    self.completion = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.asset.duration);
    if(self.completion > PLAYBACK_PERCENT_BEFORE_FADE) {
        // fade to black proportionaly
        self.view.alpha = 1.0 - (self.completion - PLAYBACK_PERCENT_BEFORE_FADE) * 5; // -10% opacity * factor
    }
    if(self.completion > 1.0) {
        [self playerItemDidReachEnd];
    }
}

- (void)toggleTrackers {
    float currentTime = CMTimeGetSeconds(self.player.currentTime);
    int currentFrame = self.frameRate * currentTime;
    
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
                int x = [[[currentTrackerPositions objectAtIndex:j] objectAtIndex:1] integerValue];
                int y = [[[currentTrackerPositions objectAtIndex:j] objectAtIndex:2] integerValue];
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

-(float)getPlayerFrameRate {
    AVAssetTrack *track = [[self.player.currentItem.asset tracksWithMediaType:AVMediaTypeVideo] lastObject];
    return track.nominalFrameRate;
}

- (void)playerItemDidReachEnd{
    NSLog(@"[Scene #%i] Ended", self.model.number);
    [self stop];
    [self.delegate showInterstitial];
}

- (void)stop {
    self.player.rate = 0.0;
    [self.player removeTimeObserver:self.playerUpdatesObserver];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
