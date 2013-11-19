//
//  SceneSlider.m
//  Picasso
//
//  Created by MOREL Florian on 30/10/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "SceneSlider.h"
#import "Colors.h"
#import "Events.h"

@interface SceneSlider ()

@property (strong, nonatomic) UIButton *button;
@property (assign, nonatomic) int sliderBasePosition;
@property (assign, nonatomic) float sliderAmplitude;
@property (assign, nonatomic) float sliderDistanceThreshold;
@property (strong, nonatomic) UIColor *baseColor;
@property (strong, nonatomic) UIColor *readyColor;

@end

@implementation SceneSlider

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andAmplitude:(float)amplitude andThreshold:(float)threshold {
    if(self = [super init]) {
        self.baseColor = [UIColor blueColor];
        self.readyColor = [UIColor purpleColor];
        
        [self initButtonWithFrame:frame];

        self.sliderAmplitude = amplitude;
        self.sliderBasePosition = self.button.frame.size.height / 2;
        self.sliderDistanceThreshold = (self.sliderAmplitude - self.sliderBasePosition) * threshold;
    }
    return self;
}

- (void)initButtonWithFrame:(CGRect)frame {
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.backgroundColor = [UIColor textColor];
    [self.button setImage:[UIImage imageNamed:@"sliderInterstitial.png"] forState:UIControlStateNormal];
    [self.view setFrame:frame];
    [self.button setFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
    [self.button addTarget:self action:@selector(sliderDragStarted:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.button addTarget:self action:@selector(sliderDragEnded:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.button];
}

- (void)sliderDragStarted:(id)sender withEvent:(UIEvent *)event {
    // Get and normalize the position of the button
    CGFloat touchY = [[[event allTouches] anyObject] locationInView:self.view].y;
    touchY = MAX(MIN(touchY, self.sliderAmplitude), self.sliderBasePosition);
    self.button.center = CGPointMake(self.button.center.x, touchY);
    self.sliderDistance = touchY - self.sliderBasePosition;

	[[NSNotificationCenter defaultCenter] postNotificationName:[MPPEvents SliderHasMovedEvent] object:self];

    /*if(self.sliderDistance > self.sliderDistanceThreshold) {
        // Visual feedback that it's down enough
        [UIView animateWithDuration:0.2f animations:^{
            [self.button setBackgroundColor:self.readyColor];
        }];
    }
    else {
        [UIView animateWithDuration:0.2f animations:^{
            [self.button setBackgroundColor:self.baseColor];
        }];
    }*/
}

- (void)sliderDragEnded:(id)sender withEvent:(UIEvent *)event {
    if(self.sliderDistance > self.sliderDistanceThreshold) {
        // create new scene
        [self.delegate skipInterstitial];
        [self resetSlidingButtonPositionWithDuration:0.5f];
    }
    else {
        // Replace the slidingButton at his default position
        [self resetSlidingButtonPositionWithDuration:0.3f];
    }
}

- (void)resetSlidingButtonPositionWithDuration:(float)duration {
    [[NSNotificationCenter defaultCenter] postNotificationName:[MPPEvents ResetSliderEvent] object:self];
    [UIView animateWithDuration:duration animations:^{
        self.button.center = CGPointMake(self.button.center.x, self.sliderBasePosition);
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
