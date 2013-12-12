//
//  SceneTimeline.m
//  Picasso
//
//  Created by MOREL Florian on 25/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "SceneTimeline.h"
#import "SceneModel.h"
#import "OrientationUtils.h"
#import "Colors.h"
#import "UIViewPicasso.h"

#define kTimelineHeight 45
#define kTimelineWidthRatio 0.8
#define kInactiveTrackerAlpha 0.4

@interface SceneTimeline ()

@property (strong, nonatomic) SceneModel *sceneModel;
@property (assign, nonatomic) float timelineWidth;
@property (strong, nonatomic) UIView *progressBar;
@property (strong, nonatomic) NSMutableArray *trackers;

@end

@implementation SceneTimeline

- (id)initWithModel:(SceneModel *)model {
    if(self = [super init]) {
        self.sceneModel = model;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view = [[UIView alloc] initWithFrame:[OrientationUtils nativeLandscapeDeviceSize]];
    self.timelineWidth = [OrientationUtils nativeLandscapeDeviceSize].size.width * kTimelineWidthRatio;

    // create background line
    [self initTimelineBackground];
    // create progress bar
    [self initProgressBar];
    // create starting dot
    [self initTrackers];

    self.view.frame = CGRectMake(0, 0, [OrientationUtils nativeLandscapeDeviceSize].size.width, kTimelineHeight);
}

- (void)initTimelineBackground {
	UIView *area = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeLandscapeDeviceSize].size.width, kTimelineHeight)];
//    area.backgroundColor = [UIColor blueColor];
//    area.alpha = 0.3;
    [self.view addSubview:area];

    UIView *backgroundTl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.timelineWidth, 2)];
    backgroundTl.backgroundColor = [UIColor grayColor];
    [backgroundTl moveTo:CGPointMake(([OrientationUtils nativeLandscapeDeviceSize].size.width - backgroundTl.frame.size.width) / 2, kTimelineHeight / 2 - backgroundTl.frame.size.height / 2)];
    [self.view addSubview:backgroundTl];

    UIView *start = [self createCircleWithRadius:8];
    [self.view addSubview:start];
    [start moveTo:CGPointMake(backgroundTl.frame.origin.x, backgroundTl.frame.origin.y - start.frame.size.height / 2 + 1)];

    UIView *end = [self createCircleWithRadius:8];
    [self.view addSubview:end];
    end.backgroundColor = [UIColor grayColor];
    [end moveTo:CGPointMake(backgroundTl.frame.origin.x + backgroundTl.frame.size.width, backgroundTl.frame.origin.y - start.frame.size.height / 2 + 1)];
}

- (void)initProgressBar {
    self.progressBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.timelineWidth, 2)];
    self.progressBar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.progressBar];
    self.progressBar.layer.anchorPoint = CGPointMake(0, 0);
    [self.progressBar moveTo:CGPointMake(([OrientationUtils nativeLandscapeDeviceSize].size.width - self.progressBar.frame.size.width) / 2, kTimelineHeight / 2 - self.progressBar.frame.size.height / 2)];
    self.progressBar.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 1);
}

- (void)initTrackers {
    self.trackers = [NSMutableArray arrayWithCapacity:[self.sceneModel.trackerStarts count]];
    for(int i = 0; i < [self.sceneModel.trackerStarts count]; i++) {
        UIView *tracker = [self createTrackerActivated:NO];
        [self.trackers addObject:tracker];
        [self.view addSubview:tracker];
        [tracker moveTo:CGPointMake( self.progressBar.center.x + self.timelineWidth / 100 * [[self.sceneModel.trackerStarts objectAtIndex:i] intValue], self.progressBar.frame.origin.y + self.progressBar.frame.size.height / 2 - tracker.frame.size.height / 2)];
        tracker.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_4);
    }
}

- (UIView *)createTrackerActivated:(BOOL)activated {
    UIView *tracker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
    if(activated) tracker.backgroundColor = [UIColor blackColor];
    else tracker.backgroundColor = [UIColor grayColor];
    return tracker;
}

- (void)updateWithCompletion:(CGFloat)completion {
    if(completion < 0.0) return;
    self.progressBar.transform = CGAffineTransformScale(CGAffineTransformIdentity, completion, 1);

    for(int i = 0; i < [self.sceneModel.trackerStarts count]; i++) {
        UIView *tracker = [self.trackers objectAtIndex:i];
        NSInteger trackerStart = [[self.sceneModel.trackerStarts objectAtIndex:i] intValue];
        if(completion * 100 > trackerStart && tracker.backgroundColor != [UIColor blackColor]) {
            [UIView animateWithDuration:0.3 animations:^{
                tracker.backgroundColor = [UIColor blackColor];
            }];
        }
        else if(completion * 100 < trackerStart && tracker.backgroundColor != [UIColor grayColor]) {
            [UIView animateWithDuration:0.3 animations:^{
                tracker.backgroundColor = [UIColor grayColor];
            }];
        }
    }
}

- (UIView *)createCircleWithRadius:(CGFloat)radius {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, radius, radius)];
    view.layer.cornerRadius = radius / 2;
    view.backgroundColor = [UIColor blackColor];
    return view;
}

@end
