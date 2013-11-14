//
//  WorkFullViewController.m
//  Picasso
//
//  Created by RENARD Julian on 13/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "WorkFullViewController.h"
#import "OrientationUtils.h"
#import "UIImage+ImageEffects.h"

@interface WorkFullViewController ()

@property (nonatomic, strong) CALayer *maskLayer;

@end

@implementation WorkFullViewController

CGRect deviceSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    deviceSize = [OrientationUtils deviceSize];
    NSLog(@"device size %f", deviceSize.size.width);
    
    NSString *workImageFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat: @"%d.jpg", self.workId]];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, deviceSize.size.width, deviceSize.size.height)];
    [self.view addSubview:backgroundView];
    
    firstView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, deviceSize.size.width, deviceSize.size.height)];
    [firstView setContentSize:CGSizeMake(deviceSize.size.width, 4300)];
    [firstView setDelegate:self];
    [self.view addSubview:firstView];
    
    /*
    frontView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, heigth)];
    [frontView setContentSize:CGSizeMake(320, 500)];
    
    [frontView setDelegate:self];
    [self.view addSubview:frontView];
    */
     
    NSString *backgroundFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"background-dev.png"];
    UIImageView *background = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:backgroundFile]];
    [backgroundView addSubview:background];
    
    backgroundFirstView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:workImageFile]];
    [firstView addSubview:backgroundFirstView];
    backgroundFirstView.frame = CGRectMake(0, 0,deviceSize.size.width, 4300);
    backgroundFirstView.image = [backgroundFirstView.image applyDarkEffect];
    
    /*
    self.workImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.workImage setClipsToBounds:YES];
    self.workImage.userInteractionEnabled = YES;
    NSString *imageUrl = [NSString stringWithFormat: @"%d.jpg", self.workId];
    self.workImage.image = [UIImage imageNamed:imageUrl];
    self.workImage.layer.zPosition = 1;
    */
    
    /*
    // load image into second scrollview
    fileLocation = [[NSBundle mainBundle] pathForResource:@"parallax-02.png" ofType:nil];
    aImage = [[UIImage alloc] initWithContentsOfFile:fileLocation];
    aImageView = [[UIImageView alloc] initWithImage:aImage];
    aImageView.frame = CGRectMake(0, 0, aImage.size.width, aImage.size.height);
    [_secondScrollView addSubview:aImageView];
    [aImage release];
    aImage = nil;
    [aImageView release];
    
    
    // load image into third scrollview
    fileLocation = [[NSBundle mainBundle] pathForResource:@"parallax-01.png" ofType:nil];
    aImage = [[UIImage alloc] initWithContentsOfFile:fileLocation];
    aImageView = [[UIImageView alloc] initWithImage:aImage];
    aImageView.frame = CGRectMake(0, 0, aImage.size.width, aImage.size.height);
    [_thirdScrollView addSubview:aImageView];
    [aImage release];
    aImage = nil;
    [aImageView release];
    */
     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
