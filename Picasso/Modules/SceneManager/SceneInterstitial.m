//
//  SceneInterstitialViewController.m
//  Picasso
//
//  Created by MOREL Florian on 29/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "SceneInterstitial.h"

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
        self.description = description;
        
        [self initText];
        [self initButtons];
        [self initSlider];
    }
    return self;
}

- (void)initSlider {
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    
    self.slidingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.slidingButton setBackgroundColor:[UIColor blueColor]];
    [self.slidingButton setTitle:@"\\/" forState:UIControlStateNormal];
    [self.slidingButton setFrame:CGRectMake(screenSize.size.width - 10, screenSize.size.height / 2, 30, 30)];
    [self.view addSubview: self.slidingButton];
}

- (void)initText {
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 10, screenSize.size.width - 60, screenSize.size.height - 60) textContainer:nil];
    [self.textView setText:self.description];
    self.textView.scrollEnabled = YES;
    [self.textView setEditable:NO];
    [self.textView setBackgroundColor:[UIColor clearColor]];
    [self.textView setTextColor:[UIColor whiteColor]];
    [self.view addSubview:self.textView];
}

- (void)initButtons {
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    // Share
    self.shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.shareButton setBackgroundColor:[UIColor yellowColor]];
    [self.shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [self.shareButton setFrame:CGRectMake(15, screenSize.size.height - 30, screenSize.size.width / 3, 30)];
    [self.view addSubview:self.shareButton];
    
    // Retry
    self.retryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.retryButton setBackgroundColor:[UIColor yellowColor]];
    [self.retryButton setTitle:@"Retry" forState:UIControlStateNormal];
    [self.retryButton setFrame:CGRectMake(screenSize.size.width - self.shareButton.frame.size.width - 15, screenSize.size.height - 30, screenSize.size.width / 3, 30)];
    [self.view addSubview:self.retryButton];
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
