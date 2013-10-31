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
    if(self = [super init]) {
        self.playbackCompleted = NO;
        [self initMotionManager];
    }
    return self;
}

- (id)initWithPlayerItem:(AVPlayerItem *)item {
    if(self = [super initWithPlayerItem:item]) {
        self.playbackCompleted = NO;
        [self initMotionManager];
    }
    return self;
}

- (id)initWithURL:(NSURL *)URL {
    if(self = [super initWithURL:URL]) {
        self.playbackCompleted = NO;
        [self initMotionManager];
    }
    return self;
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
        NSLog(@"[MotionVideoPlayer] Motion data not available :'(");
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
//    NSLog(@"rate: %i, time: %f, duration: %f", self.rate, CMTimeGetSeconds(self.currentTime), CMTimeGetSeconds(self.currentItem.asset.duration));
    if(CMTimeCompare(self.currentTime, self.currentItem.asset.duration) == 0) {
        NSLog(@"[MotionVideoPlayer] Completed !");
        self.playbackCompleted = YES;
    }
}

@end
