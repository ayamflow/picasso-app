//
//  SceneViewController.m
//  Picasso
//
//  Created by MOREL Florian on 28/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Scene.h"
#import "SceneModel.h"

@interface Scene ()

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
    self.model = sceneModel;

    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.model.sceneId ofType:self.model.videoType];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [self initPlayerWithURL:url];
    
    NSLog(@"[Scene] Started scene #%i.", self.model.number);
    
    return [self init];
}

- (void)initPlayerWithURL:(NSURL *)URL {
    self.player = [MotionVideoPlayer playerWithURL:URL];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;

    // Make sure the player takes the whole screen
    CGRect screenSize = [[UIScreen mainScreen] bounds];
//    NSLog(@"Screen size is %lfx%lf", screenSize.size.width, screenSize.size.height);
    layer.frame = CGRectMake(0, 0, screenSize.size.width, screenSize.size.height);
    [self.view.layer addSublayer:layer];
    
    // DEBUG
    self.player.rate = 1.0;
}

- (void)playerItemDidReachEnd:(NSNotification *) notification {
    NSLog(@"video end");
    [self.delegate showNextScene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
