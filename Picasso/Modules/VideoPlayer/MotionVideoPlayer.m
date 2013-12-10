//
//  MotionVideoPlayer.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//
// MotionVideoPlayer is a wrapper for an AVPlayer with its playback rate controlled by the CMMotionManager pitch.

#import "MotionVideoPlayer.h"
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

@end

@implementation MotionVideoPlayer

static BOOL initialized;

+ (id)sharedInstance {
    static MotionVideoPlayer *sharedInstance = nil;
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc] init];
//            [sharedInstance updateViewControllerRotation];

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
        [self initMotionManager];
    }
    return self;
}

- (id)initWithURL:(NSURL *)URL {
    if(self = [super init]) {
        self.playbackCompleted = NO;
        self.motionEnabled = NO;

        [self initPlayer];
        [self initMotionManager];
    }
    return self;
}

- (void)initPlayer {
    // Automatically starts with the current scene (previously set on the according button touch)
//    SceneModel *currentScene = [[DataManager sharedInstance] getCurrentSceneModel];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:currentScene.sceneId ofType:currentScene.videoType];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    self.player = [AVPlayer playerWithURL:url];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    // Make sure the player takes the whole screen in landscape mode
    CGRect screenSize = [OrientationUtils nativeLandscapeDeviceSize];
    layer.frame = CGRectMake(0, 0, screenSize.size.width, screenSize.size.height);
    [self.view.layer addSublayer:layer];
    
    self.frameRate = [self getPlayerFrameRate];
}

- (void)initPlayerWithURL:(NSURL *)URL {
    self.player = [AVPlayer playerWithURL:URL];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    // Make sure the player takes the whole screen in landscape mode
    CGRect screenSize = [OrientationUtils nativeLandscapeDeviceSize];
    layer.frame = CGRectMake(0, 0, screenSize.size.width, screenSize.size.height);
    [self.view.layer addSublayer:layer];

    self.frameRate = [self getPlayerFrameRate];
}

- (void)initMotionManager {
    self.motionManager = [[CMMotionManager alloc] init];
}

- (void)loadURL:(NSURL *)url {
	if(!initialized) {
		[self initPlayerWithURL:url];
        initialized = YES;
    }
    else {
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
        [self.player replaceCurrentItemWithPlayerItem:item];
        self.frameRate = [self getPlayerFrameRate];
    }
}

// Motion methods

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
        NSLog(@"[MotionVideoPlayer] Motion data not available :'(");
    }
}

- (void)disableMotion {
	[self.motionManager stopDeviceMotionUpdates];
    self.motionEnabled = NO;
}


- (void)updatePlayerWithMotion:(CMDeviceMotion *)motion {
//    double playerRate = [self getNormalizedPlayerRateWithPitch: motion.attitude.pitch];
    double playerRate = [self getNormalizedPlayerRateWithAttitude: motion.attitude];
    self.player.rate = playerRate;
    
    [self.delegate motionDidChange];
}

// This method mirrors the device motion to the player rate, normalized to [-2, 2]
/*- (double)getNormalizedPlayerRateWithPitch:(double)pitch {
    double playerRate = fmin(0.5, fmax(-0.5, pitch)) * 4;
    // Stabilizes playback around 0
    self.pitch = playerRate;
    if(playerRate < 0.2 && playerRate > -0.2) playerRate = 0;

	return playerRate;
}*/

- (double)getNormalizedPlayerRateWithAttitude:(CMAttitude *)attitude {
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
}

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
