//
//  SceneViewController.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "SceneViewController.h"

@interface SceneViewController ()

@end

@implementation SceneViewController

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

- (void)initPlayerWithURL:(NSURL *)URL {
    self.player = [MotionVideoPlayer playerWithURL:URL];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    // Make sure the player takes the whole screen
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    NSLog(@"Screen size is %fx%f", screenSize.size.width, screenSize.size.height);
    layer.frame = CGRectMake(0, 0, screenSize.size.width, screenSize.size.height);
    [self.view.layer addSublayer:layer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
