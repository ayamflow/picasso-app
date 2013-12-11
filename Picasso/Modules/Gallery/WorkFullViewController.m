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
#import "A3ParallaxScrollView.h"
#import "Colors.h"

@interface WorkFullViewController ()

@property (nonatomic, strong) A3ParallaxScrollView *parallaxScrollView;
@property (nonatomic, strong) UIImageView *mapBackgroundView;
@property (nonatomic, strong) UIImageView *gridBackgroundView;
@property (nonatomic, strong) UIImageView *imageWorkView;
@property (nonatomic, strong) DataManager *datamanager;
@property (nonatomic, strong) WorkModel *work;

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
    
    _datamanager = [[DataManager sharedInstance] init];
    _work = [_datamanager getWorkWithNumber:self.workId];

    self.parallaxScrollView = [[A3ParallaxScrollView alloc] initWithFrame:self.view.bounds];
    self.parallaxScrollView.delegate = self;
    [self.view addSubview:self.parallaxScrollView];
    
    CGSize contentSize = self.parallaxScrollView.frame.size;
    contentSize.height *= 5.0f;
    
    self.parallaxScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.parallaxScrollView.contentSize = contentSize;
    
    // Scroll Content
    _mapBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"map-bg.png"]]];
    _mapBackgroundView.frame = CGRectMake(60, 65, 478, 408);
    [self.parallaxScrollView addSubview:_mapBackgroundView withAcceleration:CGPointMake(0.0f, 0.2f)];
    
    _gridBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"grid-bg.png"]]];
    _gridBackgroundView.frame = CGRectMake(0, 0, deviceSize.size.width, deviceSize.size.height);
    [self.parallaxScrollView addSubview:_gridBackgroundView withAcceleration:CGPointMake(0.0f, 0.1f)];
    
    NSString *imageName = [NSString stringWithFormat: @"%d.jpg", _workId];
    _imageWorkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    _imageWorkView.frame = CGRectMake(60, deviceSize.size.height + 20, _imageWorkView.frame.size.width/2, _imageWorkView.frame.size.height/2);
    
    [_imageWorkView.layer setBorderColor: [[UIColor textColor] CGColor]];
    [_imageWorkView.layer setBorderWidth: 20.0];
    
    [self.parallaxScrollView addSubview:_imageWorkView withAcceleration:CGPointMake(0.0f, 0.4f)];
    
    _textWorkView.frame = CGRectMake(_imageWorkView.layer.bounds.origin.x + _imageWorkView.layer.bounds.size.width + 61, _imageWorkView.bounds.origin.y + _imageWorkView.bounds.size.height + 60, _textWorkView.frame.size.width, _textWorkView.frame.size.height);
    _textWorkView.backgroundColor = [UIColor whiteColor];
    _textWorkView.layer.masksToBounds = NO;
    _textWorkView.layer.shadowOffset = CGSizeMake(5, 5);
    _textWorkView.layer.shadowRadius = 5;
    _textWorkView.layer.shadowOpacity = 0.1;
    [self.parallaxScrollView addSubview:_textWorkView withAcceleration:CGPointMake(0.0f, 0.5f)];
    
    _titleLabel.layer.zPosition = 1;
    [self.parallaxScrollView addSubview:_titleLabel withAcceleration:CGPointMake(0.0f, 0.5f)];
    
    _headerView.layer.zPosition = 1;
    [self.parallaxScrollView addSubview:_headerView withAcceleration:CGPointMake(0.0f, 0.3f)];
}

-(void)viewDidAppear:(BOOL)animated
{
    _titleWorkLabel.text = [_work.title  uppercaseString];
    _numbersWorkLabel.text = [[NSString stringWithFormat:@"%@ / %ld oeuvres", _work.workId, (long)[_datamanager getWorksNumber]] uppercaseString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end