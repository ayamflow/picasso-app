//
//  MotionVideoPlayer.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//
// MotionVideoPlayer is a wrapper for an AVPlayer with its playback rate controlled by the CMMotionManager pitch.

#import "MotionVideoPlayer.h"
#import <CoreMotion/CoreMotion.h>

@implementation MotionVideoPlayer

// Addind call to initMotionManager to default init methods.
- (id)init {
    [self initMotionManager];
    return [super init];
}

- (id)initWithPlayerItem:(AVPlayerItem *)item {
    [self initMotionManager];
    return [super initWithPlayerItem:item];
}

- (id)initWithURL:(NSURL *)URL {
    [self initMotionManager];
    return [super initWithURL:URL];
}

- (void)initMotionManager {
    self.motionManager = [[CMMotionManager alloc] init];
    
    if (self.motionManager.deviceMotionAvailable ) {
        self.motionManager.deviceMotionUpdateInterval = 1.0/30.0;
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            [self updatePlayerWithMotion:motion];
        }
         ];
    }
    else {
        NSLog(@"Motion data not available :'(");
    }
}

- (void)updatePlayerWithMotion:(CMDeviceMotion *)motion {
    double playerRate = motion.attitude.pitch;
    
    // Normalizes it in [-2, 2]
    playerRate = fmin(0.5, fmax(-0.5, playerRate)) * 4;
    // Stabilizes playback around 0
    if(playerRate < 0.2 && playerRate > -0.2) playerRate = 0;
    
//    NSLog(@"Pitch: %f", playerRate);
    self.rate = playerRate;
}

@end
