//
//  VideoPlayerView.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "VideoPlayerView.h"
#import "MotionVideoPlayer.h"

@implementation VideoPlayerView

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)loadVideoWithURL:(NSURL *)url {
    self.player = [MotionVideoPlayer playerWithURL:url];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    // Make sure the player takes the whole screen
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    NSLog(@"Video player size: %f/%f", screenSize.size.width, screenSize.size.height);
    layer.frame = CGRectMake(0, 0, screenSize.size.width, screenSize.size.height);
    [self.view.layer addSublayer:layer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
