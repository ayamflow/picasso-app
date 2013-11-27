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

#define kDayHeight 15
#define kClockSize 111

@interface HoursPanel ()

@property (assign, nonatomic) CGFloat totalHeight;

@end

@implementation HoursPanel

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initClocks];
    [self initHours];
    
    [self.view sizeToFit];
    [self.view clipsToBounds];
    
//    CGRect frame = self.view.frame;
//    frame.size = CGSizeMake(frame.size.width, self.totalHeight);
//    self.view.frame = frame;
}

- (void)initClocks {
    UIView *openClock = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kClockSize, kClockSize)];
    openClock.layer.cornerRadius = kClockSize / 2;
    openClock.backgroundColor = [UIColor blackColor];
    openClock.layer.masksToBounds = NO;
    openClock.layer.shadowOffset = CGSizeMake(0, 0);
    openClock.layer.shadowRadius = 5;
    openClock.layer.shadowOpacity = 0.5;
    [self.view addSubview:openClock];
    [openClock moveTo:CGPointMake(25, 25)];
    
    UIView *closeClock = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kClockSize, kClockSize)];
    closeClock.layer.cornerRadius = kClockSize / 2;
    closeClock.backgroundColor = [UIColor blackColor];
    closeClock.layer.masksToBounds = NO;
    closeClock.layer.shadowOffset = CGSizeMake(0, 0);
    closeClock.layer.shadowRadius = 5;
    closeClock.layer.shadowOpacity = 0.5;
    [self.view addSubview:closeClock];
    [closeClock moveTo:CGPointMake([OrientationUtils nativeDeviceSize].size.width - 25 - closeClock.frame.size.width, 25)];
    
    self.totalHeight = openClock.frame.size.height + closeClock.frame.size.height + 50;
}

- (void)initHours {
    NSArray *days = @[@"Lundi", @"Mardi", @"Mercredi", @"Jeudi", @"Vendredi", @"Samedi"];
    
    NSMutableArray *dayLabels = [[NSMutableArray alloc] initWithCapacity:[days count]];
    NSMutableArray *hourLabels = [[NSMutableArray alloc] initWithCapacity:[days count]];
    
    CGFloat topOffset = 25 + kClockSize;
    self.totalHeight += topOffset;
    
    int i = 1;
    for(NSString *day in days) {
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeDeviceSize].size.width / 2, kDayHeight)];
        dayLabel.text = day;
        dayLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:12];
        [dayLabel moveTo:CGPointMake([OrientationUtils nativeDeviceSize].size.width * 0.05, topOffset + i * kDayHeight)];
        
        [self.view addSubview:dayLabel];
        [dayLabels addObject:dayLabel];
        
        UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeDeviceSize].size.width / 2, kDayHeight)];
        hourLabel.text = @"10h-13h / 14h-19h";
        [hourLabel setTextAlignment:NSTextAlignmentRight];
        hourLabel.font = [UIFont fontWithName:@"Avenir-Book" size:12];
        [hourLabel moveTo:CGPointMake([OrientationUtils nativeDeviceSize].size.width - hourLabel.frame.size.width - [OrientationUtils nativeDeviceSize].size.width * 0.05, topOffset + i * kDayHeight)];
        
        [self.view addSubview:hourLabel];
        [hourLabels addObject:hourLabel];
        i++;
        self.totalHeight += dayLabel.frame.size.height;
    }
}

@end
