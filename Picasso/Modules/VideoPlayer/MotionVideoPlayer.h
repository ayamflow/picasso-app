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

@interface MotionVideoPlayer : UIViewController

@property (strong, nonatomic) AVPlayer *player;
@property (assign, nonatomic) float frameRate;

+ (id)sharedInstance;
- (void)enableMotion;
- (void)disableMotion;
- (void)loadURL:(NSURL *)url;
- (UIImage *)getScreenshot;
- (UIImage *)getBlurredScreenshot;

@end
