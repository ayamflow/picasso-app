//
//  WorkFullViewController.m
//  Picasso
//
//  Created by RENARD Julian on 13/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "DataManager.h"
#import "WorkModel.h"
#import "WorkFullViewController.h"
#import "OrientationUtils.h"
#import "UIImage+ImageEffects.h"
#import "A3ParallaxScrollView.h"

@interface WorkFullViewController ()

@property (nonatomic, strong) CALayer *maskLayer;
@property (nonatomic, retain) A3ParallaxScrollView *parallaxScrollView;

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
    WorkModel *workModel = [[[DataManager sharedInstance] getWorkWithNumber:self.workId] init];
    
    backgroundView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"background-dev.png"]]];
    [self.view addSubview:backgroundView];
    
    self.parallaxScrollView = [[A3ParallaxScrollView alloc] initWithFrame:self.view.bounds];
    self.parallaxScrollView.delegate = self;
    [self.view addSubview:self.parallaxScrollView];
    
    CGSize contentSize = self.parallaxScrollView.frame.size;
    contentSize.height *= 5.0f;
    
    self.parallaxScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.parallaxScrollView.contentSize = contentSize;
    
    // Add scroll content
    backgroundWorkView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat: @"%d.jpg", self.workId]]]];
    backgroundWorkView.frame = CGRectMake(0, 0,deviceSize.size.width, 4300);
    backgroundWorkView.image = [backgroundWorkView.image applyDarkEffect];
    [self.parallaxScrollView addSubview:backgroundWorkView withAcceleration:CGPointMake(0.0f, 0.2f)];

    headerView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, deviceSize.size.width - 40, deviceSize.size.height - 40)];
    headerView.backgroundColor = [UIColor clearColor];
    
    [headerView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [headerView.layer setBorderWidth:2.0];
    [self.parallaxScrollView addSubview:headerView withAcceleration:CGPointMake(0.0f, 0.5)];
    
    UILabel *headerViewContent = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    headerViewContent.text = [workModel.title uppercaseString];
    headerViewContent.textColor = [UIColor whiteColor];
    headerViewContent.font = [headerViewContent.font fontWithSize:25];
    [headerViewContent setCenter:CGPointMake(headerView.frame.size.width / 2, headerView.frame.size.height / 2)];
    [headerView addSubview:headerViewContent];
    
    workDescriptionView = [[UIView alloc] initWithFrame:CGRectMake(deviceSize.size.width - 300, deviceSize.size.height + 100, 600, 800)];
    workDescriptionView.backgroundColor = [UIColor whiteColor];
    [self.parallaxScrollView addSubview:workDescriptionView withAcceleration:CGPointMake(0.0f, 0.5)];

    UITextView *workDescriptionViewContent = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 600, 200)];
    workDescriptionViewContent.text = workModel.description;
    [workDescriptionViewContent sizeToFit];
    [workDescriptionViewContent setCenter:CGPointMake(workDescriptionView.frame.size.width / 2, workDescriptionView.frame.origin.y)];
    [workDescriptionView addSubview:workDescriptionViewContent];
    
    workImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", self.workId]]];
    CGRect workImageViewFrame = workImageView.frame;
    workImageViewFrame.origin.x = 40;
    workImageViewFrame.origin.y = deviceSize.size.height + 20;
    workImageView.frame = workImageViewFrame;
    [self.parallaxScrollView addSubview:workImageView withAcceleration:CGPointMake(0.0f, 0.9)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
