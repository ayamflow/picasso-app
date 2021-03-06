//
//  MotionVideoPlayer.h
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//
// MotionVideoPlayer is a wrapper for an AVPlayer with its playback rate controlled by the CMMotionManager pitch.

#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import "MotionVideoPlayerDelegate.h"

@interface MotionVideoPlayer : UIViewController

@property (strong, nonatomic) AVPlayer *player;
@property (assign, nonatomic) float frameRate;
@property (assign, nonatomic) CGFloat pitch;
@property (weak, nonatomic) id<MotionVideoPlayerDelegate> delegate;

+ (id)sharedInstance;
- (void)enableMotion;
- (void)disableMotion;
- (void)loadURL:(NSURL *)url;
- (void)showMenuVideo;
- (UIImage *)getScreenshot;
- (UIImage *)getBlurredScreenshot;
- (void)startToListenForUpdatesWithTime:(NSTimeInterval)time;
- (void)stopListeningForUpdates;
- (void)fadeIn;
- (void)fadeOut;
- (void)rotatePlayerToLandscape;
- (void)rotatePlayerToPortrait;

@end
