//
//  SceneInterstitialViewController.m
//  Picasso
//
//  Created by MOREL Florian on 29/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "SceneInterstitial.h"
#import "OrientationUtils.h"
#import "DataManager.h"

#define MARGIN 15

@interface SceneInterstitial ()

@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UIButton *retryButton;

@end

@implementation SceneInterstitial

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDescription:(NSString *)description {
    if(self = [super init]) {
        [self.view setFrame:[OrientationUtils deviceSize]];
        self.description = description;

		DataManager *dataManager = [DataManager sharedInstance];
        int currentSceneId = [[dataManager getGameModel] currentScene];

        if(currentSceneId < [dataManager getScenesNumber] - 1) {
	    	[[dataManager getSceneWithNumber:currentSceneId + 1] unlockScene];
        }

        [self initText];
        [self initButtons];
        [self initSlider];
    }
    return self;
}

- (void)initText {
    CGRect screenSize = [OrientationUtils deviceSize];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, screenSize.size.width - MARGIN * 5, screenSize.size.height - MARGIN * 5) textContainer:nil];
    [self.textView setText:self.description];
    self.textView.scrollEnabled = YES;
    [self.textView setEditable:NO];
    [self.textView setBackgroundColor:[UIColor clearColor]];
    [self.textView setTextColor:[UIColor whiteColor]];
    [self.view addSubview:self.textView];
}

- (void)initButtons {
    CGRect screenSize = [OrientationUtils deviceSize];
    // Share
    self.shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.shareButton setBackgroundColor:[UIColor yellowColor]];
    [self.shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [self.shareButton setFrame:CGRectMake(15, screenSize.size.height - MARGIN * 3, screenSize.size.width / 3, MARGIN * 2)];
    [self.view addSubview:self.shareButton];
    
    // Retry
    self.retryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.retryButton setBackgroundColor:[UIColor yellowColor]];
    [self.retryButton setTitle:@"Retry" forState:UIControlStateNormal];
    [self.retryButton setFrame:CGRectMake(screenSize.size.width - self.shareButton.frame.size.width - MARGIN, screenSize.size.height - MARGIN * 3, screenSize.size.width / 3, MARGIN * 2)];
    [self.view addSubview:self.retryButton];
}

- (void)initSlider {
    CGRect screenSize = [OrientationUtils deviceSize];
    
    self.slidingButton = [[SceneSlider alloc] initWithFrame:CGRectMake(screenSize.size.width - MARGIN * 3, MARGIN * 3, MARGIN * 2, screenSize.size.height - MARGIN * 5) andAmplitude:screenSize.size.height /2 + MARGIN * 2 andThreshold:0.7];
    [self.view addSubview:self.slidingButton.view];
    NSLog(@"slider frame: %fx%f", self.slidingButton.view.frame.size.width, self.slidingButton.view.frame.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
