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
#import "Events.h"
#import "Colors.h"
#import "UIViewPicasso.h"
#import "SceneModel.h"

#define MARGIN 15

@interface SceneInterstitial ()

@property (strong, nonatomic) SceneModel *sceneModel;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UILabel *sceneTitle;
@property (strong, nonatomic) UILabel *dateTitle;
@property (strong, nonatomic) UIView *sliderZone;

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

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (id)initWithModel:(SceneModel *)sceneModel {
    if(self = [super init]) {
        self.sceneModel = sceneModel;
    }
    return self;
}

- (void)unlockNextScene {
    DataManager *dataManager = [DataManager sharedInstance];
    NSInteger currentSceneId = [[dataManager getGameModel] currentScene];

    if(currentSceneId < [dataManager getScenesNumber] - 1) {
        [[dataManager getSceneWithNumber:currentSceneId + 1] unlockScene];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [OrientationUtils nativeLandscapeDeviceSize];

    [self unlockNextScene];

    [self initOverlay];

    [self initTitle];
    [self initDate];
    [self initText];
    [self initSlider];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.view.alpha = 0;
    [UIView animateWithDuration:0.6 animations:^{
        self.view.alpha = 1;
    }];
}


- (void)initOverlay {
    UIView *overlay = [[UIView alloc] initWithFrame:[OrientationUtils nativeLandscapeDeviceSize]];
    overlay.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    [self.view addSubview:overlay];
}

- (void)initTitle {
    self.sceneTitle = [[UILabel alloc] initWithFrame:CGRectMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - 100.0, 50.0, 200.0, 40.0)];
    self.sceneTitle.text = [self.sceneModel.title uppercaseString];
    [self.sceneTitle setTextAlignment:NSTextAlignmentCenter];
    self.sceneTitle.textColor = [UIColor blackColor];
    self.sceneTitle.font = [UIFont fontWithName:@"BrandonGrotesque-Medium" size:15.0];

    self.sceneTitle.layer.borderColor = [UIColor blackColor].CGColor;
    self.sceneTitle.layer.borderWidth = 2.0;

    [self.view addSubview:self.sceneTitle];
}

- (void)initDate {
    self.dateTitle = [[UILabel alloc] initWithFrame:CGRectMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - 50.0, 90.0, 100.0, 45.0)];
    self.dateTitle.text = [self.sceneModel.date stringByReplacingOccurrencesOfString:@"-" withString:@"    "];
    self.dateTitle.textColor = [UIColor blackColor];
    [self.dateTitle setTextAlignment:NSTextAlignmentCenter];
    self.dateTitle.font = [UIFont fontWithName:@"BrandonGrotesque-Regular" size:12.0];
    [self.view addSubview:self.dateTitle];

	UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dateSeparator.png"]];
    [self.view addSubview:separator];
    separator.center = self.dateTitle.center;
}

- (void)initText {
    CGRect screenSize = [OrientationUtils nativeLandscapeDeviceSize];

    CGFloat textWidth = screenSize.size.width * 0.45;
    CGFloat leftPosition = (screenSize.size.width - textWidth) / 2;

    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(leftPosition, self.dateTitle.layer.position.y + 25.0, textWidth, screenSize.size.height / 2) textContainer:nil];
    [self.textView setText:self.sceneModel.description];
    self.textView.scrollEnabled = YES;
    [self.textView setTextAlignment:NSTextAlignmentCenter];
    [self.textView setEditable:NO];
    [self.textView setBackgroundColor:[UIColor clearColor]];
    [self.textView setTextColor:[UIColor blackColor]];
    self.textView.font = [UIFont fontWithName:@"BrandonGrotesque-LightItalic" size:13.0];
    [self.view addSubview:self.textView];
}

- (void)initSlider {
    CGRect screenSize = [OrientationUtils nativeLandscapeDeviceSize];
    CGFloat buttonSize = 40;
    CGRect sliderFrame = CGRectMake(screenSize.size.width - buttonSize, 0, buttonSize, screenSize.size.height);

	UIView *sliderZoneBackground = [[UIView alloc] initWithFrame:sliderFrame];
	sliderZoneBackground.backgroundColor = [UIColor lightColor];
    [self.view addSubview:sliderZoneBackground];

    self.sliderZone = [[UIView alloc] initWithFrame:CGRectMake(screenSize.size.width - buttonSize, 0, buttonSize, buttonSize)];
    self.sliderZone.backgroundColor = [UIColor sliderColor];
    [self.view addSubview:self.sliderZone];

    CALayer *leftBorder = [CALayer layer];
    leftBorder.borderColor = [UIColor blackColor].CGColor;
    leftBorder.borderWidth = 1;
    leftBorder.frame = CGRectMake(-1, -1, sliderZoneBackground.frame.size.width + 2, sliderZoneBackground.frame.size.height + 2);
    [sliderZoneBackground.layer addSublayer:leftBorder];

    NSInteger nextSceneNumber = self.sceneModel.number >= [[DataManager sharedInstance] getScenesNumber] - 1 ? 0 : self.sceneModel.number + 1;
    if(nextSceneNumber > 0) {
        UILabel *nextSceneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, buttonSize, buttonSize)];
        nextSceneLabel.text = [NSString stringWithFormat:@"%i", nextSceneNumber];
        nextSceneLabel.textAlignment = NSTextAlignmentCenter;
        nextSceneLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Bold" size:15];
        nextSceneLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:nextSceneLabel];
        [nextSceneLabel moveTo:CGPointMake(self.view.bounds.size.width - nextSceneLabel.bounds.size.width, 0)];
    }

    self.slidingButton = [[SceneSlider alloc] initWithFrame:self.sliderZone.frame andAmplitude:screenSize.size.height - buttonSize / 2 andThreshold:0.9];
    [self.view addSubview:self.slidingButton.view];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSliderZone) name:[MPPEvents SliderHasMovedEvent] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSliderZone) name:[MPPEvents ResetSliderEvent] object:nil];
}

- (void)updateSliderZone {
	CGRect zoneFrame = self.sliderZone.frame;
    CGSize zoneSize = CGSizeMake(self.sliderZone.frame.size.width, self.slidingButton.sliderDistance);
    zoneFrame.size = zoneSize;
    self.sliderZone.frame = zoneFrame;
}

- (void)resetSliderZone {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect screenSize = [OrientationUtils nativeLandscapeDeviceSize];
        NSInteger buttonSize = 40;
        self.sliderZone.frame = CGRectMake(screenSize.size.width - buttonSize, 0, buttonSize, buttonSize);
    }];
}

@end
