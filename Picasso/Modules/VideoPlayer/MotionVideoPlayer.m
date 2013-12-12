//
//  MotionVideoPlayer.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//
// MotionVideoPlayer is a wrapper for an AVPlayer with its playback rate controlled by the CMMotionManager pitch.

#import "MotionVideoPlayer.h"
#import "Events.h"
#import "OrientationUtils.h"
#import "DataManager.h"
#import "UIImage+ImageEffects.h"
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>

@interface MotionVideoPlayer ()

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (assign, nonatomic) BOOL motionEnabled;
@property (assign, nonatomic) BOOL playbackCompleted;
@property (assign, nonatomic) double lastPitch;

@property (assign, nonatomic) NSInteger observedTime;
@property (strong, nonatomic) id updateListener;

@end

@implementation MotionVideoPlayer

+ (id)sharedInstance {
    static MotionVideoPlayer *sharedInstance = nil;
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc] init];

    }
    return sharedInstance;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

// Addind call to initMotionManager to default init methods.
- (id)init {
    if(self = [super init]) {
        self.playbackCompleted = NO;
        self.motionEnabled = NO;
        [self initPlayer];
        [self initMotionManager];
    }
    return self;
}

- (void)initPlayer {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    self.player = [AVPlayer playerWithURL:url];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    layer.frame = [OrientationUtils nativeDeviceSize];
    [self.view.layer addSublayer:layer];

    self.frameRate = [self getPlayerFrameRate];
}

- (void)showMenuVideo {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [self loadURL:url];
//    [self.player seekToTime:CMTimeMakeWithSeconds(20, 1.0)];
    [self.player seekToTime:CMTimeMakeWithSeconds(20, 1.0) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)rotatePlayerToLandscape {
    AVPlayerLayer *layer = [self.view.layer.sublayers objectAtIndex:0];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.view.frame = layer.frame = [OrientationUtils nativeLandscapeDeviceSize];
    [CATransaction commit];
}

- (void)rotatePlayerToPortrait {
    AVPlayerLayer *layer = [self.view.layer.sublayers objectAtIndex:0];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.view.frame = layer.frame = [OrientationUtils nativeDeviceSize];
    [CATransaction commit];
}

- (void)initMotionManager {
    self.motionManager = [[CMMotionManager alloc] init];
}

- (void)loadURL:(NSURL *)url {
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:item];
    self.frameRate = [self getPlayerFrameRate];

    // DEBUG
    self.player.rate = 1.0;
}

#pragma Transitions methods
- (void)fadeIn {
    [UIView animateWithDuration:0.6 animations:^{
        self.view.alpha = 1;
    }];
}

- (void)fadeOut {
    [UIView animateWithDuration:0.6 animations:^{
        self.view.alpha = 0;
    }];
}

#pragma Time related methods
- (void)startToListenForUpdatesWithTime:(NSTimeInterval)time {
    self.observedTime = time;
    self.updateListener = [self listenForPlayerUpdates];
}

- (void)stopListeningForUpdates {
    [self.player removeTimeObserver:self.updateListener];
}

- (id)listenForPlayerUpdates {
    __weak typeof(self) weakSelf = self;
    return [self.player addPeriodicTimeObserverForInterval:CMTimeMake(33, 1000) queue:NULL usingBlock:^(CMTime time) {
        [weakSelf listenForVideoUpdate];
    }];
}

- (void)listenForVideoUpdate {
    if(CMTimeGetSeconds(self.player.currentTime) >= self.observedTime) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[MPPEvents PlayerObservedTimeEvent] object:nil];
    }
}

#pragma  Motion related methods
- (void)enableMotion {
    if(self.motionEnabled) return;
    if (self.motionManager.deviceMotionAvailable ) {
        self.motionManager.deviceMotionUpdateInterval = 1.0/30.0;
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            	[self updatePlayerWithMotion:motion];
        	}
         ];
	        self.motionEnabled = YES;
    }
    else {
        NSLog(@"[MotionVideoPlayer] Motion data not available :'(. Playing the video at rate of 1.0.");
        self.player.rate = 1.0;
    }
}

- (void)disableMotion {
	[self.motionManager stopDeviceMotionUpdates];
    self.motionEnabled = NO;
}


- (void)updatePlayerWithMotion:(CMDeviceMotion *)motion {
    double playerRate = [self getNormalizedPlayerRateWithPitch: motion.attitude.pitch];

    if(playerRate < 0 && CMTimeGetSeconds(self.player.currentItem.currentTime) <= 0) {
        self.player.rate = 0;
    }
    else {
        self.player.rate = playerRate;
    }
    
    [self.delegate motionDidChange];
}

// This method mirrors the device motion to the player rate, normalized to [-2, 2]
- (double)getNormalizedPlayerRateWithPitch:(double)pitch {
    double playerRate = fmin(0.5, fmax(-0.5, pitch)) * 4;

    self.pitch = playerRate + (playerRate - self.lastPitch) * 0.1;
    self.lastPitch = self.pitch;

    if(playerRate < 0.2 && playerRate > -0.2) playerRate = 0;

	return playerRate;
}

/*- (double)getNormalizedPlayerRateWithAttitude:(CMAttitude *)attitude {
    CMQuaternion quat = attitude.quaternion;
    double playerRate = asin(2 * (quat.x * quat.z - quat.w * quat.y));
    
    if (self.lastPitch == 0) {
        self.lastPitch = playerRate;
    }
    
    // kalman filtering
    static float q = 0.1;   // process noise
    static float r = 0.1;   // sensor noise
    static float p = 0.1;   // estimated error
    static float k = 0.5;   // kalman filter gain
    
    float x = self.lastPitch;
    p = p + q;
    k = p / (p + r);
    x = x + k*( playerRate - x);
    p = (1 - k) * p;
    self.lastPitch = x;
    
    return playerRate;
}*/

- (UIImage *)getScreenshot {
	AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:self.player.currentItem.asset];
    CGImageRef thumb = [imageGenerator copyCGImageAtTime:CMTimeMakeWithSeconds(10.0, 1.0) actualTime:NULL error:NULL];
    UIImage *screenShot = [UIImage imageWithCGImage:thumb];
    CGImageRelease(thumb);
    return screenShot;
}

- (UIImage *)getBlurredScreenshot {
	return [[self getScreenshot] applySubtleEffect];
}

-(float)getPlayerFrameRate {
    AVAssetTrack *track = [[self.player.currentItem.asset tracksWithMediaType:AVMediaTypeVideo] lastObject];
    return track.nominalFrameRate;
}

@end
