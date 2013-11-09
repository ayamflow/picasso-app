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
#import "Constants.h"

#define MARGIN 15

@interface SceneInterstitial ()

@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UIButton *retryButton;
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
    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}

- (id)initWithModel:(SceneModel *)sceneModel {
    if(self = [super init]) {
        [self.view setFrame:[OrientationUtils deviceSize]];
        self.description = sceneModel.description;

		DataManager *dataManager = [DataManager sharedInstance];
        int currentSceneId = [[dataManager getGameModel] currentScene];

        if(currentSceneId < [dataManager getScenesNumber] - 1) {
	    	[[dataManager getSceneWithNumber:currentSceneId + 1] unlockScene];
        }

		[self initOverlay]; // Maybe put it directly on the scene so its opacity can be animated with the video progress

        [self initTitle:sceneModel.title];
        [self initDate:sceneModel.date];
        [self initText];
//        [self initButtons];
        [self initSlider];
    }
    return self;
}

- (void)initOverlay {
    UIView *overlay = [[UIView alloc] initWithFrame:[OrientationUtils nativeLandscapeDeviceSize]];
    overlay.backgroundColor = [UIColor darkColor];
    overlay.alpha = 0.98;
    [self.view addSubview:overlay];
}

- (void)initTitle:(NSString *)title {
    self.sceneTitle = [[UILabel alloc] initWithFrame:CGRectMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - 100.0, 50.0, 200.0, 40.0)];
    self.sceneTitle.text = [title uppercaseString];
    [self.sceneTitle setTextAlignment:NSTextAlignmentCenter];
    self.sceneTitle.textColor = [UIColor lightColor];
    self.sceneTitle.font = [UIFont fontWithName:@"BrandonGrotesque-Bold" size:15.0];

    self.sceneTitle.layer.borderColor = [UIColor lightColor].CGColor;
    self.sceneTitle.layer.borderWidth = 2.0;

    [self.view addSubview:self.sceneTitle];
}

- (void)initDate:(NSString *)date {
    self.dateTitle = [[UILabel alloc] initWithFrame:CGRectMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - 50.0, 90.0, 100.0, 45.0)];
    self.dateTitle.text = date;
    self.dateTitle.textColor = [UIColor lightColor];
    [self.dateTitle setTextAlignment:NSTextAlignmentCenter];
    self.dateTitle.font = [UIFont fontWithName:@"Avenir" size:12.0];
    [self.view addSubview:self.dateTitle];

    UIImageView *dateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dateTitleSign.png"]];
	dateImageView.layer.position = CGPointMake([OrientationUtils nativeLandscapeDeviceSize].size.width / 2 - dateImageView.frame.size.width / 2 + 7.0, 130.0);
    [self.view addSubview:dateImageView];
}

- (void)initText {
    CGRect screenSize = [OrientationUtils nativeLandscapeDeviceSize];

    float textWidth = screenSize.size.width * 0.45;
    float leftPosition = (screenSize.size.width - textWidth) / 2;

    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(leftPosition, self.dateTitle.layer.position.y + 25.0, textWidth, screenSize.size.height / 2) textContainer:nil];
    [self.textView setText:self.description];
    self.textView.scrollEnabled = YES;
    [self.textView setTextAlignment:NSTextAlignmentJustified];
    [self.textView setEditable:NO];
    [self.textView setBackgroundColor:[UIColor clearColor]];
    [self.textView setTextColor:[UIColor lightColor]];
    self.textView.font = [UIFont fontWithName:@"BrandonGrotesque-LightItalic" size:13.0];
    [self.view addSubview:self.textView];
}

/*- (void)initButtons {
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
}*/

- (void)initSlider {
    CGRect screenSize = [OrientationUtils nativeLandscapeDeviceSize];
    int buttonSize = 40;
    CGRect sliderFrame = CGRectMake(screenSize.size.width - buttonSize, 0, buttonSize, screenSize.size.height);

	UIView *sliderZoneBackground = [[UIView alloc] initWithFrame:sliderFrame];
	sliderZoneBackground.backgroundColor = [UIColor lightColor];
    [self.view addSubview:sliderZoneBackground];

    self.sliderZone = [[UIView alloc] initWithFrame:CGRectMake(screenSize.size.width - buttonSize, 0, buttonSize, buttonSize)];
    self.sliderZone.backgroundColor = [UIColor sliderColor];
    [self.view addSubview:self.sliderZone];

    self.slidingButton = [[SceneSlider alloc] initWithFrame:sliderFrame andAmplitude:screenSize.size.height - buttonSize / 2 andThreshold:0.7];
    [self.view addSubview:self.slidingButton.view];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSliderZone) name:@"sliderHasMoved" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSliderZone) name:@"resetSlider" object:nil];
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
        int buttonSize = 40;
        self.sliderZone.frame = CGRectMake(screenSize.size.width - buttonSize, 0, buttonSize, buttonSize);
    }];
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
