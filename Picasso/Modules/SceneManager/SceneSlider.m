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

@property (assign, nonatomic) CGRect buttonFrame;
@property (strong, nonatomic) UIButton *button;
@property (assign, nonatomic) NSInteger sliderBasePosition;
@property (assign, nonatomic) CGFloat sliderAmplitude;
@property (assign, nonatomic) CGFloat sliderDistanceThreshold;

@end

@implementation SceneSlider

- (id)initWithFrame:(CGRect)frame andAmplitude:(CGFloat)amplitude andThreshold:(CGFloat)threshold {
    if(self = [super init]) {
        self.buttonFrame = frame;
        self.sliderAmplitude = amplitude;
        self.sliderBasePosition = self.buttonFrame.size.height / 2;
        self.sliderDistanceThreshold = (self.sliderAmplitude - self.sliderBasePosition - self.buttonFrame.size.height) * threshold;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initButtonWithFrame];
}

- (void)initButtonWithFrame {
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.backgroundColor = [UIColor sliderColor];
    [self.button setImage:[UIImage imageNamed:@"sceneSlider.png"] forState:UIControlStateNormal];
    [self.view setFrame:self.buttonFrame];
    [self.button setFrame:CGRectMake(0, 0, self.buttonFrame.size.width, self.buttonFrame.size.width)];
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
}

- (void)sliderDragEnded:(id)sender withEvent:(UIEvent *)event {
    if(self.sliderDistance > self.sliderDistanceThreshold) {
        // create new scene
        [[NSNotificationCenter defaultCenter] postNotificationName:[MPPEvents SkipInterstitialEvent] object:nil];
    }
    else {
        // Replace the slidingButton at his default position
        [self resetSlidingButtonPositionWithDuration:0.3f];
    }
}

- (void)resetSlidingButtonPositionWithDuration:(CGFloat)duration {
    [[NSNotificationCenter defaultCenter] postNotificationName:[MPPEvents ResetSliderEvent] object:self];
    [UIView animateWithDuration:duration animations:^{
        self.button.center = CGPointMake(self.button.center.x, self.sliderBasePosition);
    }];
}

@end
