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

@interface MotionVideoPlayer : AVPlayer
@property (strong, nonatomic) CMMotionManager *motionManager;
@end
