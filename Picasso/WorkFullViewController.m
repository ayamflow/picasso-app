//
//  WorkFullViewController.m
//  Picasso
//
//  Created by RENARD Julian on 13/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "WorkFullViewController.h"

@interface WorkFullViewController ()

@end

@implementation WorkFullViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat heigth = [UIScreen mainScreen].bounds.size.height;
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    backgroundView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, heigth)];
    [backgroundView setContentSize:CGSizeMake(320, 2000)];
    [self.view addSubview:backgroundView];
    
    middleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, heigth)];
    [middleView setContentSize:CGSizeMake(320, 1000)];
    [self.view addSubview:middleView];
    
    frontView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, heigth)];
    [frontView setContentSize:CGSizeMake(320, 500)];
    
    [frontView setDelegate:self];
    [self.view addSubview:frontView];
    
    NSString *backgroundFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"background-dev.png"];
    UIImageView *background = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:backgroundFile]];
    [backgroundView addSubview:background];
    
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
