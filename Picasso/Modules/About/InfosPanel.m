//
//  InfosPanel.m
//  Picasso
//
//  Created by MOREL Florian on 27/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "InfosPanel.h"
#import "OrientationUtils.h"
#import "UIViewPicasso.h"
#import "Colors.h"

#define kLineHeight 15

@interface InfosPanel ()

@end

@implementation InfosPanel

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initAddress];
    [self initMetros];
    
    [self.view sizeToFit];
    [self.view clipsToBounds];
}

- (void)initAddress {
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeDeviceSize].size.width, kLineHeight)];
    address.text = @"5 rue de Thorigny";
    address.font = [UIFont fontWithName:@"Avenir-Book" size:12];
    [address setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:address];
    [address moveTo:CGPointMake(0, kLineHeight)];
    
    UILabel *city = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeDeviceSize].size.width, kLineHeight)];
    city.text = @"75003 Paris";
    city.font = [UIFont fontWithName:@"Avenir-Book" size:12];
    [city setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:city];
    [city moveTo:CGPointMake(0, kLineHeight * 2)];
    
    UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeDeviceSize].size.width, kLineHeight)];
    phone.text = @"+ 33 (0)1 42 71 25 21";
    phone.font = [UIFont fontWithName:@"Avenir-Book" size:12];
    [phone setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:phone];
    [phone moveTo:CGPointMake(0, kLineHeight * 4)];
}

- (void)initMetros {
    UILabel *metro1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeDeviceSize].size.width, kLineHeight)];
    metro1.text = @"St-Paul";
    metro1.font = [UIFont fontWithName:@"Avenir-Book" size:12];
    [metro1 setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:metro1];
    [metro1 moveTo:CGPointMake(0, kLineHeight * 6)];
    
    UILabel *metro8 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeDeviceSize].size.width, kLineHeight)];
    metro8.text = @"St-Sébastien Froissart";
    metro8.font = [UIFont fontWithName:@"Avenir-Book" size:12];
    [metro8 setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:metro8];
    [metro8 moveTo:CGPointMake(0, kLineHeight * 7)];
    
    UILabel *metro8bis = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeDeviceSize].size.width, kLineHeight)];
    metro8bis.text = @"Chemin Vert";
    metro8bis.font = [UIFont fontWithName:@"Avenir-Book" size:12];
    [metro8bis setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:metro8bis];
    [metro8bis moveTo:CGPointMake(0, kLineHeight * 8)];
    
    UILabel *bus = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeDeviceSize].size.width, kLineHeight)];
    bus.text = @"29 - 96 - 69 - 75";
    bus.font = [UIFont fontWithName:@"Avenir-Book" size:12];
    [bus setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:bus];
    [bus moveTo:CGPointMake(0, kLineHeight * 10)];
    
    UILabel *metroIcon = [self createTransportIconWithLetter:@"M"];
    [self.view addSubview:metroIcon];
    [metroIcon moveTo:CGPointMake(25, metro8.frame.origin.y)];
    
    UILabel *busIcon = [self createTransportIconWithLetter:@"B"];
    [self.view addSubview:busIcon];
    [busIcon moveTo:CGPointMake(25, bus.frame.origin.y)];
    
    UILabel *metroLine1Icon = [self createMetroLineIconWithNumber:1];
    [self.view addSubview:metroLine1Icon];
    [metroLine1Icon moveTo:CGPointMake(50, metro1.frame.origin.y)];
    
    UILabel *metroLine8Icon = [self createMetroLineIconWithNumber:8];
    [self.view addSubview:metroLine8Icon];
    [metroLine8Icon moveTo:CGPointMake(50, metro8.frame.origin.y)];
    
    UILabel *metroLine8IconBis = [self createMetroLineIconWithNumber:8];
    [self.view addSubview:metroLine8IconBis];
    [metroLine8IconBis moveTo:CGPointMake(50, metro8bis.frame.origin.y)];
}

- (UILabel *)createTransportIconWithLetter:(NSString *)letter {
    UILabel *metroIcon = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    metroIcon.text = letter;
    metroIcon.font = [UIFont fontWithName:@"Avenir-Book" size:13];
    metroIcon.layer.cornerRadius = metroIcon.frame.size.width / 2;
    metroIcon.layer.borderColor = [UIColor blackColor].CGColor;
    metroIcon.layer.borderWidth = 1;
    [metroIcon setTextAlignment:NSTextAlignmentCenter];
    return metroIcon;
}

- (UILabel *)createMetroLineIconWithNumber:(NSInteger)lineNumber {
    UILabel *metroLineIcon = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    metroLineIcon.text = [NSString stringWithFormat:@"%li", lineNumber];
    metroLineIcon.textColor = [UIColor whiteColor];
    metroLineIcon.font = [UIFont fontWithName:@"Avenir-Book" size:13];
    metroLineIcon.layer.cornerRadius = metroLineIcon.frame.size.width / 2;
    metroLineIcon.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    [metroLineIcon setTextAlignment:NSTextAlignmentCenter];
    return metroLineIcon;

}

@end
