//
//  HoursPanel.m
//  Picasso
//
//  Created by MOREL Florian on 27/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "HoursPanel.h"
#import "OrientationUtils.h"
#import "UIViewPicasso.h"
#import "ClockNeedleView.h"

#define kDayHeight 15
#define kClockSize 111
#define kClockCenterSize 4

@interface HoursPanel ()

@property (assign, nonatomic) CGFloat totalHeight;

@property (strong, nonatomic) ClockNeedleView *openHour;
@property (strong, nonatomic) ClockNeedleView *openMinute;
@property (strong, nonatomic) ClockNeedleView *closedHour;
@property (strong, nonatomic) ClockNeedleView *closedMinute;

@end

@implementation HoursPanel

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initClocks];
    [self transitionIn];
}

- (void)initClocks {
    [self initClockWithView:self.openClock];
    [self initClockWithView:self.closeClock];
    
    self.openHour = [self createNeedleWithLineWidth:30];
    [self.openClock addSubview:self.openHour];

    self.openMinute = [self createNeedleWithLineWidth:40];
    [self.openClock addSubview:self.openMinute];
    
    self.closedHour = [self createNeedleWithLineWidth:30];
    [self.closeClock addSubview:self.closedHour];
    
    self.closedMinute = [self createNeedleWithLineWidth:40];
    [self.closeClock addSubview:self.closedMinute];
}

- (void)initClockWithView:(UIView *)view {
    view.layer.cornerRadius = kClockSize / 2;
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    view.layer.shadowRadius = 5;
    view.layer.shadowOpacity = 0.5;
}

- (ClockNeedleView *)createNeedleWithLineWidth:(CGFloat)lineWidth {
    ClockNeedleView *needle = [[ClockNeedleView alloc] initWithFrame:self.openClock.bounds];
    needle.lineLength = 40;
    needle.layer.anchorPoint = CGPointMake(0.5, 0.5);
    needle.backgroundColor = [UIColor clearColor];
    return needle;
}

- (void)transitionIn {
    NSTimeInterval duration = 0.5;
    [UIView animateWithDuration:duration delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.openHour.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI * 2 + M_PI * 2 / 3);
    } completion:nil];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.openMinute.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI * 2 + M_PI);
    } completion:nil];
    
    [UIView animateWithDuration:duration delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.closedHour.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI * 2 + M_PI / 6);
    } completion:nil];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.closedMinute.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI * 2 + M_PI);
    } completion:nil];
}

@end